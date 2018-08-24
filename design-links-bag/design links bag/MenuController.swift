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
    
    let json : String = """
{"items":[{"title":"Marketing:","itemList":[{"link":"https://docs.google.com/spreadsheets/d/1Y1J2egElnVEfTZ6DKsiFZzh31DIzazvrBdEo050kbaQ/edit#gid=1111208739","title":"Marketing Goals"},{"link":"https://docs.google.com/spreadsheets/d/1H-Ui3C_NwHn-GPiqgjRlGLQ0jeftrjNNvAMsKzqwzIU/edit#gid=846988509","title":"Marketing Calendar"},{"link":"https://docs.google.com/spreadsheets/d/1qujqwm3YpzHO4Tb_1T83PIgIh0NhZ1V7ul-wtz-4v7U/edit?usp=drive_web&ouid=117833533093759039675","title":"Marketing Content Dashboard"}]},{"title":"Inbound:","itemList":[{"link":"https://docs.google.com/spreadsheets/d/1hPTIvKTY5OFbIfqW6A3az91IJIkuC8sgVfjKsVS5jLs/edit#gid=0","title":"Blogs"},{"link":"https://docs.google.com/spreadsheets/d/1_Azm3LEo14CJJxvxRRgxyo-NEGdSjdTaFV6MM3AArLo/edit","title":"Nurturing Auditing"},{"link":"https://docs.google.com/spreadsheets/d/1gIyaUZtR3P5ZYF2jwSS_Zj_N1TBTZT2QZm2kAdYAbr0/edit","title":"Social Media Calendar"},{"link":"https://app.triblio.com/login","title":"Triblio"},{"link":"https://app.sproutsocial.com/dashboard/","title":"SproutSocial"},{"link":"https://docs.google.com/spreadsheets/d/1Blb9yvoaaZFR8Az2PnZflC1hHvC5DTpz1BhF8vXrsak/edit#gid=1550851141","title":"List Import"},{"link":"http://moz.com","title":"MOZ"}]},{"title":"Business Intelligence:","itemList":[{"link":"https://docs.google.com/spreadsheets/d/1YrDPofSy_FoXtX35mqB0iNdblMlOkhX_HPWqddiLSsU/edit?usp=sharing","title":"Market Entry"}]},{"title":"Salesforce:","itemList":[{"link":"https://na64.salesforce.com/01Z70000000z0vL","title":"Marketing LatAm Dashboard"}]},{"title":"HubSpot:","itemList":[{"link":"https://app.hubspot.com/email/252686/manage/state/all","title":"Emails"},{"link":"https://app.hubspot.com/pages/252686/manage/landing/domain/all/listing/all","title":"Landing Pages"},{"link":"https://app.hubspot.com/lists/252686/","title":"Lists"},{"link":"https://app.hubspot.com/forms/252686/","title":"Forms"}]}],"id":"306801506800660647"}
"""
    
    @IBOutlet weak var menu: NSMenu!
  
    let menuItemService = MenuItemURLService.getInstance
    let menuItemServiceWeDeploy = MenuItemWeDeployService.getInstance
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    override func awakeFromNib(){
        let icon = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        statusItem.image = icon
        statusItem.menu = menu
        
        self.defineSection(sectionList: deserialize(data: json.data(using: .utf8)!))
    }
    
    public func deserialize(data: Data) -> [MenuItem] {
        let jsonDecoder = JSONDecoder()
        
        return try! jsonDecoder.decode(Result.self, from: data).items
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
        menu.addItem(NSMenuItem.separator())
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
