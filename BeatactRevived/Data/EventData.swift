//
//  EventData.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import Foundation
import FirebaseFirestore
import SwiftyJSON

class EventData : ObservableObject{
    
    init(){}
    let db = Firestore.firestore()
    static let shared  = EventData()
    
    @Published var Events : [Event] = []
    @Published var FilteredEvents : [Event] = []
    
    //filter
    @Published var filterPresented = false
    @Published var filterActive = false
    
    @Published var price : Float = 1000
    @Published var selectedType = -1
    @Published var selectedGenre = -1
    @Published var selectedSort = -1
    
    var types = ["Party","HouseParty","Festival","Charity"]
    var genres = ["Techno","EDM","Minimal","DnB","Dubstep","House","Dark"]
    var sort = ["Trending","Most Views","Favorites","Low Price"]
    //
    
    
    func applyFilters(){
        var eventquery = db.collection("Events").limit(to: 50)
        self.FilteredEvents = []
        //single filter
        if(selectedGenre != -1 && selectedType == -1 && selectedSort == -1 && price == 1000){//genre
            eventquery = eventquery.whereField("Genre", isEqualTo: genres[selectedGenre])
        }
        
        if(selectedGenre == -1 && selectedType != -1 && selectedSort == -1 && price == 1000){//type
            eventquery = eventquery.whereField("Type", isEqualTo: types[selectedType])
            
        }
        if(selectedGenre == -1 && selectedType == -1 && selectedSort != -1 && price == 1000){//sort
            if(sort[selectedSort] == "Trending"){
                eventquery = eventquery.order(by: "Views", descending: true)
            }
            if(sort[selectedSort] == "Most Views"){
                eventquery = eventquery.order(by: "Views",descending: true)
            }
            if(sort[selectedSort] == "Favorites"){
                
            }
            if(sort[selectedSort] == "Low Price"){
                eventquery = eventquery.order(by: "Price", descending: false)
            }
    
        }
        if(selectedGenre == -1 && selectedType == -1 && selectedSort == -1 && price != 1000){ //price
            eventquery = eventquery.whereField("Price", isLessThanOrEqualTo: price)
        }
        
        //two filter
        if(selectedGenre != -1 && selectedType == -1 && selectedSort != -1 && price == 1000){//genre sort
            eventquery = eventquery.whereField("Genre", isEqualTo: genres[selectedGenre])
            if(sort[selectedSort] == "Trending"){
                eventquery = eventquery.order(by: "Views", descending: true)
            }
            if(sort[selectedSort] == "Most Views"){
                eventquery = eventquery.order(by: "Views",descending: true)
            }
            if(sort[selectedSort] == "Favorites"){
                
            }
            if(sort[selectedSort] == "Low Price"){
                eventquery = eventquery.order(by: "Price", descending: false)
            }
        }
        
        if(selectedGenre == -1 && selectedType != -1 && selectedSort == -1 && price == 1000){//genre type
            eventquery = eventquery.whereField("Genre", isEqualTo: genres[selectedGenre])
            eventquery = eventquery.whereField("Type", isEqualTo: types[selectedType])
        }
        if(selectedGenre != -1 && selectedType == -1 && selectedSort == -1 && price != 1000){//genre price
            eventquery = eventquery.whereField("Genre", isEqualTo: genres[selectedGenre])
            eventquery = eventquery.whereField("Price", isLessThanOrEqualTo: price)
        }
        if(selectedGenre == -1 && selectedType != -1 && selectedSort != -1 && price == 1000){ //types sort
            eventquery = eventquery.whereField("Type", isEqualTo: types[selectedType])
            if(sort[selectedSort] == "Trending"){
                eventquery = eventquery.order(by: "Views", descending: true)
            }
            if(sort[selectedSort] == "Most Views"){
                eventquery = eventquery.order(by: "Views",descending: true)
            }
            if(sort[selectedSort] == "Favorites"){
                
            }
            if(sort[selectedSort] == "Low Price"){
                eventquery = eventquery.order(by: "Price", descending: false)
            }
        }
        if(selectedGenre == -1 && selectedType != -1 && selectedSort == -1 && price != 1000){//type price
            eventquery = eventquery.whereField("Type", isEqualTo: types[selectedType])
            eventquery = eventquery.whereField("Price", isLessThanOrEqualTo: price)
        }
        if(selectedGenre == -1 && selectedType == -1 && selectedSort != -1 && price != 1000){ //price sort
            eventquery = eventquery.whereField("Price", isLessThanOrEqualTo: price)
            if(sort[selectedSort] == "Trending"){
                eventquery = eventquery.order(by: "Views", descending: true)
            }
            if(sort[selectedSort] == "Most Views"){
                eventquery = eventquery.order(by: "Views",descending: true)
            }
            if(sort[selectedSort] == "Favorites"){
                
            }
            if(sort[selectedSort] == "Low Price"){
                eventquery = eventquery.order(by: "Price", descending: false)
            }
        }
        
        //triple filter
        if(selectedGenre != -1 && selectedType != -1 && selectedSort != -1 && price == 1000){//genre types sort
            eventquery = eventquery.whereField("Genre", isEqualTo: genres[selectedGenre])
            eventquery = eventquery.whereField("Type", isEqualTo: types[selectedType])
            if(sort[selectedSort] == "Trending"){
                eventquery = eventquery.order(by: "Views", descending: true)
            }
            if(sort[selectedSort] == "Most Views"){
                eventquery = eventquery.order(by: "Views",descending: true)
            }
            if(sort[selectedSort] == "Favorites"){
                
            }
            if(sort[selectedSort] == "Low Price"){
                eventquery = eventquery.order(by: "Price", descending: false)
            }
        }
        
        if(selectedGenre != -1 && selectedType != -1 && selectedSort == -1 && price != 1000){//genre types price
            eventquery = eventquery.whereField("Genre", isEqualTo: genres[selectedGenre])
            eventquery = eventquery.whereField("Type", isEqualTo: types[selectedType])
            eventquery = eventquery.whereField("Price", isLessThanOrEqualTo: price)
        }
        if(selectedGenre != -1 && selectedType == -1 && selectedSort != -1 && price != 1000){//genre price sort
            eventquery = eventquery.whereField("Price", isLessThanOrEqualTo: price)
            eventquery = eventquery.whereField("Genre", isEqualTo: genres[selectedGenre])
            if(sort[selectedSort] == "Trending"){
                eventquery = eventquery.order(by: "Views", descending: true)
            }
            if(sort[selectedSort] == "Most Views"){
                eventquery = eventquery.order(by: "Views",descending: true)
            }
            if(sort[selectedSort] == "Favorites"){
                
            }
            if(sort[selectedSort] == "Low Price"){
                eventquery = eventquery.order(by: "Price", descending: false)
            }
        }
        if(selectedGenre == -1 && selectedType != -1 && selectedSort != -1 && price != 1000){ //types sort price
            eventquery = eventquery.whereField("Type", isEqualTo: types[selectedType])
            eventquery = eventquery.whereField("Price", isLessThanOrEqualTo: price)
            if(sort[selectedSort] == "Trending"){
                eventquery = eventquery.order(by: "Views", descending: true)
            }
            if(sort[selectedSort] == "Most Views"){
                eventquery = eventquery.order(by: "Views",descending: true)
            }
            if(sort[selectedSort] == "Favorites"){
                
            }
            if(sort[selectedSort] == "Low Price"){
                eventquery = eventquery.order(by: "Price", descending: false)
            }
        }
        
        //full filter
        if(selectedGenre != -1 && selectedType != -1 && selectedSort != -1 && price != 1000){ //types sort price
            eventquery = eventquery.whereField("Genre", isEqualTo: genres[selectedGenre])
            eventquery = eventquery.whereField("Type", isEqualTo: types[selectedType])
            eventquery = eventquery.whereField("Price", isLessThanOrEqualTo: price)
            if(sort[selectedSort] == "Trending"){
                eventquery = eventquery.order(by: "Views", descending: true)
            }
            if(sort[selectedSort] == "Most Views"){
                eventquery = eventquery.order(by: "Views",descending: true)
            }
            if(sort[selectedSort] == "Favorites"){
                
            }
            if(sort[selectedSort] == "Low Price"){
                eventquery = eventquery.order(by: "Price", descending: false)
            }
        }
        
        
        
        eventquery.getDocuments(completion: { (querySnapshot, err) in
            if let err = err{
                print("Error: Could not fetch documents")
            }
            else{
                for document in querySnapshot!.documents{
                    print("\(document.documentID) => \(document.data())")
                    print(self.parseDocument(document: document))
                    self.FilteredEvents.append(self.parseDocument(document: document))
                }
            }
        })
        
    }
    
    func retrieveEvents(){
        db.settings.isPersistenceEnabled = true
        let eventCollection = db.collection("Events")
        eventCollection
            .limit(to: 5)
            .getDocuments(completion: { (querySnapshot, err) in
            if let err = err{
                print("Error: Could not fetch documents")
            }
            else{
                for document in querySnapshot!.documents{
                    print("\(document.documentID) => \(document.data())")
                    print(self.parseDocument(document: document))
                    let event = self.parseDocument(document: document)
                    if(self.Events.firstIndex(where: {$0.id == event.id}) == nil){
                        self.Events.append(event)
                    }
                    
                }
            }
            
        })
    }
    
    func emptyEvent() -> Event{
        return Event(id: "", name: "", headline: "", startDate: Date(), endDate: Date(), price: 0, ticket_No: 0, ticket_Available: 0, images: [""], style: "", description: "", artists: [""], genre: "", location: Location(lat: 0, lon: 0, country: "", county: "", city: "", street: "", no: "", completeAddress: ""), organiserId: "", reccuring: false, callToActionLink: "", views: 0, isPromoted: false, promotionDate: nil, venue: "")
    }
    
    func parseDocument(document : DocumentSnapshot) -> Event{
        var event = self.emptyEvent()
        
        if let data = document.data(){
            
            if let id = data["Id"] as? String{
                event.id = id
            }
            
            if let artists = data["Artists"] as? [String]{
                event.artists = artists
            }
            
            if let description = data["Description"] as? String{
                event.description = description
            }
            
            if let endDate = data["EndDate"] as? Timestamp{
                let date = Date(timeIntervalSince1970: TimeInterval(endDate.seconds))
                event.endDate = date
            }
            
            if let genre = data["Genre"] as? String{
                event.genre = genre
            }
            
            if let headline = data["Headline"] as? String{
                event.headline = headline
            }
            
            if let location = data["Location"] as? [Any]{
                
                let country = location[0] as? String
                let county = location[1] as? String
                let city = location[2] as? String
                let street = location[3] as? String
                let no = location[4] as? String
                let completeAddress = location[5] as? String
                let lat = location[6] as? Double
                let lon = location[7] as? Double
                
                
                event.location.country = country!
                event.location.county = county!
                event.location.city = city!
                event.location.street = street!
                event.location.no = no!
                event.location.completeAddress = completeAddress!
                event.location.lat = lat!
                event.location.lon = lon!
            }
            
            if let link = data["Link"] as? String{
                event.callToActionLink = link
            }
            
            if let images = data["Images"] as? [String]{
                event.images = images
            }
            
            if let name = data["Name"] as? String{
                event.name = name
            }
            
            if let organiserId = data["OrganiserId"] as? String{
                event.organiserId = organiserId
            }
            
            if let price = data["Price"] as? Float{
                event.price = price
            }
            
            if let isPromoted = data["isPromoted"] as? Bool{
                event.isPromoted = isPromoted
                if(isPromoted){
                    let promotionDate = data["PromotionDate"] as? Timestamp
                    let date = Date(timeIntervalSince1970: TimeInterval(promotionDate!.seconds))
                    event.promotionDate = date
                }
            }
            
            if let reccuring = data["Reccuring"] as? Bool{
                event.reccuring = reccuring
            }
            
            if let startDate = data["StartDate"] as? Timestamp{
                let date = Date(timeIntervalSince1970: TimeInterval(startDate.seconds))
                event.startDate = date
            }
            
            if let ticketno = data["Ticket_No"] as? Int{
                event.ticket_Available = ticketno
            }
            
            if let ticketav = data["Ticket_Availabe"] as? Int{
                event.ticket_Available = ticketav
            }
            
            if let type = data["Type"] as? String{
                event.style = type
            }
            
            if let venue = data["Venue"] as? String{
                event.venue = venue
            }
        }
       return event
    }
    
    
}

