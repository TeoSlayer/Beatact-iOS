//
//  TwillioAPIClient.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import Foundation
import FirebaseFunctions
import SwiftyJSON

class TwillioAPIClient : ObservableObject {
    
    @Published var state = ""
    lazy var functions = Functions.functions()
    static let shared = TwillioAPIClient()
    
   
    func sendPhone(phone : String, countryCode : String, completion: @escaping (String) -> ()){
        functions.httpsCallable("startPhoneVerification").call(["country_code" : countryCode, "phone_number" : phone, "via" : "sms"]) { (response, error) in
            if let error = error {
                print("Twillio \(error)")
                completion("Error: \(error)")
            }
            if let processedresponse = (response?.data as? [String: Any]) {
                print("Twillio \(processedresponse)")
                let resp = JSON(response?.data)
                print(self.parseResponse(json:resp))
                let parsedResponse = TwillioAPIClient.shared.parseResponse(json: resp)
                completion(parsedResponse.status)
            }
        }
        
    }
    

    
    func checkCode(phone : String, countryCode : String, code : String, completion: @escaping (String) -> ()){
        functions.httpsCallable("checkPhoneVerification").call(["country_code" : countryCode, "phone_number" : phone, "code" : code]) { (response, error) in
            if let error = error {
                print("Twillio \(error)")
                completion("Error: \(error)")
            }
            if let processedresponse = (response?.data as? [String: Any]) {
                print("Twillio \(processedresponse)")
                let resp = JSON(response?.data)
                print(self.parseResponse(json:resp))
                let parsedResponse = TwillioAPIClient.shared.parseResponse(json: resp)
                completion(parsedResponse.status)
            }
        }
    }

   
    
    func parseResponse(json: JSON) -> phoneVerification{
        var pn = phoneVerification(status: "", phone : "")
        if let status = json["status"].string {
            pn.status = status
        }
        
        if let phone = json["to"].string {
            pn.phone = phone
        }
    
        return pn
        
    }
    
}

struct phoneVerification{
    var status : String
    var phone : String
}


