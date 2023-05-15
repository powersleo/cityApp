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
    @Environment(\.colorScheme) var colorScheme

    @AppStorage("Reviews") var storedReviewsData: Data = Data()
    
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
                    if reviews.isEmpty {
                        Text("No reviews yet :(")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(reviews, id: \.self) { review in
                            if review.businessName == business.name {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(review.name).bold().foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                        ForEach(1...5, id: \.self) { index in
                                            Image(systemName: index <= Int(review.rating) ? "star.fill" : "star")
                                                .foregroundColor(.yellow)
                                                .font(.subheadline)
                                        }
                                    }
                                    Text(review.text).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                }
                                .padding(.bottom, 8)
                            }
                        }
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
            .sheet(isPresented: $isWritingReview) {
                WriteReviewView(isPresented: $isWritingReview) {review, name, rating in
                    saveReview(review: review, name:name, rating: rating)
                }
            }
        }.frame(width:300,height: 600).onAppear{
            loadReviews()
        }.background(colorScheme == .dark ? Color.black : Color.white)

        
    }
    
    private func saveReview(review: String, name:String, rating: Double) {
        let newReview = Review(text: review, name:name, rating: rating, businessName: business.name)
        reviews.append(newReview)
        saveReviews()
    }
    private func saveReviews() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(reviews)
            
            storedReviewsData = data
        } catch {
            print("Failed to encode reviews: \(error)")
        }
    }
    
    private func loadReviews() {
        do {
            let decoder = JSONDecoder()
            let reviewsData = storedReviewsData
            
            let decodedReviews = try decoder.decode([Review].self, from: reviewsData)
            
            reviews = decodedReviews
        } catch {
            print("Failed to decode reviews: \(error)")
        }
    }
}

struct Review: Identifiable, Hashable,Codable
{
    var id = UUID()
    let text: String
    let name:String
    let rating: Double
    let businessName: String
}
