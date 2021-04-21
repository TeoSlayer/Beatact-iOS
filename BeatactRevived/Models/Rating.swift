//
//  Rating.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import Foundation

struct Rating : Identifiable{

    var id : String
    
    var organiserId : String
    var userId : String
    var eventId : String
    
    var userName : String
    var title : String?
    var text : String?
    var stars : Int
    
    var datetime : Date
}
