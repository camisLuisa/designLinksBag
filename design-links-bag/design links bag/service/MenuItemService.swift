//
//  MenuItemService.swift
//  design links bag
//
//  Created by Camila Luísa Farias on 12/07/18.
//  Copyright © 2018 Camila Luísa Farias. All rights reserved.
//

import Foundation

protocol MenuItemService {
    
    static var getInstance: MenuItemService {get}
    func fetch(callBack : @escaping (_ menuItemList : [MenuItem]) -> Void)
}
