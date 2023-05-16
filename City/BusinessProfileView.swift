//
//  BusinessProfileView.swift
//  City
//
//  Created by Leo Powers on 5/12/23.
// K


import SwiftUI

struct BusinessProfileView: View {
    let business: Business
    @State private var isWritingReview = false
    @State private var newReview: String = ""
    @State private var reviews: [Review] = []
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("Reviews") var storedReviewsData: Data = Data()
    
    var body: some View
    {
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
                
                //                ForEach(1...5, id: \.self) { index in
                //                    Image(systemName: index <= Int(business.crowd) ? "face.smiling" : "face.smiling.inverse")
                //                        .foregroundColor(.yellow)
                //                        .font(.headline)
                //                }
                //
                //                ForEach(1...5, id: \.self) { index in
                //                    Image(systemName: index <= Int(business.drinks) ? "wineglass.fill" : "wineglass")
                //                        .foregroundColor(.yellow)
                //                        .font(.headline)
                //                }
                //
                //                ForEach(1...5, id: \.self) { index in
                //                    Image(systemName: index <= Int(business.security) ? "dumbbell.fill" : "dumbbell")
                //                        .foregroundColor(.yellow)
                //                        .font(.headline)
                //                }
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
                        ForEach(reviews.filter { $0.businessName == business.name }) { review in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(review.name)
                                            .bold()
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                        
                                        HStack(spacing: 4) {
                                            Text("Rating:")
                                            ForEach(1...5, id: \.self) { index in
                                                ZStack {
                                                    Image(systemName: index <= Int(review.rating) ? "star.fill" : "star")
                                                        .foregroundColor(.yellow)
                                                        .font(.subheadline)
                                                        .frame(width: 16, height: 16)
                                                    Image(systemName: index <= Int(review.rating) ? "star.fill" : "star")
                                                        .foregroundColor(.clear)
                                                        .font(.subheadline)
                                                        .frame(width: 16, height: 16)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(Color.yellow, lineWidth: 1)
                                                        )
                                                }
                                            }
                                        }
                                        
                                        HStack(spacing: 4) {
                                            Text("Crowd:")
                                            ForEach(1...5, id: \.self) { index in
                                                ZStack {
                                                    Image(systemName: index <= Int(review.crowd) ? "face.smiling.inverse" : "face.smiling")
                                                        .foregroundColor(.yellow)
                                                        .font(.subheadline)
                                                        .frame(width: 16, height: 16)
                                                    Image(systemName: index <= Int(review.crowd) ? "face.smiling.inverse" : "face.smiling")
                                                        .foregroundColor(.clear)
                                                        .font(.subheadline)
                                                        .frame(width: 16, height: 16)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(Color.yellow, lineWidth: 1)
                                                        )
                                                }
                                            }
                                        }
                                        
                                        HStack(spacing: 4) {
                                            Text("Drinks:")
                                            ForEach(1...5, id: \.self) { index in
                                                ZStack {
                                                    Image(systemName: index <= Int(review.drinks) ? "wineglass.fill" : "wineglass")
                                                        .foregroundColor(.yellow)
                                                        .font(.subheadline)
                                                        .frame(width: 16, height: 16)
                                                    Image(systemName: index <= Int(review.drinks) ? "wineglass.fill" : "wineglass")
                                                        .foregroundColor(.clear)
                                                        .font(.subheadline)
                                                        .frame(width: 16, height: 16)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(Color.yellow, lineWidth: 1)
                                                        )
                                                }
                                            }
                                        }
                                        
                                        HStack(spacing: 4) {
                                            Text("Security:")
                                            ForEach(1...5, id: \.self) { index in
                                                ZStack {
                                                    Image(systemName: index <= Int(review.security) ? "dumbbell.fill" : "dumbbell")
                                                        .foregroundColor(.yellow)
                                                        .font(.subheadline)
                                                        .frame(width: 16, height: 16)
                                                    Image(systemName: index <= Int(review.security) ? "dumbbell.fill" : "dumbbell")
                                                        .foregroundColor(.clear)
                                                        .font(.subheadline)
                                                        .frame(width: 16, height: 16)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(Color.yellow, lineWidth: 1)
                                                        )
                                                }
                                            }
                                        }
                                        Text("Review:")
                                            .bold()
                                        Text(review.text)
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    }
                                }
                                .padding(.bottom, 8)
                            }
                        }
                        
                        
                    }}
                
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
                WriteReviewView(isPresented: $isWritingReview) { name, review, rating, crowd, drinks, security in
                    saveReview(review: review, name: name, rating: rating, crowd: crowd, drinks: drinks, security: security)
                }
            }
        }
        .frame(width: 300, height: 600)
        .onAppear {
            loadReviews()
        }
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
    
    private func saveReview(review: String, name: String, rating: Double, crowd: Double, drinks: Double, security: Double) {
        let newReview = Review(text: review, name: name, rating: rating, crowd: crowd, drinks: drinks, security: security, businessName: business.name)
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


struct Review: Identifiable, Hashable, Codable {
    var id = UUID()
    let text: String
    let name: String
    let rating: Double
    let crowd: Double
    let drinks: Double
    let security: Double
    let businessName: String
}
