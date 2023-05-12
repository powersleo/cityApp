//
//  WriteReviewView.swift
//  City
//
//  Created by Leo Powers on 5/12/23.
//

import SwiftUI

struct WriteReviewView: View {
    @Binding var isPresented: Bool
    @State private var rating: Int = 0
    @State private var reviewText: String = ""
    @State private var name: String = ""
    let onSave: (String,String, Int) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Rating:")
                            .font(.headline)
                        
                        Spacer()
                        
                        Stepper(value: $rating, in: 1...5) {
                            Text("\(rating)")
                        }
                    }
                    Text("Name")
                    TextEditor(text: $name)
                        .frame(height: 50)
                        .border(Color.gray, width: 1)
                    
                    Text("Write a Review:")
                        .font(.headline)
                    

                    TextEditor(text: $reviewText)
                        .frame(height: 150)
                        .border(Color.gray, width: 1)
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
