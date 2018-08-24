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
    let defaults =  UserDefaults.standard
    let key = "menuData"
    
    private init(){
        
    }
	
    func fetch(callBack : @escaping (_ menuItemList : [MenuItem]) -> Void) {
        let urlString = URL(string: "https://data-designlinksbag.wedeploy.io/DesignLinkBagData/306801506800660647")
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    let data = self.defaults.data(forKey: self.key)
                    if let dataInfo = data {
                        callBack(self.deserialize(data: dataInfo))
                    }
                    print(error)
                    
                } else {
                    if let usableData = data {
                        callBack(self.deserialize(data: usableData))
                        self.defaults.set(data, forKey: self.key)
                    }
                }
            }
            task.resume()
        }
    }
    
    public func deserialize(data: Data) -> [MenuItem] {
        let jsonDecoder = JSONDecoder()
        
        return try! jsonDecoder.decode(Result.self, from: data).items
    }
}
