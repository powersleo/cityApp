//
//  ContentView.swift
//  City
//
//  Created by Leo Powers on 5/4/23.
//

import SwiftUI
import CoreData


func fetchPlaces() -> IdentifiablePlace{
    return IdentifiablePlace(lat:37.73161938479969, long:-122.48630473429115, name:"my house")
}
struct ContentView: View {
    var place: IdentifiablePlace

    init(){
        place = fetchPlaces()
    }
    var body: some View {
        NavigationView {
            ZStack{
                Image("Splash")
                Spacer()
                VStack{
                    HStack{
                        Spacer()

                        NavigationLink(
                            destination:UserView(),
                            label: {Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                                    .accentColor(Color.white)

                            })
                        NavigationLink (
                            destination:MapView(place: place),
                            label: {Image(systemName: "map")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                                    .accentColor(Color.white)

                            })
                        NavigationLink (
                            destination:ListView(), 
                            label: {Image(systemName: "list.star")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                                    .accentColor(Color.white)

                            })
                        NavigationLink (
                            destination:SettingsView(),
                            label: {Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                                    .accentColor(Color.white)

                            })
                        Spacer()

                        
                    }.background(Color.black)
                }
                Spacer()

                
            }
            
        }
    }
    
    
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
