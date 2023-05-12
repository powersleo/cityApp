//
//  BusinessProfileView.swift
//  City
//
//  Created by Leo Powers on 5/12/23.
//

import SwiftUI

struct BusinessProfileView: View {
    let business: Business
    @State private var isWritingReview = false
    @State private var newReview: String = ""
    @State private var reviews: [Review] = []
    
    var body: some View {
        let distanceInMiles = Measurement(value: business.distance, unit: UnitLength.meters).converted(to: UnitLength.miles)
        
        VStack {
            AsyncImage(url: URL(string: business.imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                @unknown default:
                    EmptyView()
                }
            }
            Text("Distance: \(String(format: "%.2f", distanceInMiles.value)) miles").font(.caption)
            Text(business.name)
                .font(.title)
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= Int(business.rating) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.headline)
                }
            }
            Text("Reviews:")
                .font(.headline)
                .padding(.top)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(reviews, id: \.self) { review in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(review.name)
                            HStack {
                                ForEach(1...5, id: \.self) { index in
                                    Image(systemName: index <= review.rating ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.subheadline)
                                }
                            }
                            Text(review.text)
                        } .border(.green)
                        .padding(.bottom, 8)
                    }
                }
                Button(action: {
                    isWritingReview = true
                }) {
                    Text("Write a Review")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
                
                Spacer()
            }
            .navigationBarTitle(business.name)
            .sheet(isPresented: $isWritingReview) {
                WriteReviewView(isPresented: $isWritingReview) { review,name, rating in
                    saveReview(review: review, name:name, rating: rating)
                }
            }
        }
    }
    
    private func saveReview(review: String, name:String, rating: Int) {
        let newReview = Review(text: review, name:name, rating: rating)
        reviews.append(newReview)
    }
}

struct Review: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let name:String
    let rating: Int
}


