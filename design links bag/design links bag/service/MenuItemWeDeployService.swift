//
//  MenuItemWeDeployService.swift
//  design links bag
//
//  Created by Camila Luísa Farias on 12/07/18.
//  Copyright © 2018 Camila Luísa Farias. All rights reserved.
//

import Foundation
import SocketIO
import WeDeploy

class MenuItemWeDeployService: MenuItemService {
    
    var socketWeDeploy : SocketIOClient?
    static var getInstance: MenuItemService = MenuItemWeDeployService()
    
    private init() {
        socketWeDeploy = WeDeploy
            .data("data-designlinksbag.wedeploy.io")
            .watch(resourcePath: "DesignLinkBag")
    }
    
    func fetch(callBack : @escaping (_ menuItemList : [MenuItem]) -> Void) {
        WeDeploy
                .data("data-designlinksbag.wedeploy.io")
                .get(resourcePath: "DesignMenuTest")
                .then { menuItem in
                    callBack(self.deserialize(value : menuItem))
                }
    }
    
    private func deserialize(value : [[String:Any]]) -> [MenuItem] {
        var menuItemList: [MenuItem] = []
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
            menuItemList = self.deserializeJson(menuItems: String(data: jsonData, encoding: .utf8)!)
        } catch {
            print(error.localizedDescription)
        }
        
        return menuItemList
    }
    
    private func deserializeJson(menuItems : String) -> [MenuItem] {
        let data = menuItems.data(using: .utf8)
        let jsonDecoder = JSONDecoder()
        
        return try! jsonDecoder.decode([MenuItem].self, from: data!)
    }
    
    private func realTime() {
        guard let socket = socketWeDeploy else {
            return
        }
        socket.on([.changes, .error]) { data in
            switch(data.type) {
            case .changes:
                print("changes \(data.document)")
            case .error:
                print("error \(data.document)")
            default:
                break
            }
        }
    }
}
