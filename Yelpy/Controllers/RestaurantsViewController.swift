//
//  ViewController.swift
//  Yelpy
//
//  Created by Memo on 5/21/20.
//  Copyright © 2020 memo. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {



    @IBOutlet weak var tableView: UITableView!

    var restaurantsArray: [Restaurant] = []

    //search bar
    var filteredData: [Restaurant]!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        getAPIData()
        filteredData = restaurantsArray

        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false

        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar

        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true

    }
    
    
    //Update API to get an array of restaurant objects
    func getAPIData() {
        API.getRestaurants() { (restaurants) in
            guard let restaurants = restaurants else {
                return
            }
            self.restaurantsArray = restaurants
            self.tableView.reloadData()
        }
    }
    
    // Protocol Stubs
    // How many cells there will be
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsArray.count
    }
    

    // Configure cell using MVC
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create Restaurant Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as! RestaurantCell
        
        let restaurant = restaurantsArray[indexPath.row]
        
        cell.r = restaurant
        
        return cell
    }

   func updateSearchResults(for searchController: UISearchController) {

   /*   if let searchText = searchController.searchBar.text {
          filteredData = searchText.isEmpty ? restaurantsArray : restaurantsArray.filter({(restaurant: Restaurant) -> Bool in
            return restaurant(searchText) != nil
          })

          tableView.reloadData()
      }*/

   }
    // Override segue to pass the restaurant object to the DetailsViewController
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let cell = sender as! UITableViewCell
      if let indexPath = tableView.indexPath(for: cell) {
         let r = restaurantsArray[indexPath.row]
         let detailViewController = segue.destination as! RestaurantDetailViewController
         detailViewController.r = r
      }
   }

    

}


