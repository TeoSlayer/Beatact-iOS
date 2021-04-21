//
//  ContentView.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userData : UserData
    @State private var selectedTab: Tabs = .tab1
    let numTabs = 4
    let minDragTranslationForSwipe: CGFloat = 50
    
    var body: some View {
        if(userData.loggedIn == true && userData.onBoarding == false){
            NavigationView{
                TabView(selection: $selectedTab){
                    Find().environmentObject(EventData.shared)
                    .tabItem {
                        Image(systemName: "magnifyingglass.circle.fill")
                        Text("Find")
                    }.tag(Tabs.tab1)
                    Featured().environmentObject(EventData.shared)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Featured")
                    }.tag(Tabs.tab2)
                    Orders().environmentObject(OrderData.shared)
                    .tabItem {
                        Image("ordersTab")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("Orders")
                    }.tag(Tabs.tab3)
                    Menu(user: testUser).environmentObject(UserData.shared)
                    .tabItem {
                        Image(systemName: "text.justify")
                        Text("Menu")
                    }.tag(Tabs.tab4)
                }.navigationBarTitle(returnNaviBarTitle(tabSelection: self.selectedTab))
            }.navigationViewStyle(StackNavigationViewStyle())
             
        }
        else{
            LoginView()
        }
    }
    
    enum Tabs{
            case tab1, tab2, tab3, tab4
        }
        
        func returnNaviBarTitle(tabSelection: Tabs) -> String{//this function will return the correct NavigationBarTitle when different tab is selected.
            switch tabSelection{
                case .tab1: return "Find"
                case .tab2: return "Featured"
                case .tab3: return "Orders"
                case .tab4: return "Menu"
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserData.shared)
    }
}
