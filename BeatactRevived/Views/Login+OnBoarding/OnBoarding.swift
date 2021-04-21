//
//  OnBoarding.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 01.04.2021.
//

import SwiftUI
import FirebaseAuth
import iPhoneNumberField
import FirebaseFunctions


struct OnBoarding: View {
    @Binding var isActive : Bool
    @State var step = 1
    @State var name = ""
    @State var phoneConfirmed = false
    @State var phone = ""
    @State var termsConfirm = false
    @State var showAlert = false
    @State var alertCase : ActiveAlert = .nameEmpty
    var body: some View {
        ZStack(alignment: .center){
            
            Image("backgroundlogin")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width)
                .ignoresSafeArea(.all)
            VStack{
                Spacer()
                if(step == 1){
                    askNameCard(name: $name)
                }
                if(step == 2){
                    askPhoneCard(phone: $phone, codeSuccesful: $phoneConfirmed)
                }
                if(step == 3){
                    askTerms(terms: $termsConfirm)
                }
                HStack(){
                    Button(action: {
                        if(step != 1){
                            self.step-=1
                        }
                        else{
                            self.isActive = false
                        }
                    }, label: {
                        Rectangle()
                            .cornerRadius(15)
                            .overlay(
                                Text(step == 1 ? "Cancel" : "Back")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold, design: .default))
                            )
                            
                            
                    })
                    Button(action: {
                            if(step == 1){
                                if(name.isEmpty){
                                    showAlert = true
                                    self.alertCase = .nameEmpty
                                }
                                else{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        self.step+=1
                                    })
                                    
                                }
                            }
                            if(step == 2){
                                if(phone.isEmpty){
                                    showAlert = true
                                    self.alertCase = .phoneEmpty
                                }
                                else{
                                    if(phoneConfirmed == false){
                                        showAlert = true
                                        self.alertCase = .phoneNotVerified
                                    }
                                    else{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                            self.step+=1
                                        })
                                    }
                                }
                            }
                            if(step == 3){
                                if(termsConfirm == false){
                                    showAlert = true
                                    self.alertCase = .termsNotAgreed
                                }
                                else{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        UserData.shared.pushUser(id: Auth.auth().currentUser?.uid ?? "", name: self.name, phone: self.phone, email: Auth.auth().currentUser?.email ?? "")
                                    })
                                    
                                }
                            }
                       
                        
                    }, label: {
                            
                        Rectangle()
                            .cornerRadius(15)
                            .overlay(
                                Text(step == 3 ? "Done" : "Next")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold, design: .default))
                            )
                            
                    })
                }.frame(height: 60)
                 .frame(maxWidth: UIScreen.main.bounds.width/1.3)
                 .padding(.top)
                    
                Spacer()
                
            }
            
            
        }.edgesIgnoringSafeArea(.horizontal)
        .alert(isPresented: $showAlert) {
            switch alertCase {
            case .nameEmpty:
                return Alert(title: Text("Name incomplete/empty"), message: Text("Please fill your name in the name textfield."), dismissButton: .default(Text("OK")))
            case .phoneEmpty:
                return Alert(title: Text("Phone incomplete/empty"), message: Text("Please fill your phone number in the phone textfield."), dismissButton: .default(Text("OK")))
                
            case .phoneNotVerified:
                return Alert(title: Text("Phone not verified"), message: Text("Please verify your phone before continuing to the next step!"), dismissButton: .default(Text("OK")))
            case .termsNotAgreed:
                return Alert(title: Text("Terms not agreed!"), message: Text("Please read the terms and conditions and then press the tickmark."), dismissButton: .default(Text("OK")))
            case .error:
                return Alert(title: Text("Error"), message: Text("Please try again. Phone Error"), dismissButton: .default(Text("OK")))
                
                

            }
        }
    }
    
    enum ActiveAlert {
        case nameEmpty, phoneEmpty, phoneNotVerified, termsNotAgreed, error
    }

}

struct askNameCard: View{
    @Environment(\.colorScheme) var colorScheme
    @Binding var name : String
    var body : some View{
        VStack(alignment: .leading){
                Text("Please enter your name below:")
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .foregroundColor(beatactViolet)
                    .padding()
                ZStack{
                Capsule()
                    .stroke(lineWidth: 3)
                    .foregroundColor(beatactViolet)
                    .frame(height: 60)
                    .padding(.horizontal)
                TextField("John Wick...", text: $name)
                    .padding(.horizontal).padding(.leading)
                }.padding(.bottom)
            Text("Note: Please note that this name will appear on  your ticket(which might be subjected to an identity check).")
                .font(.system(size: 12, weight: .light, design: .default))
                .foregroundColor(beatactViolet)
                .padding()
        }.padding()
        .background(colorScheme == .dark ? Color.black : Color.white)
        .frame(maxWidth: UIScreen.main.bounds.width/1.3)
        .modifier(EventCardModifier())
        
    }
}

struct askPhoneCard: View{
    
    @Environment(\.colorScheme) var colorScheme
    @State private var timeRemaining = 60
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Binding var phone : String
    @State var countryCode = ""
    @State var code : String = ""
    @Binding var codeSuccesful : Bool
    @State var phoneSent = false
    var body : some View{
        VStack(alignment: .leading){
            
            if(phoneSent == false){
                Text("Please enter your phone number below:")
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .foregroundColor(beatactViolet)
                    .padding()
                
                iPhoneNumberField("(712) 345-678", text: $phone)
                                    .autofillPrefix(true)
                                    .prefixHidden(false)
                                    .flagHidden(false)
                                    .flagSelectable(true)
                                    .maximumDigits(10)
                                    .clearButtonMode(.whileEditing)
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal)
                                    .frame(height: 60)
                                    .background(beatactViolet)
                                    .cornerRadius(30)
                                    .padding(.horizontal)
                                    .padding(.bottom)
                Button(action: {
                    TwillioAPIClient.shared.sendPhone(phone: phone, countryCode: "", completion: { response in
                        if(response == "pending"){
                            self.phoneSent = true
                            self.timeRemaining = 60
                        }
                        else{
                            //
                        }
                    })
                   
                }, label: {
                    Rectangle()
                        .cornerRadius(50)
                        .padding(.horizontal)
                        .frame(height: 60)
                        .overlay(
                            Text("Verify Phone Number")
                                .font(.system(size: 15, weight: .bold, design: .default))
                                .foregroundColor(.white)
                                .padding()
                        )
                }).padding(.bottom)
            }
            else{
                if(codeSuccesful == false){
                Text("Please enter the code below:")
                        .font(.system(size: 25, weight: .bold, design: .default))
                        .foregroundColor(beatactViolet)
                        .padding()
                ZStack{
                Capsule()
                    .stroke(lineWidth: 3)
                    .foregroundColor(beatactViolet)
                    .frame(height: 60)
                    .padding(.horizontal)
                TextField("123456", text: $code)
                    .padding(.horizontal).padding(.leading).padding(.leading)
                }.padding(.bottom)
                
                Button(action: {
                    TwillioAPIClient.shared.checkCode(phone: phone, countryCode: "", code: code, completion: { response in
                        if(response == "approved"){
                            self.codeSuccesful = true
                        }
                    })
                }, label: {
                    Rectangle()
                        .cornerRadius(50)
                        .padding(.horizontal)
                        .frame(height: 60)
                        .overlay(
                            Text("Check Code")
                                .font(.system(size: 15, weight: .bold, design: .default))
                                .foregroundColor(.white)
                                .padding()
                        )
                }).padding(.bottom,4)
                HStack{
                    Spacer()
                    if(timeRemaining > 1){
                        Text("Retry in: \(timeRemaining) seconds")
                            .font(.system(size: 15, weight: .bold, design: .default))
                            .foregroundColor(beatactViolet)
                    }
                    else{
                        Button(action: {
                            self.phoneSent = false
                        }, label: {
                            Text("Retry")
                                .font(.system(size: 15, weight: .bold, design: .default))
                                .foregroundColor(beatactViolet)
                        })
                        
                        
                    }
                    Spacer()
                    }
                }
                else{
                    HStack{
                        Spacer()
                        Text("Phone Verified Succesfully")
                            .font(.system(size: 25, weight: .bold, design: .default))
                            .foregroundColor(beatactViolet)
                            .padding()
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.green)
                            .frame(height:60)
                        Spacer()
                    }
                    
                }
            }
            
                
        }.padding()
        .background(colorScheme == .dark ? Color.black : Color.white)
        .frame(maxWidth: UIScreen.main.bounds.width/1.3)
        .modifier(EventCardModifier())
        .onReceive(timer) { time in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
        
    }
    
    
    
    
}

struct askTerms: View{
    @Environment(\.colorScheme) var colorScheme
    @Binding var terms : Bool
    var body : some View{
        
        HStack{
            Spacer()
            Text("I agree to the terms and conditions:")
                .font(.system(size: 15, weight: .bold, design: .default))
                .foregroundColor(beatactViolet)
                .padding()
            Spacer()
            Button(action: {
                if(self.terms == true){
                    self.terms = false
                }
                else{
                    self.terms = true
                }
            }, label: {
                Image(systemName: terms == true ? "checkmark.circle.fill" : "checkmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(beatactViolet)
                    .frame(height:35)
            })
            Spacer()
                
        }.padding()
        .background(colorScheme == .dark ? Color.black : Color.white)
        .frame(maxWidth: UIScreen.main.bounds.width/1.3)
        .modifier(EventCardModifier())
        
    }
}

struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding(isActive: .constant(true)).colorScheme(.light)
    }
}
