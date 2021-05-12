//
//  File.swift
//  Yelpy
//
//  Created by Memo on 5/21/20.
//  Copyright © 2020 memo. All rights reserved.
//

import Foundation


struct API {
    
    static func getRestaurants(completion: @escaping ([Restaurant]?) -> Void) {
        
        let apikey = "NSLZgskozvlZCcmyIOZwwGsGCzSiAnmu8FgtGyvJZnFgwHbdb9UcGkcFeNGPslCgHmVEIgizSZ3aMmh0661WMQHp6HbEdqBG31oR4Hs_F3lNnqET8g3Lo-1QvJ6NYHYx"
        
        // Coordinates for San Francisco
        let lat = 37.773972
        let long = -122.431297
        
        
        let url = URL(string: "https://api.yelp.com/v3/transactions/delivery/search?latitude=\(lat)&longitude=\(long)")!
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // Insert API Key to request
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                
               let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

               // Get array of restaurant dictionaries
               let restDictionaries = dataDictionary["businesses"] as! [[String: Any]]

               // Variable to store array of Restaurants
               var restaurants: [Restaurant] = []

               // Use each restaurant dictionary to initialize Restaurant object
               for dictionary in restDictionaries {
                  let restaurant = Restaurant.init(dict: dictionary)
                  restaurants.append(restaurant) // add to restaurants array
               }

               return completion(restaurants)
                
                
                }
            }
        
            task.resume()
        
        }
    }

    
