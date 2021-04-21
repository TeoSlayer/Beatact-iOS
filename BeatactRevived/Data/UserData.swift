//
//  UserData.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserData : ObservableObject{
    let settings = FirestoreSettings()
    let db = Firestore.firestore()
    static let shared = UserData()
    
    
    @Published var loggedIn = Auth.auth().currentUser?.uid != nil ? true : false
    @Published var user : User?
    @Published var onBoarding = false
    @Published var cards : [PaymentMethod] = []
    
    func retrieveUser(userId: String){
        db.settings.isPersistenceEnabled = true
        let userdbref = db.collection("Users").document(userId)
        var listner = userdbref.addSnapshotListener{ [self] (snapshot, err) in
            if var data = snapshot?.data() {
                var dbuser = User(id: userId, name: data["Name"] as? String ?? "", phone: data["Phone"] as? String ?? "", email: data["Email"] as? String ?? "", role: data["Type"] as? String ?? "", organiserId: (data["Type"] as? String) == "Organiser" ? (data["OrganiserId"] as? String) : nil, stripe_Id: "")
                self.user = dbuser
                self.loggedIn = true
                self.retrieveStripeId(userId: userId)
            } else {
                print("Couldn't find the document")
            }
        }
    }
    
    func listenForAuth(){
        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user != nil){
                self.retrieveUser(userId: user!.uid)
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.purgeData()
                })
            }
        }
    }
    
    func purgeData(){
        self.user = nil
        self.onBoarding = false
        self.onBoarding = false
        EventData.shared.Events = []
        OrderData.shared.Orders = []
    }
    
    func retrieveStripeId(userId: String){
        let userdbref = db.collection("Stripe").document(userId)
        var listner = userdbref.addSnapshotListener{ (snapshot, err) in
            if var data = snapshot?.data() {
                self.user?.stripe_Id = data["stripeId"] as? String ?? ""
                StripeAPIClient.shared.retrievePaymentMethods()
            } else {
                print("Couldn't find the document")
            }
        }
    }
    
    func pushUser(id: String,name: String, phone: String, email: String){
        let userdbref = db.collection("Users").document(id).setData([
            "Id" : id,
            "Name" : name,
            "Phone" : phone,
            "Email" : email,
            "Type" : "User"
        ]){err in
            if let err = err{
                print("Error during uploading document to firebase")
            }else{
                let leaderboardref = self.db.collection("Leaderboard").document(id).setData([
                    "Name" : name,
                    "Orders" : 0,
                    "Private" : false,
                ]){err in
                    if let err = err{
                        print("Error during uploading document to firebase")
                    }else{
                        self.onBoarding = false
                        self.retrieveUser(userId: id)
                    }
                }

            }
        }
    }
    
    func checkIfUserExists(id: String,completion: @escaping (Bool) -> ()){
        let userdbref = db.collection("Users").document(id)
        userdbref.getDocument(completion: {(document, err) in
            if let document = document, document.exists{
                self.retrieveUser(userId: id)
                completion(true)
            }
            else{
                print("User does not exist")
                completion(false)
            }
        })
    }
    
    func emptyUser() -> User{
        return User(id: "", name: "", phone: "", email: "", role: "", organiserId: nil, stripe_Id: "")
    }
    
    
    init(){}
}
