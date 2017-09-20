//
//  PokeAPI.swift
//  Pokedex
//
//  Created by Carlos Cortés Sánchez on 19/09/2017.
//  Copyright © 2017 Carlos Cortés Sánchez. All rights reserved.
//

import Foundation
import Siesta
import SwiftyJSON

let PokeAPI = _PokeAPI()

class _PokeAPI: Service {
    fileprivate init() {
        super.init(baseURL: "https://pokeapi.co/api/v2")
        
        // Configuration
        self.configure {
            $0.pipeline[.parsing].add(SwiftyJSONTransformer, contentTypes: ["*/json"])
            $0.expirationTime = 3600
        }
        
        self.configureTransformer("/pokemon") {
            ($0.content as JSON)["results"].arrayValue
        }
        
        self.configureTransformer("/pokemon/*") {
            try Pokemon(json: $0.content)
        }
    }
    
    //Pokedex 1st generation
    var pokedex: Resource { return resource("/pokemon").withParam("limit", "151") }
    //Pokedex ALL
    //var pokedex: Resource { return resource("/pokemon").withParam("limit", "811") }
    //Pokedex 2nd generation 
    //var pokedex: Resource { return resource("/pokemon").withParam("limit", "100").withParam("offset", "151") }
    
    func pokemon(id: String) -> Resource {
        return pokedex.child(id)
    }
}

private let SwiftyJSONTransformer = ResponseContentTransformer { JSON($0.content as AnyObject) }
