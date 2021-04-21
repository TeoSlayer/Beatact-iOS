//
//  StripeAPIClient.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//


import Foundation
import FirebaseFunctions
import FirebaseAuth
import Stripe
import SwiftyJSON
import UIKit
import SwiftUI

class StripeAPIClient: NSObject, ObservableObject, STPCustomerEphemeralKeyProvider {

    lazy var functions = Functions.functions()
    static let shared = StripeAPIClient()
    
    @Published var currentTransactionStatus = ""
    @Published var transactionActive = false
    @Published var paymentVerification = false
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        print(["api_version" : apiVersion, "customer_id" : UserData.shared.user?.stripe_Id])
        functions.httpsCallable("getStripeEphemeralKeys").call(["api_version" : apiVersion, "customer_id" : UserData.shared.user?.stripe_Id]) { (response, error) in
            if let error = error {
                print("CCkey \(error)")
                completion(nil, error)
            }
            if let response = (response?.data as? [String: Any]) {
                completion(response, nil)
                print("MyStripeAPIClient response \(response)")
            }
            }
    }
    
    func preAuthorizeCharge(eventId : String, organiserId: String){
        functions.httpsCallable("preAuthorizeCharge").call(["eventid": eventId, "OrganiserId": organiserId, "paymentMethodId" : getSelectedPm()?.id,]) { (response, error) in
                if let error = error {
                    print("CCkey \(error)")
                    self.currentTransactionStatus = "Failed"
                    PaymentController.shared.stripeResponseFailed(error: error)
                }
            if let processedResponse = (response?.data as? [String:Any]) {
                    print("cckey \(processedResponse)")
                    let transaction = JSON(response?.data)
                    print(self.parseTransactionJSON(transaction))
                    let parsedTransaction = self.parseTransactionJSON(transaction)
                    FakeStripeViewController.shared.confirm(transaction: parsedTransaction, eventId: eventId, organiserId: organiserId)
                }
            }
    }
    
    func handleTransaction(transaction: StripeTransaction, eventId: String, organiserId : String){
        functions.httpsCallable("handleTransaction").call(["paymentIntentId" : transaction.id, "eventid": eventId, "organiserid" : organiserId]) { (response, error) in
                if let error = error {
                    print("handl \(error)")
                    self.currentTransactionStatus = "Failed"
                    PaymentController.shared.stripeResponseFailed(error: error)
                }
            if let processedResponse = (response?.data as? [String:Any]) {
                    print("handl \(processedResponse)")
                    let transaction = JSON(response?.data)
                    print(self.parseTransactionJSON(transaction))
                    let parsedTransaction = self.parseTransactionJSON(transaction)
                }
            }
    }
    
    func getSelectedPm() -> PaymentMethod?{
        let selectedPm = UserData.shared.cards.first(where: {$0.lastUsed == true})
        if(selectedPm != nil){
            return selectedPm!
        }
        return nil
    }
    
    
    func createSetupIntent(completion: @escaping (setupIntent) -> Void){
        functions.httpsCallable("createSetupIntent").call(["customer" : UserData.shared.user?.stripe_Id]){(response,error) in
            if let error = error {
                print("def \(error)")
                completion(setupIntent(id: "", client_secret: "", status: "error: \(error)"))
            }
            if let processedResponse = (response?.data as? [String:Any]) {
                print("def \(processedResponse)")
                let intent = JSON(response?.data)
                print(self.parseSetiJSON(intent))
                completion(self.parseSetiJSON(intent))
                
            }
            completion(setupIntent(id: "", client_secret: "", status: "not completed"))
        }
    }
    
    func deletePaymentMethod(pm: String){
        functions.httpsCallable("deletePaymentMethod").call(["paymentMethodId" : pm]){ [self](response,error) in
            if let error = error {
                print("def \(error)")
            }
            if let processedResponse = (response?.data as? [String:Any]) {
                print("def \(processedResponse)")
                let json = JSON(response?.data)
                print(json)
            }
        }
    }
    
    func retrievePaymentMethods(){
        functions.httpsCallable("listPaymentMethods").call(["customer" : UserData.shared.user?.stripe_Id]){ [self](response,error) in
            if let error = error {
                print("def \(error)")
            }
            if let processedResponse = (response?.data as? [String:Any]) {
                print("def \(processedResponse)")
                let json = JSON(response?.data)
                self.parsePaymentMethods(json: json)
            }
        }
    }
    
    func getCustomer(cus: String){
        
    }
    
    func parsePaymentMethods(json: JSON){
        let jsonData = json["data"]
        for (index, object) in jsonData{
            var pm = PaymentMethod(id: "", cardLast4Numbers: "", lastUsed: false, exp_year: 0, exp_month: 0, cardType: "")
            if let id = object["id"].string {
                pm.id = id
            }
            if let last4 = object["card"]["last4"].string {
                pm.cardLast4Numbers = last4
            }
            if let cardType = object["card"]["brand"].string {
                pm.cardType = cardType
            }
            if let last4 = object["card"]["last4"].string {
                pm.cardLast4Numbers = last4
            }
            if let cardType = object["card"]["brand"].string {
                pm.cardType = cardType
            }
            if let expmonth = object["card"]["exp_month"].int {
                pm.exp_month = expmonth
            }
            if let expyear = object["card"]["exp_year"].int {
                pm.exp_year = expyear
            }
            
            if (UserData.shared.cards.firstIndex(where: {$0.id == pm.id}) == nil){
                UserData.shared.cards.append(pm)
            }
        }
    }
    
    
    
    
    
    func parseTransactionJSON(_ json: JSON) -> StripeTransaction {
        var transaction = StripeTransaction(id: "", currency: "", paid: 0, amount: 0, datetime: "", livemode: 0, payment_method: "", review: "", failure_code: "", customer: "", status: "", secret: "")
        
        if let id = json["id"].string {
            transaction.id = id
        }
        if let currency = json["currency"].string{
            transaction.currency = currency
        }
        if let paid = json["paid"].int{
            transaction.paid = paid
        }
        if let amount = json["amount"].int{
            transaction.amount = amount
        }
        if let datetime = json["created"].string{
            transaction.datetime = datetime
        }
        if let livemode = json["livemode"].int{
            transaction.livemode = livemode
        }
        if let payment_method = json["payment_method"].string{
            transaction.payment_method = payment_method
        }
        if let review = json["review"].string{
            transaction.review = review
        }
        if let failure_code = json["failure_code"].string{
            transaction.failure_code = failure_code
        }
        if let customer = json["customer"].string{
            transaction.customer = customer
        }
        if let status = json["status"].string{
            transaction.status = status
        }
        if let secret = json["client_secret"].string{
            transaction.secret = secret
        }
        
        
        
        return transaction
    }
    func parseSetiJSON(_ json: JSON) -> setupIntent {
        var intent = setupIntent(id: "", client_secret: "", status: "")
        
        if let id = json["id"].string {
            intent.id = id
        }
        
        if let secret = json["client_secret"].string{
            intent.client_secret = secret
        }
        
        if let status = json["status"].string{
            intent.status = status
        }
        
        return intent
    }
    
   
    
    
    
    
}




struct StripeTransaction : Identifiable{
    var id : String
    var currency : String
    var paid : Int
    var amount : Int
    var datetime : String
    var livemode : Int
    var payment_method : String
    var review : String
    var failure_code : String
    var customer : String
    var status : String
    var secret : String
}

struct setupIntent : Identifiable{
    var id : String
    var client_secret : String
    var status : String
 }

struct FakeStripeView: UIViewControllerRepresentable {
    @EnvironmentObject var navView : NavView
    
    public typealias UIViewControllerType = FakeStripeViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<FakeStripeView>) -> FakeStripeViewController {
        let viewController = FakeStripeViewController.shared
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: FakeStripeViewController, context _: UIViewControllerRepresentableContext<FakeStripeView>) {}
}

class FakeStripeViewController: UIViewController {
    
    static let shared = FakeStripeViewController()
    var navView: NavView?
        
        convenience init() {
            self.init(navView: nil)
        }
        
        init(navView: NavView?) {
            self.navView = navView
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
    
    func createSetupIntent(cardParams: STPPaymentMethodCardParams, billing: STPPaymentMethodBillingDetails, completion: @escaping (Bool) -> ()) {
        StripeAPIClient.shared.createSetupIntent(completion: { (setupIntent) in
            if(setupIntent.status != "not completed"){
                if(setupIntent.status.contains("error:")){
                    print(setupIntent.status)
                }
                else{
                    let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: billing, metadata: nil)
                    let setupIntentParams = STPSetupIntentConfirmParams(clientSecret: setupIntent.client_secret)
                    setupIntentParams.paymentMethodParams = paymentMethodParams
                    
                    let paymentHandler = STPPaymentHandler.shared()
                    paymentHandler.confirmSetupIntent(setupIntentParams, with: self) { status, setupIntent, error in
                                switch (status) {
                                case .failed:
                                    // Setup failed
                                    break
                                case .canceled:
                                    // Setup canceled
                                    break
                                case .succeeded:
                                    print("successful")
                                    StripeAPIClient.shared.retrievePaymentMethods()
                                    completion(true)
                                    self.navView?.isActive = false
                                    self.navView?.addNewCard = false
                                    break
                                @unknown default:
                                    fatalError()
                                    break
                                }
                            }
                        }
                    }
                })
            }
    func confirm(transaction: StripeTransaction,eventId : String, organiserId : String){
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: transaction.secret)
        
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
            
            switch (status){
                    case .failed:
                        PaymentController.shared.stripeResponseFailed(error: error as! Error)
                        StripeAPIClient.shared.handleTransaction(transaction: transaction, eventId: eventId, organiserId : organiserId)
                        break
                    case .canceled:
                        PaymentController.shared.stripeResponseFailed(error: error as! Error)
                        break
                    case .succeeded:
                        PaymentController.shared.stripeResponseSuccess(transaction: StripeTransaction(id: "", currency: "", paid: 0, amount: 0, datetime: "", livemode: 0, payment_method: "", review: "", failure_code: "", customer: "", status: "successful" , secret: ""))
                        StripeAPIClient.shared.handleTransaction(transaction: transaction, eventId: eventId, organiserId : organiserId)
                        break
                    @unknown default:
                        fatalError()
                        break
                
            }
            
        }
        
        
        
    }
    
    
}

extension FakeStripeViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        self
    }
}
