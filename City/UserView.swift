//
//  UserView.swift
//  City
//
//  Created by Leo Powers on 5/4/23.
//  Modified and Edited by Maliah Chin 5/12/23
//

import SwiftUI

struct UserView: View {
    @Binding var favorites: [Business]
    @Environment(\.colorScheme) var colorScheme
    @State var selectedBusiness: Business? = nil
    @State private var showBusiness = false
    var body: some View {
        ZStack{
            
            NavigationView {
                VStack {
                    Image("Avatar")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding()
                    
                    Text("Username")
                        .font(.title)
                        .padding(.bottom)
                    
                    List {
                        Section(header: Text("Account")) {
                            Text("Email")
                            Text("Phone Number")
                            Text("Password")
                        }
                        
                        Section(header: Text("Favorites")) {
                            if favorites.isEmpty {
                                Text("No favorites :(")
                            } else {
                                ForEach(favorites) { business in
                                    Button(action: {
                                        selectedBusiness = business
                                        showBusiness = true
                                    }) {
                                        Text(business.name)
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    }
                                }
                            }
                        }
                    }
                }
                
                
                
            }.navigationTitle("User Info Page")
            if(showBusiness){
                if let selectedBusiness = selectedBusiness{
                    VStack{
                        BusinessProfileView(business: selectedBusiness, favorites:$favorites)
                        Button(action:{self.selectedBusiness = nil
                        }, label:{Text("Close")}  )
                        
                        
                        
                        
                    }.padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .padding(16)
                }
            }
            
        }
    }
}

