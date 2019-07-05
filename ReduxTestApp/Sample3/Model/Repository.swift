//
//  Model.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/06.
//  Copyright © 2019 amaocha. All rights reserved.
//

import ObjectMapper

class Repository: Mappable {
    
    var identifier: Int!
    var html_url: String!
    var name: String!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        identifier <- map["id"]
        html_url <- map["html_url"]
        name <- map["name"]
    }
}
