//
//  PaymentMethod.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import Foundation

struct PaymentMethod: Identifiable{
    var id: String
    var cardLast4Numbers : String
    var lastUsed : Bool
    var exp_year : Int
    var exp_month : Int
    var cardType : String
}
