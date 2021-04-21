//
//  PaymentList.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import SwiftUI

struct PaymentList: View {
    @EnvironmentObject var navView : NavView
    @State var isActive = false
    @State var selectedPm : PaymentMethod?
    var cards : [PaymentMethod]
    var body: some View {
        ZStack{
            Form{
                Section(header: Text("CREDIT CARDS")){
                    ForEach(cards){card in
                        
                        Button(action: {
                            self.isActive = true
                            self.selectedPm = card
                        }, label: {
                            PaymentMethodRow(isPreffered: card.lastUsed, number: card.cardLast4Numbers, expm: card.exp_month, expy: card.exp_year, brand: card.cardType)
                        })
                        
                        
                        
                    }
                    Button(action: {
                        self.navView.addNewCard = true
                    }, label: {
                        HStack(alignment: .center){
                            Text("+ Add Payment Method")
                                .font(.system(size: 15, weight: .bold, design: .default))
                                .foregroundColor(beatactViolet)
                                .padding(.all,5)
                                .padding(.trailing)
                            Spacer()
                            
                        }.frame(height: 30)
                         .frame(maxWidth: .infinity,alignment: .center)
                         .padding(.all, 10)
                    })
                }
                
                Section(header: Text("Vouchers")){
                    HStack(alignment: .center){
                        Image("Voucher")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal)
                        Text("Credit:")
                            .font(.system(size: 15, weight: .bold, design: .default))
                            .foregroundColor(beatactViolet)
                            .padding(.all,5)
                        Text("124 RON")
                            .font(.system(size: 15, weight: .bold, design: .default))
                            .foregroundColor(beatactViolet)
                            .padding(.all,5)
                        Spacer()
                        
                        
                    }.frame(height: 30)
                     .frame(maxWidth: .infinity,alignment: .center)
                     .padding(.all, 10)
                }
                
                
            }
            NavigationLink(
                destination: AddPaymentMethod().environmentObject(NavView.shared),
                isActive: $navView.addNewCard, label: {})
            NavigationLink(
                destination: PaymentDetail(paymentMethod: $selectedPm, isActive: $isActive),
                isActive: $isActive,
                label: {})
        }.navigationBarTitle("Payment Methods")
    }
}

struct PaymentList_Previews: PreviewProvider {
    static var previews: some View {
        PaymentList(cards: testCards).environmentObject(NavView.shared)
    }
}
