//
//  User.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import Foundation

struct User: Identifiable, Encodable, Decodable{
    var id : String
    
    var name : String
    var phone : String
    var email : String
    var role : String
    var organiserId : String?
    var stripe_Id : String
}
