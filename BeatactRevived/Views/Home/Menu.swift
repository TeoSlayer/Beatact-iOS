//
//  Menu.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import SwiftUI

struct Menu: View {
    @EnvironmentObject var userData : UserData
    @Environment(\.colorScheme) var colorScheme
    var user : User
    var body: some View {
        ZStack{
            Form{
                    Section(){
                    NavigationLink(
                        destination: UserSettings(user: self.userData.user!).environmentObject(LeaderBoardData.shared),
                        label: {
                            
                            HStack(alignment: .center){
                            Image("sampleUserProfile")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(height: 60)
                                .padding(10)
                                
                            VStack(alignment: .leading){
                                Text(userData.user!.name)
                                    .foregroundColor(beatactViolet)
                                    .padding(1)
                                Text(userData.user!.email)
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.gray)
                                    .padding(2)
                            }
                            }
                          })
                    }
                    Section(header: Text("")){
                    NavigationLink(
                        destination: PaymentList(cards: userData.cards).environmentObject(NavView.shared),
                        label: {
                            
                            HStack(alignment: .center){
                            Image(systemName: "creditcard.fill")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(beatactViolet)
                                .frame(height: 15)
                            Text("Payment")
                                .foregroundColor(beatactViolet)
                                .padding(2)
                            Spacer()
                            Text("Valid")
                                .foregroundColor(Color.green)
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green)
                            }.padding(5)
                        })
                    
                    NavigationLink(
                        destination: PastEvents().environmentObject(OrderData.shared),
                        label: {
                            
                            HStack(alignment: .center){
                            Image(systemName: "archivebox.fill")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(beatactViolet)
                                .frame(height: 20)
                            Text("Past Events")
                                .foregroundColor(beatactViolet)
                                .padding(2)
                            Spacer()
                            Image(systemName: "4.circle.fill")
                                .foregroundColor(beatactViolet)
                            }.padding(5)
                        })
                    }
                    Section(){
                    NavigationLink(
                        destination: LeaderBoard().environmentObject(LeaderBoardData.shared),
                    label: {
                        
                        HStack(alignment: .center){
                        Image("Leaderboard")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.yellow)
                            .frame(height: 25)
                        Text("LeaderBoard")
                            .foregroundColor(Color.yellow)
                            .padding(2)
                        }.padding(5)
                    })
                    }
                
                    Section(){
                    NavigationLink(
                    destination: PrivacyPolicy(),
                    label: {
                        
                        HStack(alignment: .center){
                        Image(systemName: "eye.fill")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(beatactViolet)
                            .frame(height: 15)
                        Text("Privacy Policy")
                            .foregroundColor(beatactViolet)
                            .padding(2)
                        }.padding(5)
                    })
                
                NavigationLink(
                    destination: TermsAndConditions(),
                    label: {
                        
                        HStack(alignment: .center){
                        Image(systemName: "doc.text.magnifyingglass")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(beatactViolet)
                            .frame(height: 20)
                        Text("Terms & Conditions")
                            .foregroundColor(beatactViolet)
                            .padding(2)
                        }.padding(5)
                    })
                }
                
                Section(){
                NavigationLink(
                destination: EmptyView(),
                label: {
                    
                    HStack(alignment: .center){
                    Image(systemName: "questionmark.diamond.fill")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.red)
                        .frame(height: 15)
                    Text("Help")
                        .foregroundColor(.red)
                        .padding(2)
                    }.padding(5)
                })
            
            }

                    
                
            }
        }.navigationBarTitle("Menu")
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu(user: testUser).environmentObject(UserData.shared)
    }
}
