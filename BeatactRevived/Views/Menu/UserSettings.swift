//
//  EditProfile.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import SwiftUI
import FirebaseAuth

struct  UserSettings: View {
        var user : User
        @EnvironmentObject var leaderBoard : LeaderBoardData
        @State var notificationsEnabled: Bool = false

        var body: some View {
                Form {
                    Section(header: Text("PROFILE")) {
                        Text(user.name)
                        HStack{
                        Text(user.email)
                        Spacer()
                            Text("Apple Login")
                                .foregroundColor(Color.green)
                        Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green)
                        }

                        HStack{
                        Text(user.phone)
                        Spacer()
                        Text("Verified")
                                .foregroundColor(Color.green)
                        Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green)
                        }
                    
                        Toggle(isOn: $leaderBoard.privateUser) {
                            Text("Private Account")
                        }.onTapGesture {
                            LeaderBoardData.shared.updatePersonalLeaderBoard()
                        }
                    }
                    
                    Section(header: Text("NOTIFICATIONS")) {
                        Toggle(isOn: $notificationsEnabled) {
                            Text("Enabled")
                        }
                    }
                    
                    Section(header: Text("ABOUT")) {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                        }
                    }
                    
                    Section {
                        Button(action: {
                            signOut()
                        }) {
                            Text("Log Out")
                                .foregroundColor(.red)
                        }
                    }
                }.navigationBarTitle("User Settings")
        }
    func signOut(){
        do { try Auth.auth().signOut()}
        catch { print("already logged out") }
        UserData.shared.user = UserData.shared.emptyUser()
        UserData.shared.loggedIn = false
        UserDefaults.standard.setValue(nil, forKey: "User")
        UserDefaults.standard.setValue(false, forKey: "loggedIn")
    }
}

struct UserSettings_Previews: PreviewProvider {
    static var previews: some View {
        UserSettings(user: testUser)
    }
}
