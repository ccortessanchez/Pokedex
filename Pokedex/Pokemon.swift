//
//  Pokemon.swift
//  Pokedex
//
//  Created by Carlos Cortés Sánchez on 19/09/2017.
//  Copyright © 2017 Carlos Cortés Sánchez. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Pokemon {
    let name: String
    var types: [String?]? = []
    let spriteUrl: String?
    
    init(json: JSON) throws {
        name = json["name"].stringValue.capitalized
        
        types?.append(json["types"][1]["type"]["name"].string)
        types?.append(json["types"][0]["type"]["name"].string)
        
        spriteUrl = json["sprites","front_default"].string
    }
}
