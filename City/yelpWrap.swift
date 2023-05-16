//
//  yelpWrap.swift
//  City
//
//  Created by Leo Powers on 5/9/23.
//

import Foundation

struct Response: Codable {
    let businesses: [Business]
}

struct Business: Codable, Identifiable {
    let id: String
    let alias: String
    let name: String
    let imageUrl: String
    let isClosed: Bool
    let url: String
    let reviewCount: Int
    let categories: [Category]
    let rating: Double
    let coordinates: Coordinates
    let transactions: [String]
    let price: String?
    let location: Location
    let phone: String
    let displayPhone: String
    let distance: Double
}


struct Category: Codable {
    let alias: String
    let title: String
}

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}

struct Location: Codable {
    let address1: String
    let address2: String?
    let address3: String?
    let city: String
    let zipCode: String
    let country: String
    let state: String
    let displayAddress: [String]
}
func createURL(longitude: Double, latitude: Double) -> URL? {
    let baseURLString = "https://api.yelp.com/v3/businesses/search"
    
//    let locationQuery = "San Francisco"
//    let locationQueryItem = URLQueryItem(name: "location", value: locationQuery)
    
    let latitudeQueryItem = URLQueryItem(name: "latitude", value: String(latitude))
    let longitudeQueryItem = URLQueryItem(name: "longitude", value: String(longitude))
    let termQueryItem = URLQueryItem(name: "term", value: "nightclub")
    let categoriesQueryItem = URLQueryItem(name: "categories", value: "")
    let sortByQueryItem = URLQueryItem(name: "sort_by", value: "best_match")
    let limitQueryItem = URLQueryItem(name: "limit", value: "20")
    
    var urlComponents = URLComponents(string: baseURLString)
    urlComponents?.queryItems = [ latitudeQueryItem, longitudeQueryItem, termQueryItem, categoriesQueryItem, sortByQueryItem, limitQueryItem]
    
    guard let url = urlComponents?.url else {
        return nil
    }
    
    print(url.absoluteString)
    
    return url
}

class BusinessService{
    
    
   public static func processBusinesses(long:Double, lat:Double,completion: @escaping (Result<Response, Error>) -> Void) {
       guard let url = createURL(longitude: long, latitude: lat) else {
               return
        }
        
       let headers = ["accept": "application/json",   "Authorization": "Bearer B__g_3y_FExTRlmX7nCWDiGDdzrisdrhOuYO7ynIsDDR_G-zR98ZdEUlWH8wpTxPa74lS7x2_zJW59Q9b7znR-VGsGSkoDjviHxBkyKXpdcF7rXONxFbfbt8f9lhZHYx"]
       let request = NSMutableURLRequest(url: url,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
       request.httpMethod = "GET"
       request.allHTTPHeaderFields = headers

       let session = URLSession.shared

       let task = session.dataTask(with: request as URLRequest) { data, response, error in
           if let error = error {
               completion(.failure(error))
               print("ur dumb")
               return
           }

           guard let data = data else {
               let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
               completion(.failure(error))
               print("ur dumb")

               return
           }

           let jsonDecoder = JSONDecoder()
           jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

           do {
               let response = try jsonDecoder.decode(Response.self, from: data)
               completion(.success(response))
           } catch {
               completion(.failure(error))
               print("ur dumb")

           }
       }

       task.resume()
   }}
