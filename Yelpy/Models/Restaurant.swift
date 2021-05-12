//
//  Restaurant.swift
//  Yelpy
//
//  Created by Ellen Yang on 5/11/21.
//  Copyright © 2021 memo. All rights reserved.
//

import Foundation

class Restaurant{

   //properties
   var imagURL: URL?
   var url: URL?
   var name: String
   var mainCategory: String
   var phone: String
   var rating: Double
   var reviews: Int

   //initializer
   init(dict: [String: Any]){
      imagURL = URL(string: dict["image_url"] as! String)
      name = dict["name"] as! String
      rating = dict["rating"] as! Double
      reviews = dict["review_count"] as! Int
      phone = dict["display_phone"] as! String
      url = URL(string: dict["url"] as! String)
      mainCategory = Restaurant.getMainCategory(dict: dict)
   }

   //helper function to get first category from restaurant
   static func getMainCategory(dict: [String:Any]) -> String{
      let categories = dict["categories"] as! [[String: Any]]
         return categories[0]["title"] as! String
   }

}
