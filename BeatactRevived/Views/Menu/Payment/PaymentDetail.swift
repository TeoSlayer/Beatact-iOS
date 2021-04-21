//
//  PaymentDetail.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import SwiftUI

struct PaymentDetail: View {
    @Binding var paymentMethod : PaymentMethod?
    @Binding var isActive: Bool
    var body: some View {
        VStack(alignment: .leading){
            Form{
            Section{
            HStack{
                VStack(alignment: .leading){
                    Text("\(paymentMethod!.cardType)")
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .foregroundColor(beatactViolet)
                        .padding(.all,5)
                    Text("···· \(paymentMethod!.cardLast4Numbers)")
                        .font(.system(size: 15, weight: .bold, design: .default))
                        .foregroundColor(Color(.gray))
                        .padding(.all,5)
                    
                }
                Spacer()
                if(paymentMethod!.cardType.lowercased().contains("mastercard")){
                    Image("Mastercard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:40)
                }
                if(paymentMethod!.cardType.lowercased().contains("maestro")){
                    Image("Maestro")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:40)
                        
                }
                if(paymentMethod!.cardType.lowercased().contains("visa")){
                    Image("Visa")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:40)
                }
                if(paymentMethod!.cardType.lowercased().contains("american")){
                    Image("American Express")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:40)
                }
            }.padding()
            .padding(.bottom,20)
            VStack(alignment: .leading){
                Text("Expiry Date")
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .foregroundColor(Color(.gray))
                Text("\(paymentMethod!.exp_month)/\(String(describing: paymentMethod!.exp_year))")
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .foregroundColor(beatactViolet)
            }.padding()
            }
            Section(content: {
                Button(action: {
                    StripeAPIClient.shared.deletePaymentMethod(pm: paymentMethod!.id)
                    self.isActive = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        UserData.shared.cards.removeAll{ card in
                            return card.id == paymentMethod!.id
                        }
                        self.paymentMethod = nil
                    })
                   
                }, label: {
                    HStack{
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .padding(.trailing)
                        Text("Remove payment method")
                            .font(.system(size: 15, weight: .bold, design: .default))
                            .foregroundColor(Color(.red))
                        Spacer()
                    }.padding()
                })
               
            })
            }
            
           
            
            
            Spacer()
            
        }.navigationBarTitle("Credit Card")
    }
}

struct PaymentDetail_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetail(paymentMethod: .constant(testCards.first!), isActive: .constant(true))
    }
}
