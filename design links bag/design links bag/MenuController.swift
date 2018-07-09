//
//  MenuController.swift
//  design links bag
//
//  Created by Camila Luísa Farias on 04/07/18.
//  Copyright © 2018 Camila Luísa Farias. All rights reserved.
//

import Cocoa
import WeDeploy

struct MenuItem : Codable {
    let id : String
    let name : String
    let link : String
    
}

class MenuController: NSObject {
    
    var menuItems = ""
    
    let json:String = """
    [
        {"id": 1,"itemName":"design","itemUrl":"https://liferaydesign-handbook.wedeploy.io/docs/"},
        {"id": 2,"itemName":"liferay","itemUrl":"https://liferaydesign-handbook.wedeploy.io/docs/"},
        {"id": 3,"itemName":"loop","itemUrl":"https://liferaydesign-handbook.wedeploy.io/docs/"}
    ]
    """
    
    @IBOutlet weak var menu: NSMenu!

    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    override func awakeFromNib(){
        let icon = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        statusItem.image = icon
        statusItem.menu = menu
        constructMenu()
        //saveData()
        
    }
    
    func constructMenu() {
        getData()
        
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
    
    func serializeJson(menuItems : String){
        let data = menuItems.data(using: .utf8)
        let jsonDecoder = JSONDecoder()
        let menuItemList = try! jsonDecoder.decode([MenuItem].self, from: data!)
        
        for menuItem in menuItemList {
            let item = MenuItemHelp(
                title: menuItem.name, action: #selector(goToLink(_:)), keyEquivalent: "")
            item.url = menuItem.link
            item.target = self
            menu.addItem(item)
        }
    }
    
    func getData(){
        WeDeploy
            .data("data-designlinksbag.wedeploy.io")
            .get(resourcePath: "menuItems")
            .then { menuItem in
                self.deserialize(value : menuItem)
                //print(menuItem)
        }
    }
    
    func deserialize(value : [[String:Any]]) {
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
            self.serializeJson(menuItems: String(data: jsonData, encoding: .utf8)!)
            
        } catch {
            print(error.localizedDescription)
        }
        

    }
    
    func saveData(){
        WeDeploy
            .data("data-designlinksbag.wedeploy.io")
            .create(resource: "menuItems", object: [
                "name" : "Test",
                "link" : "https://liferaydesign-handbook.wedeploy.io/docs/"
                ])
            .then { menuItem in
                print(menuItem)
        }
    }
   
}

class MenuItemHelp: NSMenuItem {
    var url : String?
    
}
