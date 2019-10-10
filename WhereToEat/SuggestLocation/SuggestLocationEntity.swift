//
//  SuggestLocationEntity.swift
//  WhereToEat
//
//  Created by Ahmad Ragab on 10/10/19.
//  Copyright © 2019 Ahmad Ragab. All rights reserved.
//

import ObjectMapper

class SuggestLocationEntity : Mappable {
    
    internal var error: String?
    internal var name: String?
    internal var id: String?
    internal var link: String?
    internal var cat: String?
    internal var catId: String?
    internal var rating: String?
    internal var lat: String?
    internal var lon: String?
    internal var Ulat: String?
    internal var Ulon: String?
    internal var open: String?
    internal var image: [String]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        error <- map["error"]
        name <- map["name"]
        id <- map["id"]
        link <- map["link"]
        cat <- map["cat"]
        catId <- map["catId"]
        rating <- map["rating"]
        lat <- map["lat"]
        lon <- map["lon"]
        Ulat <- map["Ulat"]
        Ulon <- map["Ulon"]
        open <- map["open"]
        image <- map["image"]
    }
}
