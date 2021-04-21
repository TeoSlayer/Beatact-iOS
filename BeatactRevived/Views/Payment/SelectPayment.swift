//
//  SelectPayment.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 01.04.2021.
//

import SwiftUI

struct SelectPayment: View {
    @EnvironmentObject var userData : UserData
    @EnvironmentObject var navView : NavView
    @Binding  var isActive : Bool
    @State var status = false
    @State var addNewCard = false
    var event : Event
    var body: some View {
                ZStack(){
                    VStack(alignment: .leading){

                    Form{
                        Section(){
                            Text("Please Select a Payment Method")
                             .font(.system(size: 15, weight: .bold, design: .default))
                             .foregroundColor(beatactViolet)
                             .padding(.all,5)
                            ForEach(userData.cards){pm in
                            
                            Button(action: {
                                selectPayment(id: pm.id)
                                
                            }, label: {
                                PaymentMethodRow(isPreffered: pm.lastUsed, number: pm.cardLast4Numbers,expm: pm.exp_month,expy: pm.exp_year, brand: pm.cardType)
                            })
                            }
                            
                        }
                        Section(){
                            Button(action: {
                                    self.navView.addNewCard = true
                                }, label: {
                                    Text("+ Add payment method")
                                        .font(.system(size: 15, weight: .bold, design: .default))
                                        .foregroundColor(beatactViolet)
                                        .padding(.all,5)
                                })
                        }
                            
                      }
                        Spacer()
                        
                    }
                    VStack(alignment: .center){
                        Spacer()
                        NavigationLink(
                            destination: AddPaymentMethod().environmentObject(NavView.shared),
                            isActive: $navView.addNewCard, label: {})
                        if(StripeAPIClient.shared.getSelectedPm() != nil){
                            Button(action: {
                                PaymentController.shared.buyButtonPressed(eventid: event.id, organiserId: event.organiserId)
                                self.status = true
                            }, label: {
                                HStack{
                                Text("Pay Now")
                                    .foregroundColor(Color.white)
                                    .font(.title)
                                Capsule()
                                    .foregroundColor(Color.white)
                                    .frame(height: 40)
                                    .frame(maxWidth: 100)
                                    .overlay(Text("\(String.init(String(describing: event.price))) RON")
                                        .foregroundColor(beatactViolet))
                                    
                                } .frame(height: 50)
                                .frame(maxWidth: .infinity,alignment: .center)
                                .background(beatactViolet)
                                .modifier(EventCardModifier())
                                .padding(.all, 10)
                                .padding(.bottom, 10)
                            })
                            NavigationLink(
                                destination: PaymentStatus().environmentObject(PaymentController.shared),
                                isActive: $status,
                                label: {}).isDetailLink(false)
                        }
                        
                    
                       }
                }.edgesIgnoringSafeArea(.all).navigationBarTitle("Select Payment")
            }
            
    func selectPayment(id: String){
        for index in 0..<self.userData.cards.count{
            if(self.userData.cards[index].lastUsed == true){
                self.userData.cards[index].lastUsed = false
            }
        }
        for index in 0..<self.userData.cards.count{
            if(self.userData.cards[index].id == id){
                self.userData.cards[index].lastUsed = true
            }
        }
    }

}
struct SelectPayment_Previews: PreviewProvider {
    static var previews: some View {
        SelectPayment(isActive: .constant(false), event: testEvent)
    }
}
