//
//  PaymentStatus.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 01.04.2021.
//

import SwiftUI

struct PaymentStatus: View {
    @EnvironmentObject var paymentController : PaymentController
    var body: some View {
        if(paymentController.pmState == nil){
            VStack(alignment: .center){
                Spacer()
                Text("Transaction pending")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(beatactViolet)
                    .padding(.all,5)
                Text("Please wait as we process your payment")
                    .font(.system(size: 14, weight: .light, design: .default))
                    .foregroundColor(beatactViolet)
                    .padding(.all,5)
                    .padding(.bottom)
                LoadingCircle()
                Spacer()
            }.frame(width: UIScreen.main.bounds.width).navigationBarHidden(true)
        }
        else{
            if(paymentController.pmState?.successful == true){
                VStack{
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.green)
                        .frame(width: UIScreen.main.bounds.width/4)
                    Spacer()
                    Text("Transaction Successful")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(beatactViolet)
                        .padding(.all,5)
                    Text("Check the 'Orders' Tab")
                        .font(.system(size: 14, weight: .light, design: .default))
                        .foregroundColor(beatactViolet)
                        .padding(.all,5)
                        .padding(.bottom)
                    Spacer()
                
                    Button(action: {
                        NavView.shared.selection = nil
                        paymentController.pmState = nil
                    }, label: {
                        Text("Return to Event")
                    })
   
                    
                }
            }
            if(paymentController.pmState?.successful == false){
                VStack{
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.red)
                        .frame(width: UIScreen.main.bounds.width/4)
                    Spacer()
                    Text("Transaction Failed")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(beatactViolet)
                        .padding(.all,5)
                    Text("Unfortunately, we can't process your payment!")
                        .font(.system(size: 14, weight: .light, design: .default))
                        .foregroundColor(beatactViolet)
                        .padding(.all,5)
                        .padding(.bottom)
                    Spacer()
                    
                    Button(action: {
                        NavView.shared.selection = nil
                        paymentController.pmState = nil
                    }, label: {
                        Text("Return to Event")
                    })
                        
                        
                    
                }.navigationBarHidden(true)
            }
        }
        FakeStripeView()
            .frame(width: 0, height: 0).environmentObject(NavView.shared)
    }
}

struct PaymentStatus_Previews: PreviewProvider {
    static var previews: some View {
        PaymentStatus()
    }
}

struct LoadingCircle: View {
 
    @State private var isLoading = false
 
    var body: some View {
        ZStack {
 
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 14)
                .frame(width: 100, height: 100)
 
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(beatactViolet, lineWidth: 7)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                    self.isLoading = true
            }
        }
    }
}
