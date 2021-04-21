//
//  Organiser.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import Foundation

struct Organiser: Identifiable{
    
    var id : String
    
    var imageLink : String
    var name : String
    var description : String
    var role : String
    var contactEmail : String
    var contactPhone : String
    var website : String
    var socialLink : String
    var events : [String]
    var orders : [String]
    var ratings : [String]
    var staff : [Staff]
}

struct Staff: Identifiable{
    var id : String
    
    var name : String
    var role : String
    var userId : String
}
