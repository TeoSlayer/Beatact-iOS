//
//  FilterSheet.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 22.03.2021.
//

import SwiftUI
import Sliders

struct FilterSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var eventdata : EventData
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var types = ["Party","HouseParty","Festival","Charity"]
    var genres = ["Techno","EDM","Minimal","DnB","Dubstep","House","Dark"]
    var sort = ["Trending","Most Views","Favorites","Low Price"]
    var body: some View {
        VStack(alignment: .leading){
            Group(){
            Text("Filters")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .padding(22)
            
            Text("Max Price: \(Int(eventdata.price)) RON")
                .font(.system(size: 25, weight: .bold, design: .default))
                .padding(.horizontal,22)
            HStack{
            Text("0")
                .font(.system(size: 20, weight: .bold, design: .default))
                Slider(value: $eventdata.price, in: 0...1000)
            Text("1000")
                .font(.system(size: 20, weight: .bold, design: .default))
            }.padding(.horizontal,22)
            Divider()
            Text("Genre")
                .font(.system(size: 24, weight: .bold, design: .default))
                .padding().padding(.horizontal)
            LazyVGrid(columns: columns){
                ForEach(genres,id: \.self){genre in
                    if isSelected(type: genre,arr: genres, selected: self.eventdata.selectedGenre){
                        Button(action: {
                            self.eventdata.selectedGenre = -1
                        }, label: {
                            Rectangle()
                                .foregroundColor(beatactViolet)
                                .cornerRadius(15)
                                .frame(height:60)
                                .shadow(radius: 2)
                                .overlay(Text(genre).foregroundColor(.white).font(.system(size: 13, weight: .bold, design: .default)))
                        })
                    }
                    else{
                        Button(action: {
                            self.eventdata.selectedGenre = find(value: genre, in: genres)!
                        }, label: {
                            Rectangle()
                                .foregroundColor(Color(UIColor.systemBackground))
                                .cornerRadius(15)
                                .frame(height:60)
                                .shadow(color: colorScheme == .dark ? Color.white : Color.black, radius: 2)
                                .overlay(Text(genre).font(.system(size: 13, weight: .bold, design: .default)))
                        })
                        
                    }
                    
                }
            }.padding(.horizontal,22)
            Group{
            Divider()
                .padding()
            Text("Sort By")
                .font(.system(size: 24, weight: .bold, design: .default))
                .padding().padding(.horizontal)
            }
            HStack{
                ForEach(sort,id: \.self){val in
                    if isSelected(type: val,arr: sort, selected: self.eventdata.selectedSort){
                        Button(action: {
                            self.eventdata.selectedSort = -1
                        }, label: {
                            Rectangle()
                                .foregroundColor(beatactViolet)
                                .cornerRadius(15)
                                .frame(height:60)
                                .shadow(radius: 2)
                                .overlay(Text(val).foregroundColor(.white).font(.system(size: 13, weight: .bold, design: .default)))
                        })
                    }
                    else{
                        Button(action: {
                            self.eventdata.selectedSort = find(value: val, in: sort)!
                        }, label: {
                            Rectangle()
                                .foregroundColor(Color(UIColor.systemBackground))
                                .cornerRadius(15)
                                .frame(height:60)
                                .shadow(color: colorScheme == .dark ? Color.white : Color.black, radius: 2)
                                .overlay(Text(val).font(.system(size: 13, weight: .bold, design: .default)))
                        })
                        
                    }
                    
                }
            }.padding(.horizontal,22)
            }
            Spacer()
            HStack{
                if(self.eventdata.selectedSort != -1 || self.eventdata.selectedGenre != -1 || self.eventdata.price != 1000){
                    Button(action: {
                        self.eventdata.filterPresented = false
                        self.eventdata.filterActive = true
                        self.eventdata.applyFilters()
                    }, label: {
                    Capsule()
                        .foregroundColor(beatactViolet)
                        .frame(height: 60)
                        .overlay(Text("Apply Filters").foregroundColor(.white).font(.system(size: 18, weight: .bold, design: .default)))
                    })
                    Button(action: {
                        self.eventdata.selectedSort = -1
                        self.eventdata.selectedGenre = -1
                        self.eventdata.price = 1000
                    }, label: {
                        Capsule()
                            .stroke(lineWidth: 3)
                            .foregroundColor(.red)
                            .frame(height: 60)
                            .overlay(Text("Clear Filters").foregroundColor(.red).font(.system(size: 18, weight: .bold, design: .default)))
                    })
                }
                else{
                    Button(action: {
                        self.eventdata.filterPresented = false
                        self.eventdata.filterActive = false
                    }, label: {
                        Capsule()
                            .foregroundColor(beatactViolet)
                            .frame(height: 60)
                            .overlay(Text("Back").foregroundColor(.white).font(.system(size: 22, weight: .bold, design: .default)))
                    })
                    
                }
            }.padding(22)
            
        }.navigationTitle("Filters")
    }
    
    func isSelected(type : String, arr: [String], selected: Int) -> Bool{
        let index = find(value: type, in: arr)
        if(index == selected){
            return true
        }
        else{
            return false
        }
    }
    func find(value searchValue: String, in array: [String]) -> Int?
    {
        for (index, value) in array.enumerated()
        {
            if value == searchValue {
                return index
            }
        }
        
        return nil
    }
}

struct FilterSheet_Previews: PreviewProvider {
    static var previews: some View {
        FilterSheet().environmentObject(EventData.shared)
            .preferredColorScheme(.light)
    }
}
