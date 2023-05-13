import SwiftUI
import MapKit

class ContentViewViewModel: ObservableObject {
    @Published var userTrackingMode: MapUserTrackingMode = .follow
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 0.0,
            longitude: 0.0),
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03)
    )
    @Published var businesses: [Business] = []
    @StateObject var locationDataManager = LocationDataManager()
    
    func fetchPlaces(long: Double, lat: Double, completion: @escaping ([Business]?, Error?) -> Void) {
        BusinessService.processBusinesses(long: long, lat: lat) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.businesses = response.businesses
                    self.updateMapRegion()
                    completion(response.businesses, nil)
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(nil, error)
            }
        }
    }
    
    private func updateMapRegion() {
        guard let firstBusiness = businesses.first else {
            return
        }
        
        region.center = CLLocationCoordinate2D(
            latitude: firstBusiness.coordinates.latitude,
            longitude: firstBusiness.coordinates.longitude
        )
        region.span = MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03
        )
    }
}

struct ContentView: View {
    @StateObject var viewModel = ContentViewViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: UserView()) {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(10)
                                .accentColor(Color.white)
                        }
                        
                      
                        NavigationLink(destination: MapView(userTrackingMode: $viewModel.userTrackingMode, region: $viewModel.region, businesses: viewModel.businesses)) {
                            Image(systemName: "map")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(10)
                                .accentColor(Color.white)
                        }
                        
                        NavigationLink(destination: ListView()) {
                            Image(systemName: "list.star")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(10)
                                .accentColor(Color.white)
                        }
                        
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(10)
                                .accentColor(Color.white)
                        }
                        
                        Spacer()
                    }
                    .background(Color.black)
                    .padding(10)
                }
            }
            .onAppear {
                viewModel.fetchPlaces(
                    long: viewModel.locationDataManager.locationManager.location?.coordinate.longitude ?? 0.0,
                    lat: viewModel.locationDataManager.locationManager.location?.coordinate.latitude ?? 0.0
                ) { businesses, error in
                    if let businesses = businesses {
                        viewModel.businesses = businesses
                    } else if let error = error {
                    }
                }
            }
        }
    }
}
