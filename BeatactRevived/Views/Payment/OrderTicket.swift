//
//  OrderTicket.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 01.04.2021.
//

import SwiftUI

struct OrderTicket: View {
    @Binding  var isActive : Bool
    var event : Event
    var body: some View {
        VStack(alignment: .center){
            ScrollView{
            VStack(alignment: .leading){
                AsyncImage(url: URL(string: event.images.first!)!, placeholder:
                            
                            {
                                HStack{
                                    Spacer()
                                    Text("Loading...")
                                    Spacer()
                                }
                },image: {Image(uiImage: $0) .resizable()}
                )
                .aspectRatio(contentMode: .fit)
                .clipShape(Rectangle())
                .cornerRadius(15)
                .modifier(EventCardModifier())
                .padding()
                CheckoutCard(title: event.name, price: event.price)
            }
            }
            Spacer()
            VStack{
                Divider()
                
                HStack(alignment: .center){
                    Text("Amount To Pay:")
                        .foregroundColor(Color(.white))
                        .font(.system(size: 20, weight: .bold, design: .default))
                    Spacer()
                    Text(String.init(String(describing: event.price) + " RON"))
                        .foregroundColor(Color(.white))
                        .font(.system(size: 20, weight: .bold, design: .default))
                }.padding(.vertical,10)
                 .padding([.leading,.trailing])
                Button(action: {
                    
                }, label: {
                    Rectangle()
                        .foregroundColor(.black)
                        .frame(height: 60)
                        .cornerRadius(15)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal)
                        .overlay(Text("Apple pay").foregroundColor(.white))
                    //SelectPaymentButton()
                })
                //PaymentButton(agreeTerms: $agreedToTerms, event: event)
                NavigationLink(
                    destination: SelectPayment(isActive: self.$isActive, event: event).environmentObject(UserData.shared).environmentObject(NavView.shared),
                    label: {
                        Rectangle()
                            .frame(height: 60)
                            .cornerRadius(15)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            .padding(.horizontal)
                            .overlay(Text("Select Payment Method").foregroundColor(.white))
                            .padding(.bottom,20)
                            //SelectPaymentButton()
                        
                }).isDetailLink(false)
                
            }.background(beatactViolet)
              
        }.edgesIgnoringSafeArea(.bottom).navigationBarTitle("Order Ticket")
    }
}



struct OrderTicket_Previews: PreviewProvider {
    static var previews: some View {
        OrderTicket(isActive: .constant(false), event: testEvent)
           
    }
}
