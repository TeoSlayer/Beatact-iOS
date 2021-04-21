//
//  PaymentController.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import Foundation

class PaymentController : ObservableObject{
    
    
    @Published var pmState : paymentState?
    
    func buyButtonPressed(eventid: String, organiserId: String){
        //Test
        StripeAPIClient.shared.preAuthorizeCharge(eventId: eventid, organiserId: organiserId)
    }
    
    func stripeResponseSuccess(transaction: StripeTransaction){
            self.pmState = paymentState(successful: true, status: transaction.status, error: "")
    }
    func stripeResponseFailed(error: Error){
        self.pmState = paymentState(successful: false, status: "Failure", error: error.localizedDescription)
    }
    
    
    
    init(){
    }
    
}

struct paymentState{
    var successful: Bool
    var status: String
    var error: String
}

extension PaymentController{
    static let shared = PaymentController()
}

