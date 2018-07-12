//
//  MenuController.swift
//  design links bag
//
//  Created by Camila Luísa Farias on 04/07/18.
//  Copyright © 2018 Camila Luísa Farias. All rights reserved.
//

import Cocoa
import WeDeploy
import SocketIO

class MenuController: NSObject {
    
    @IBOutlet weak var menu: NSMenu!
  
    let menuItemService = MenuItemURLService.getInstance
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    override func awakeFromNib(){
        let icon = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        statusItem.image = icon
        statusItem.menu = menu
     
        menuItemService.fetch { (menuItemList) in
            self.defineSection(sectionList: menuItemList)
        }
    }
    
    @objc func goToLink(_ sender: UrlMenuItem) {
        guard let urlString = sender.url else{
            return
        }
        
        let url = URL(string: urlString)!
        NSWorkspace.shared.open(url)
    }
    
    func defineSection(sectionList : [MenuItem]) {
        //define principal section                                              
        for item in sectionList {
            if item.isSection() {
                //if is a item with a list of sections
               if let firstItem = item.itemList?.first?.itemList?.first, firstItem.itemList == nil {
                    let itemWithSubMenu = createSubmenu(sectionItem: item)
                    self.menu.addItem(itemWithSubMenu)
                    
                  //if is a section
                } else {
                    self.menu.addItem(NSMenuItem.separator())
                    let sectionElement = UrlMenuItem(title: item.title,
                                                     action: nil, keyEquivalent: "")
                    sectionElement.target = self
                    self.menu.addItem(sectionElement)
                
                    guard let sectionItemList = item.itemList else {
                        print("Section without itemList")
                        return
                    }
                    for sectionItem in sectionItemList {
                        if sectionItem.isSection() {
                            let sectionItemElement = createSubmenu(sectionItem: sectionItem)
                            self.menu.addItem(sectionItemElement)
                            
                        } else {
                            let sectionItemElement = UrlMenuItem(title: sectionItem.title,
                                                                 action: #selector(goToLink(_:)),
                                                                 keyEquivalent: "")
                            sectionItemElement.url = sectionItem.link
                            sectionItemElement.target = self
                            self.menu.addItem(sectionItemElement)
                        }
                        
                    }
                }
               //if is a principal item
            } else {
                let itemElement = UrlMenuItem(title: item.title, action: #selector(goToLink(_:)),
                                              keyEquivalent: "")
                itemElement.url = item.link
                itemElement.target = self
                self.menu.addItem(itemElement)
            }
        }
        menu.addItem(NSMenuItem(
            title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }
    
    func createSubmenu(sectionItem : MenuItem) -> NSMenuItem {
        let itemWithSubMenu = UrlMenuItem(title: sectionItem.title, action: nil, keyEquivalent: "")
        let subMenu = NSMenu()
        
        for subSection in sectionItem.itemList! {
            if subSection.isSection() {
                subMenu.addItem(NSMenuItem.separator())
                let subSectionElement = UrlMenuItem(title: subSection.title, action: nil,
                                                    keyEquivalent: "")
                subSectionElement.target = self
                subMenu.addItem(subSectionElement)
                
                if let subItemList = subSection.itemList {
                    for subItem in subItemList {
                        let subItemElement = UrlMenuItem(title: subItem.title,
                                                         action:  #selector(goToLink(_:)),
                                                         keyEquivalent: "")
                        subItemElement.url = subItem.link
                        subItemElement.target = self
                        subMenu.addItem(subItemElement)
                    }
                }
            } else {
                let subItem = UrlMenuItem(title: subSection.title,
                                          action: #selector(goToLink(_:)), keyEquivalent: "")
                subItem.url = subSection.link
                subItem.target = self
                subMenu.addItem(subItem)
            }
        }
        
        itemWithSubMenu.submenu = subMenu
        itemWithSubMenu.target = self
        
        return itemWithSubMenu
    }
}

class UrlMenuItem: NSMenuItem {
    var url : String?
}
