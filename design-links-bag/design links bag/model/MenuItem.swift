//
//  MenuItem.swift
//  design links bag
//
//  Created by Camila Luísa Farias on 12/07/18.
//  Copyright © 2018 Camila Luísa Farias. All rights reserved.
//

struct MenuItem : Codable {
    let title : String
    var link : String?
    var itemList : [MenuItem]?
    
    func isSection() -> Bool {
        return link == nil && itemList != nil
    }
    
}
