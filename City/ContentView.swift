import SwiftUI
import MapKit

class ContentViewModel: ObservableObject {
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
    @Published var recentlyViewedPages: [Business] = []
    
    func fetchPlaces(long: Double, lat: Double, completion: @escaping ([Business]?, Error?) -> Void) {
        self.updateMapRegion()
        
        BusinessService.processBusinesses(long: long, lat: lat) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.businesses = response.businesses
                    completion(response.businesses, nil)
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(nil, error)
            }
        }
    }
    
    private func updateMapRegion() {
        
        if let location = locationDataManager.locationManager.location {
            region.center = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        } else {
            region.center = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
        
        region.span = MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03
        )
    }
}

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    @State var locationDataManager = LocationDataManager()

    
    //handle appearence of navigation
    @State private var showRecentlyViewedLocations:Bool = false
    @State private var showResults: Bool = false
    @State private var showNav:Bool = true
    @State private var showSearchBar:Bool = false
    @State private var businessLoaded:Bool = false
    @State private var showBusiness:Bool = false
    
    //related to search functions
    @State private var searchQuery: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State var selectedBusiness: Business? = nil
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack{
                    if(showSearchBar){
                        SearchBar(searchQuery: $searchQuery, searchResults: $searchResults, showResults: $showResults, selectedBusiness: $selectedBusiness, businesses: $viewModel.businesses, recentlyViewedPages:$viewModel.recentlyViewedPages)
                    }
                    if(businessLoaded){
                        MapView(locationDataManager:$locationDataManager,userTrackingMode:$viewModel.userTrackingMode, region: $viewModel.region,selectedBusiness: $selectedBusiness, recentlyViewedPages:$viewModel.recentlyViewedPages,businesses: viewModel.businesses)
                    }else{
                        Text("Loading...")
                    }
                    
                }
                if(showRecentlyViewedLocations){
                    ZStack{
                        NavigationView{
                            List {
                                Section(header: Text("Recently Viewed Locations").foregroundColor(colorScheme == .dark ? Color.white : Color.black)) {
                                    
                                    if(!viewModel.recentlyViewedPages.isEmpty){
                                        ForEach(viewModel.recentlyViewedPages) { business in
                                            Button(action:{
                                                selectedBusiness = business
                                                showBusiness = true
                                                showSearchBar = true
                                                showNav = true
                                                showRecentlyViewedLocations = false

                                                
                                            }, label:{Text(business.name).foregroundColor(colorScheme == .dark ? Color.white : Color.black) })
                                                   }
                                    }else {
                                        Text("No locations viewed").foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    }
                                    
                                }.headerProminence(.increased)}
                        }.foregroundColor(colorScheme == .dark ? Color.black : Color.white) .navigationBarTitleDisplayMode(.inline)
                            .navigationBarHidden(!showRecentlyViewedLocations).toolbar(content: {
                                ToolbarItem(placement: .navigationBarLeading){
                                    Button(action:{
                                        showRecentlyViewedLocations = false
                                        showNav = true
                                        showSearchBar = true
                                        
                                        
                                    }, label:{Text("Close")}  )
                                    
                                    
                                }
                            })
                        if let selectedBusiness = selectedBusiness {
                            VStack{
                                BusinessProfileView(business: selectedBusiness)
                                Button(action:{self.selectedBusiness = nil
                                    showNav = true
                                    showSearchBar = true
                                }, label:{Text("Close")}  )
                            
                                
                            }.padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 4)
                                .padding(16)
                        }
                        
                    }
                    
                }
                if(showNav){
                    VStack {
                        Spacer()
                        
                        HStack {
                            
                            NavigationLink(destination: UserView()) {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                            }
                            
                            
                            Button(action: {
                                showRecentlyViewedLocations = true;
                                showNav = false
                                showSearchBar = false
                                showBusiness = false
                                self.selectedBusiness = nil
                            }) {
                                Image(systemName: "list.star")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                            }
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                            }
                            
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                                .tint(Color(.secondaryLabel))
                        )                }
                }
            }
            
        }.onAppear {
            viewModel.fetchPlaces(
                long: viewModel.locationDataManager.locationManager.location?.coordinate.longitude ?? 0.0,
                lat: viewModel.locationDataManager.locationManager.location?.coordinate.latitude ?? 0.0
            ) { businesses, error in
                if let businesses = businesses {
                    viewModel.businesses = businesses
                    businessLoaded = true
                    showSearchBar = true
                    
                } else if let error = error {
                    print(error)
                }
            }
        }
    }
}


struct SearchBar: View {
    @Binding var searchQuery: String
    @Binding var searchResults: [MKMapItem]
    @Binding var showResults: Bool
    @Binding var selectedBusiness: Business?
    @Binding var businesses: [Business]
    @Binding var recentlyViewedPages: [Business]
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                TextField("Search", text: $searchQuery, onCommit: {
                    performSearch()
                    self.showResults = true
                    showAlert = searchResults.isEmpty
                })
                .textFieldStyle(.roundedBorder)
                
                Button(action: clearSearch) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
//                        .opacity(searchQuery.isEmpty ? 0 : 1)
                }
                Spacer()
            }
            
            if showResults {
                if searchResults.isEmpty {
                    Text("No results found")
                        .foregroundColor(.gray)
                        .padding(.top, 8).onAppear{
                            clearSearch()
                        }
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
                                checkAndAppendBusiness(selectedBusiness)
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
    func checkAndAppendBusiness(_ selectedBusiness: Business) {
        if !recentlyViewedPages.contains(where: { $0.id == selectedBusiness.id }) {
            recentlyViewedPages.append(selectedBusiness)
        }
    }
    
    private func clearSearch() {
        searchQuery = ""
        searchResults.removeAll()
        self.showResults = false
    }
    
    
    
}

