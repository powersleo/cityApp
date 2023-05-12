import SwiftUI
import CoreData
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
    @Published var place: [IdentifiablePlace] = []
    @StateObject var locationDataManager = LocationDataManager()
    
    func fetchPlaces(long: Double, lat: Double) {
        BusinessService.processBusinesses(long: long, lat: lat) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.businesses = response.businesses
                    self.place = self.fetchPlaces(from: response.businesses)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func fetchPlaces(from businesses: [Business]) -> [IdentifiablePlace] {
        var identifiablePlaces: [IdentifiablePlace] = []
        
        for business in businesses {
            let place = IdentifiablePlace(
                id: UUID(),
                lat: business.coordinates.latitude,
                long: business.coordinates.longitude,
                name: business.name
            )
            
            identifiablePlaces.append(place)
        }
        
        return identifiablePlaces
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
                        
                        NavigationLink(destination: MapView(userTrackingMode: $viewModel.userTrackingMode, region: $viewModel.region, place: viewModel.place)) {
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
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchPlaces(
                long: viewModel.locationDataManager.locationManager.location?.coordinate.longitude ?? 0.0,
                lat: viewModel.locationDataManager.locationManager.location?.coordinate.latitude ?? 0.0
            )
        }
    }
}
