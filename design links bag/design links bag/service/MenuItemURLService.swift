//
//  MenuItemURLService.swift
//  design links bag
//
//  Created by Camila Luísa Farias on 12/07/18.
//  Copyright © 2018 Camila Luísa Farias. All rights reserved.
//

import Foundation

class MenuItemURLService: MenuItemService {
    static var getInstance: MenuItemService = MenuItemURLService()
    
    private init(){
        
    }
    
    func fetch(callBack : @escaping (_ menuItemList : [MenuItem]) -> Void) {
        let urlString = URL(string: "https://data-designlinksbag.wedeploy.io/DesignLinkBagData/299927665602327996")
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        callBack(self.deserialize(data: usableData))
                    }
                }
            }
            task.resume()
        }
    }
    
    private func deserialize(data: Data) -> [MenuItem] {
        let jsonDecoder = JSONDecoder()
        
        return try! jsonDecoder.decode(Result.self, from: data).items
    }
}
