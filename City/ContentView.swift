//
//  ContentView.swift
//  City
//
//  Created by Leo Powers on 5/4/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                
                HStack{
                    NavigationLink(
                        destination:UserView(),
                        label: {Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(10)
                        })
                    NavigationLink (
                        destination:MapView(),
                        label: {Image(systemName: "map")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(10)
                        })
                    NavigationLink (
                        destination:ListView(),
                        label: {Image(systemName: "list.star")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(10)
                        })
                    NavigationLink (
                        destination:ListView(),
                        label: {Image(systemName: "speaker.wave.1")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(10)
                        })


                }
                
            }
            
        }
    }
    
    
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
