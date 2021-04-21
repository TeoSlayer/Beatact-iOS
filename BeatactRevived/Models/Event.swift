//
//  Event.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import Foundation

struct Event: Identifiable{
    
    var id: String

    var name: String
    var headline: String
    var startDate: Date
    var endDate: Date
    var price: Float
    var ticket_No: Int
    var ticket_Available: Int
    var images: [String]
    //add localimages
    var style: String
    var description: String
    var artists: [String]
    var genre: String
    var location: Location
    var organiserId: String
    var reccuring: Bool
    var callToActionLink: String
    var views: Int
    var isPromoted: Bool
    var promotionDate: Date?
    var venue : String
}

struct Location{
    var lat: Double
    var lon: Double
    var country: String
    var county: String
    var city: String
    var street: String
    var no: String
    var completeAddress: String
}

struct DateComps{
    var year: Int
    var month: Int
    var day: Int
}
