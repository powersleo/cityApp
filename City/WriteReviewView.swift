//
//  WriteReviewView.swift
//  City
//
//  Created by Leo Powers on 5/12/23.
//Modified and Edited by Maliah Chin 5/12/23

import SwiftUI

struct WriteReviewView: View {
    @Binding var isPresented: Bool
    @State private var rating: Double = 1
    @State private var crowd: Double = 1
    @State private var drinks: Double = 1
    @State private var security: Double = 1
    @State private var reviewText: String = ""
    @State private var name: String = ""
    @Environment(\.colorScheme) var colorScheme

    let onSave: (String, String, Double, Double, Double, Double) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                VStack{
                    Form {
                        Section(header: Text("Enter a Name").bold()) {
                            VStack {
                                TextField("Name", text: $name).disableAutocorrection(true)
                            }
                        }
                        
                        Section(header: Text("Rating: \(Int(rating))").bold()) {
                            VStack {
                                Slider(value: $rating, in: 1...5, step: 1)
                            }
                        }
                        
                        Section(header: Text("Crowd: \(Int(crowd))").bold()) {
                            VStack {
                                Slider(value: $crowd, in: 1...5, step: 1)
                            }
                        }
                        
                        Section(header: Text("Drinks: \(Int(drinks))").bold()) {
                            VStack {
                                Slider(value: $drinks, in: 1...5, step: 1)
                            }
                            
                            
                        }
                        
                        Section(header: Text("Security: \(Int(security))").bold()) {
                            VStack {
                                Slider(value: $security, in: 1...5, step: 1)
                            }
                        }
                        
                        Section(header: Text("Write a Review:").font(.headline)) {
                            VStack {
                                TextEditor(text: $reviewText)
                            }
                        }
                    }
                }
                .padding()
                
                Button(action: {
                    onSave(name, reviewText, rating, crowd, drinks, security)
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
