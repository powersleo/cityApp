//
//  UserView.swift
//  City
//
//  Created by Leo Powers on 5/4/23.
//  Modified and Edited by Maliah Chin 5/12/23
//

import SwiftUI


struct UserView: View {
    var body: some View {
        NavigationView{
            ZStack{
                VStack {
                    Image("Avatar")
                        .resizable()
                        .frame(width:150, height: 150)
                        .clipShape(Circle())
                        .offset()
                    
                    Text("Username").font(.title)
                    List {
                        Text("Email")
                        Text("Phone Number")
                        Text("Password")
                    
                }
                    .navigationTitle("User Info Page")
                    
                }
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}

