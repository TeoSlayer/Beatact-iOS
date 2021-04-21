//
//  MapViewHelpers.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import SwiftUI
import MapKit

struct MapAnnotationPin: View {
    var name : String
    var venue : String
    var body: some View {
        VStack{
        ZStack{
        Rectangle()
            .foregroundColor(beatactViolet)
            .cornerRadius(3)
        VStack{
            Text(name)
            .font(.title2)
            .foregroundColor(.white)
            Text(venue)
            .foregroundColor(.white)
        }
        }
        
        
        Circle()
            .foregroundColor(beatactViolet)
        }
    }
}

struct Item: Identifiable {
  var id: UUID = .init()
  var latitude: Double
  var longitude: Double
  var coordinate: CLLocationCoordinate2D {
    return .init(latitude: latitude, longitude: longitude)
  }
}
