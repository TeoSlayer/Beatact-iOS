//
//  AuxApi.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 16.04.2021.
//

import Foundation
import FirebaseFunctions
import FirebaseAuth


class AuxAPI{
    lazy var functions = Functions.functions()
    static let shared = AuxAPI()
    func generatePass(eventName : String, orderId : String, eventCode : String,eventPrice : String, eventId: String){
        functions.httpsCallable("generatePass").call(["userName" : UserData.shared.user?.name, "eventName" : eventName, "userId" : Auth.auth().currentUser?.uid ,"orderId": orderId, "eventCode" : eventCode, "eventPrice" : eventPrice, "eventid" : eventId]){(response,error) in
            if let error = error {
                print(error)
            }
            if let resp = (response?.data as? String) {
                print(resp)
                UIApplication.shared.open(URL(string: resp)!)
            }
        }
    }
}
