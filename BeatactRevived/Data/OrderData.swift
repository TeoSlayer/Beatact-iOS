//
//  OrderData.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import Foundation
import FirebaseFirestore
import SwiftyJSON
import FirebaseAuth

class OrderData : ObservableObject{
    
    init(){}
    let db = Firestore.firestore()
    static let shared  = OrderData()
    
    @Published var Orders : [Order] = []
    
    
    
    func retrieveOrders(){
        db.settings.isPersistenceEnabled = true
        let eventCollection = db.collection("Orders")
        eventCollection
            .whereField("UserId", isEqualTo: Auth.auth().currentUser?.uid)
            .order(by: "CreatedAt", descending: true)
            .addSnapshotListener({(querySnapshot, err) in
            if let err = err{
                print("Error: Could not fetch documents")
            }
            else{
                if(!querySnapshot!.isEmpty){
                    self.processOrders(documents: querySnapshot!)
                }
            }
        })
    }
    
    func processOrders(documents : QuerySnapshot){
        for document in documents.documents{
            if document.data() != nil{
                let eventId = document.data()["EventId"] as? String ?? ""
                let id = document.data()["Id"] as? String ?? ""
                let readUser = document.data()["UserId"] as? String ?? ""
                print(document)
                
                if(eventId == "" || readUser != Auth.auth().currentUser?.uid || (self.Orders.firstIndex(where: {$0.id == id})) != nil){
                    print("query invalid continuing to next object")
                    continue
                }
                else{
                    let event = EventData.shared.Events.filter{ $0.id == eventId }.first
                    print(event)
                    if(event != nil){
                        print("Event exists locally, fetching...")
                        var order = parseDocument(document: document)
                        order.event = event!
                        if(self.Orders.firstIndex(where: { $0.id == order.id}) == nil){
                            self.Orders.append(order)
                        }
                    }
                    else{
                        print("Event doesn't exist locally, fetching from firestore...")
                        let eventRef = db.collection("Events").document(eventId)
                        eventRef
                            .getDocument(completion: { (snapshot, err) in
                            if let err = err{
                                print("Error: Could not fetch documents")
                            }
                            else{
                                
                                var order = self.parseDocument(document: document)
                                let queryevent = EventData.shared.parseDocument(document: snapshot!)
                                print(queryevent)
                                if(queryevent.id != ""){
                                    order.event = queryevent
                                    print(order)
                                    if(self.Orders.firstIndex(where: { $0.id == order.id}) == nil){
                                        self.Orders.append(order)
                                    }
                                }
                                
                                
                            }
                        })
                    }
                }
                
            }
            
        }
    }
    
    func orderExists(eventid: String) -> Bool{
        let ordersfilter = self.Orders.first(where: { $0.eventId == eventid})
        if(ordersfilter != nil){
            return true
        }
        return false
    }
    
    
    
    func emptyOrder() -> Order{
        return Order(id: "", ticketCode: "", userId: "", status: "", payment_Status: "", eventId: "", identifier: "", paymentId: "", paymentTime: Date(), event: EventData.shared.emptyEvent())
    }
    
    func parseDocument(document : DocumentSnapshot) -> Order{
        var order = self.emptyOrder()
        
        if let data = document.data(){
            
            if let id = data["Id"] as? String{
                order.id = id
            }
            
            if let eventId = data["EventId"] as? String{
                order.eventId = eventId
            }
            
            if let time = data["CreatedAt"] as? Timestamp{
                let date = Date(timeIntervalSince1970: TimeInterval(time.seconds))
                order.paymentTime = date
            }
            
            if let pmid = data["PaymentId"] as? String{
                order.paymentId = pmid
            }
            
            if let pms = data["Payment_Status"] as? String{
                order.payment_Status = pms
            }
            
            if let shrt = data["ShortCode"] as? String{
                order.identifier = shrt
            }
            
            if let sts = data["Status"] as? String{
                order.status = sts
            }
            
            if let code = data["Ticket_Code"] as? String{
                order.ticketCode = code
            }
            
            if let uid = data["UserId"] as? String{
                order.userId = uid
            }
            
        }
       return order
    }
    
    
}

