//
//  Order.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import Foundation

struct Order : Identifiable{
    
    var id : String
    
    var ticketCode : String
    var userId : String
    var status : String
    var payment_Status : String
    var eventId : String
    var identifier : String
    var paymentId : String
    var paymentTime : Date
    var event : Event
}
