//
//  Stickers.swift
//  GEM-ART
//
//  Created by Truman Tang on 9/13/20.
//  Copyright © 2020 Truman Tang. All rights reserved.
//

import Foundation

class Stickers{
    private var _name: String!
    private var _Id: Int!
    
    var name: String!{
        return _name
    }
    var Id : Int!{
        return _Id
    }
    init(name: String, Id: Int){
        self._name = name
        self._Id = Id
    }
}
