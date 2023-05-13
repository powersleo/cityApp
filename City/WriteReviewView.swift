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
    @State private var reviewText: String = ""
    @State private var name: String = ""

    let onSave: (String, String, Double) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                VStack{
                    Form {
                        Section {
                            Text("Enter a Name").bold()
                            TextField("Name", text: $name)
                            
                            Text("Rating: \(Int(rating))").bold()
                            Slider(value: $rating, in: 1...5, step: 1)
                            Text("Write a Review:")
                            .font(.headline)
                            TextEditor(text: $reviewText)
                        } 
                    }
                }
                .padding()
                
                Button(action: {
                    onSave(reviewText,name, rating)
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
            }
            .navigationBarTitle("Write a Review")
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }) {
                Text("Cancel")
            })
        }
    }
}
