//
//  WriteReviewView.swift
//  City
//
//  Created by Leo Powers on 5/12/23.
//

import SwiftUI

struct WriteReviewView: View {
    @Binding var isPresented: Bool
    @State private var rating: Double = 0
    @State private var crowd: Double = 0
    @State private var drinks: Double = 0
    @State private var security: Double = 0
    @State private var reviewText: String = ""
    @State private var name: String = ""
    @Environment(\.colorScheme) var colorScheme

    let onSave: (String, String, Double, Double, Double, Double) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                VStack{
                    Form {
                        Section {
//                            Text("Enter a Name").bold()
                            TextField("Name", text: $name)
                            
                            Text("Rating: \(Int(rating))").bold()
                            Slider(value: $rating, in: 1...5, step: 1)
                            
                            Text("Crowd: \(Int(crowd))").bold()
                            Slider(value: $crowd, in: 1...5, step: 1)
                             //face.smiling.inverse
                            
                            Text("Drinks: \(Int(drinks))").bold()
                            Slider(value: $drinks, in: 1...5, step: 1)
                                //wineglass.fill
                            
                            Text("Security: \(Int(security))").bold()
                            Slider(value: $security, in: 1...5, step: 1)
                            //dumbbell // dumbbell.fill
                            
                            Text("Write a Review:")
                            .font(.headline)
//                            TextEditor(text: $reviewText)
                        } 
                    }
                }
                .padding()
                
                Button(action: {
                    onSave(reviewText, name, rating, crowd, drinks, security)
                        isPresented = false
                }) {
                    Text("Save")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
                
                Spacer()
            }.accentColor(colorScheme == .dark ? .white : .black)

            .navigationBarTitle("Write a Review")
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }) {
                Text("Cancel")
            })
        }
    }
}
