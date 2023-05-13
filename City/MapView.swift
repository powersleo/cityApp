import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var locationDataManager = LocationDataManager()
    @Binding var userTrackingMode: MapUserTrackingMode
    @Binding var region: MKCoordinateRegion
    @State private var searchText = ""
    var businesses: [Business]
    @State private var selectedBusiness: Business?
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: businesses
            ) { business in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)) {
                    Button(action: {
                        selectedBusiness = business  
                    }, label: {
                        Image(systemName: "wineglass.fill")
                            .foregroundColor(.red)
                    })
                    if(region.span.latitudeDelta <= 0.02
                       && region.span.longitudeDelta <= 0.02 ){
                        Text(business.name).font(.footnote)
                        
                    }
                }
            }.edgesIgnoringSafeArea(.all)
            .onTapGesture {
//                    if(selectedBusiness != nil ){
//                        self.selectedBusiness = nil
//
//                    }
                }

            
            if let selectedBusiness = selectedBusiness {
                VStack{
                    BusinessProfileView(business: selectedBusiness)
                    Button(action:{self.selectedBusiness = nil}, label:{Text("Close")}  )
                    
                        
                }.padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .padding(16)
            }
            if(selectedBusiness == nil){
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Button(action: {
                                userTrackingMode = .follow
                                switch locationDataManager.locationManager.authorizationStatus {
                                case .authorizedWhenInUse:
                                    region.center = CLLocationCoordinate2D(
                                        latitude: locationDataManager.locationManager.location?.coordinate.latitude ?? 0.0,
                                        longitude: locationDataManager.locationManager.location?.coordinate.longitude ?? 0.0)
                                    region.span = MKCoordinateSpan(
                                        latitudeDelta: 0.01,
                                        longitudeDelta: 0.01)
                                    
                                case .restricted, .denied:
                                    print("Current location data was restricted or denied.")
                                case .notDetermined:
                                    print("Finding your location...")
                                default:
                                    break
                                }
                            }, label: {
                                Image(systemName: "location.circle")
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
                                print(region.span.latitudeDelta)
                            }, label: {
                                Image(systemName: "minus.magnifyingglass")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                            })
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                                .tint(Color(.secondaryLabel))
                        )
                        .padding(10)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}
