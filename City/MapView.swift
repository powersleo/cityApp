import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var locationDataManager = LocationDataManager()
    @Binding var userTrackingMode: MapUserTrackingMode
    @Binding var region: MKCoordinateRegion
    
    @State private var searchQuery: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State var selectedBusiness: Business?
    @State private var showResults: Bool = false
    
    
    var businesses: [Business]
    @State var showNav: Bool = true
    
    var body: some View {
        VStack{
            SearchBar(searchQuery: $searchQuery, searchResults: $searchResults, showResults: $showResults, selectedBusiness: $selectedBusiness, businesses: businesses)
            
        }.onTapGesture {
            self.showNav = false
            
        }.onSubmit {
            self.showNav = true
            
        }
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
                        self.showNav = false
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
                    Button(action:{self.selectedBusiness = nil
                        self.showNav = true}, label:{Text("Close")}  )
                    
                    
                }.padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .padding(16)
            }
            if(showNav){
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
                }}
        }
    }
}



struct SearchBar: View {
    @Binding var searchQuery: String
    @Binding var searchResults: [MKMapItem]
    @Binding var showResults: Bool
    @Binding var selectedBusiness: Business?
    var businesses: [Business]
    
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $searchQuery, onCommit: {
                    performSearch()
                    self.showResults = true
                    showAlert = searchResults.isEmpty 
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: clearSearch) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .opacity(searchQuery.isEmpty ? 0 : 1)
                }
            }
            
            if showResults {
                if searchResults.isEmpty {
                    Text("No results found")
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                } else {
                    List(searchResults, id: \.self) { result in
                        VStack(alignment: .leading) {
                            Text(result.name ?? "")
                                .font(.headline)
                            Text(result.placemark.title ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            if let selectedBusiness = businesses.first(where: { $0.name == result.name }) {
                                self.selectedBusiness = selectedBusiness
                                clearSearch()
                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("No Results"),
                message: Text("No results found for your search."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func performSearch() {
        let filteredBusinesses = businesses.filter { business in
            let businessName = business.name.lowercased()
            return businessName.contains(searchQuery.lowercased())
        }
        
        searchResults = filteredBusinesses.map { business in
            let coordinate = CLLocationCoordinate2D(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = business.name
            return mapItem
        }
    }
    
    private func clearSearch() {
        searchQuery = ""
        searchResults.removeAll()
        self.showResults = false
    }
}
