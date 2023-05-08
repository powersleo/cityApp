//
//  MapView.swift
//  City
//
//  Created by Leo Powers on 5/4/23.
//

import SwiftUI
import MapKit


struct MapView: View {
    
    @StateObject var locationDataManager = LocationDataManager()
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var distance: String?
//    let searchResult: MKLocalSearchCompletion

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 0.0,
            longitude: 0.0),
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03)
    )
    
    @State private var searchText = ""

    var body: some View {
        
        ZStack{
            Map(coordinateRegion: $region,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack {
//                    Text(<#T##attributedContent: AttributedString##AttributedString#>)
//                    TextField("Search..", text:searchResult).textFieldStyle(.roundedBorder)
    
                    Spacer()
                    VStack {
                        Button(action: {
                            userTrackingMode = .follow
                            switch locationDataManager.locationManager.authorizationStatus {
                            case .authorizedWhenInUse:
                                region.center.latitude = locationDataManager.locationManager.location?.coordinate.latitude ?? 0.0
                                region.center.longitude=locationDataManager.locationManager.location?.coordinate.longitude ?? 0.0
                                region.span.latitudeDelta = 0.01
                                region.span.longitudeDelta = 0.01
                                print("Your current location is:")
                                print("Latitude: \(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
                                print("Longitude: \(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")
                                
                            case .restricted, .denied:
                                print("Current location data was restricted or denied.")
                            case .notDetermined:
                                print("Finding your location...")
                            default:
                                break
                            }
                            
                            
                        }, label: {
                            Image(systemName: "house")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(10)
                            
                        })
                        
                        Button(action: {
                            userTrackingMode = .none
                            
                            
                            region.span.latitudeDelta *= 0.6
                            region.span.longitudeDelta *= 0.6
                            
                        }, label: {
                            Image(systemName: "plus.magnifyingglass")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(10)
                            
                        })
                        Button(action: {
                            userTrackingMode = .none
                            region.span.latitudeDelta /= 0.6
                            region.span.longitudeDelta /= 0.6
                            
                        }, label: {
                            Image(systemName: "minus.magnifyingglass")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(10)
                            
                        })
                        
                        //                        Button(action: {
                        //
                        //                        }, label: {
                        //                            Image(systemName: "clock")
                        //                                .resizable()
                        //                                .frame(width: 40, height: 40)
                        //                                .padding(10)
                        //
                        //                        })
                        
                    } //: END VStack
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(uiColor: .systemBackground))
                        .tint(Color(uiColor: .secondaryLabel))}
                    .padding(10)
                    
                } //: END HStack
                Spacer()
            }
        }
    }
}

