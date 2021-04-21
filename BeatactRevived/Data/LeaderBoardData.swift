//
//  LeaderBoardData.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 13.04.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class LeaderBoardData : ObservableObject{
    init(){}
    
    let db = Firestore.firestore()
    static let shared  = LeaderBoardData()
    
    @Published var privateUser : Bool = false
    @Published var leaderbaordUsers : [LeaderBoardUser] = []
    
    func retrieveLeaderBoard(){
        db.settings.isPersistenceEnabled = true
        let eventCollection = db.collection("Leaderboard")
        eventCollection
            .order(by: "Orders", descending: true)
            .whereField("Private", isEqualTo: false)
            .limit(to: 10)
            .addSnapshotListener({(querySnapshot, err) in
            if let err = err{
                print("Error: Could not fetch leaderboard documents")
            }
            else{
                if(!querySnapshot!.isEmpty){
                    self.processLeaderboard(documents: querySnapshot!)
                }
            }
        })
    }
    
    func retrievePersonalLeaderBoard(){
        db.settings.isPersistenceEnabled = true
        let eventCollection = db.collection("Leaderboard").document(Auth.auth().currentUser!.uid)
        eventCollection
            .addSnapshotListener({(document, err) in
            if let err = err{
                print("Error: Could not fetch privateUser")
            }
            else{
                if document?.data() != nil{
                    self.privateUser = document?.data()!["Private"] as! Bool
                }
            }
        })
    }
    
    func updatePersonalLeaderBoard(){
        db.settings.isPersistenceEnabled = true
        let eventCollection = db.collection("Leaderboard").document(UserData.shared.user!.id)
        eventCollection.updateData(["Private": !privateUser])
    }
    
    func processLeaderboard(documents: QuerySnapshot){
        for document in documents.documents{
            if document.data() != nil {
                let data = document.data()
                var dbuser = LeaderBoardUser(id: document.documentID as String, name: data["Name"] as? String ?? "", orders: data["Orders"] as? Int ?? 0)
                if(self.leaderbaordUsers.firstIndex(where: {$0.id == dbuser.id}) == nil){
                    self.leaderbaordUsers.append(dbuser)
                }
            } else {
                print("Couldn't find the document")
            }
        }
    }
}
