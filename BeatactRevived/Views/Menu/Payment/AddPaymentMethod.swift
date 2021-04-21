//
//  AddPaymentMethod.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 01.04.2021.
//

import SwiftUI
import Stripe


struct AddPaymentMethod: View {
    @State var params = STPPaymentMethodParams()
    @State var isValid = true
    @EnvironmentObject var navView : NavView
    
    
    @State var showAlert = false
    var body: some View {
        ScrollView{
        VStack(alignment: .center){
           /* CCView(cardNum: $params.card.wrappedValue?.number, cardExpM: $params.card.wrappedValue?.expMonth, cardExpY: $params.card.wrappedValue?.expYear)
                .padding(.leading,10)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: UIScreen.main.bounds.width/2)
                .padding(.bottom)&*/
            
            
                
            
            addCard(params: $params, isValid: $isValid)
                .frame(height: 400)
                .padding()

            Button(action: {
                if(params.card != nil && params.billingDetails != nil){
                    FakeStripeViewController.shared.createSetupIntent(cardParams: params.card!, billing: params.billingDetails!, completion: { state in
                        if(state){
                            navView.addNewCard = false
                        }
                    })
                }
                else{
                    self.showAlert = true
                }
                
            }, label: {
                Text("Submit")
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(beatactViolet)
                    .modifier(EventCardModifier())
                    .padding([.horizontal, .bottom])
                    
            })
            
            Button(action: {
                navView.addNewCard = false
            }, label: {
                Text("Exit")
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(beatactViolet)
                    .modifier(EventCardModifier())
                    .padding(.horizontal)
                    
            })
            Spacer()
            FakeStripeView()
                .frame(width: 0, height: 0).environmentObject(NavView.shared)
        }
        }.alert(isPresented: $showAlert, content: {
            Alert(title: Text("Card/Adress Invalid"), message: Text("Please try again."), dismissButton: .default(Text("OK!")))
        }).navigationTitle("Add card")
    }
}

struct AddPaymentMethod_Previews: PreviewProvider {
    static var previews: some View {
        AddPaymentMethod().environmentObject(NavView.shared)
    }
}

