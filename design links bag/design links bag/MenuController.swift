//
//  MenuController.swift
//  design links bag
//
//  Created by Camila Luísa Farias on 04/07/18.
//  Copyright © 2018 Camila Luísa Farias. All rights reserved.
//

import Cocoa

struct MenuItem : Codable {
    let id : Int
    let itemName : String
    let itemUrl : String
    
}

class MenuController: NSObject {
    
    let json:String = """
    [
        {"id": 1,"itemName":"google","itemUrl":"https://liferaydesign-handbook.wedeploy.io/docs/"},
        {"id": 2,"itemName":"liferay","itemUrl":"https://liferaydesign-handbook.wedeploy.io/docs/"},
        {"id": 3,"itemName":"loop","itemUrl":"https://liferaydesign-handbook.wedeploy.io/docs/"}
    ]
    """
    
    
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var lexiconDownloadMasterFile: NSMenuItem!
    @IBOutlet weak var testingEnvironmentsDXP: NSMenuItem!
    @IBOutlet weak var DXPCE: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    override func awakeFromNib(){
        let icon = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        statusItem.image = icon
        statusItem.menu = menu

        constructMenu()
    }
    
    func constructMenu() {
        serializeJson()
        
        menu.addItem(NSMenuItem(
            title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
    }
    
    @objc func goToLink(_ sender: MenuItemHelp) {
        guard let urlString = sender.url else{
            return
        }
        
        let url = URL(string: urlString)!
        NSWorkspace.shared.open(url)
    }
    
    func serializeJson(){
        let data = json.data(using: .utf8)
        let jsonDecoder = JSONDecoder()
        let menuItemList = try! jsonDecoder.decode([MenuItem].self, from: data!)
        
        for menuItem in menuItemList {
            let item = MenuItemHelp(
                title: menuItem.itemName, action: #selector(goToLink(_:)), keyEquivalent: "")
            item.url = menuItem.itemUrl
            item.target = self
            menu.addItem(item)
        }
    }
   
}

class MenuItemHelp: NSMenuItem {
    var url : String?
    
}
