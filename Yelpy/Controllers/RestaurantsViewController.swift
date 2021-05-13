//
//  ViewController.swift
//  Yelpy
//
//  Created by Memo on 5/21/20.
//  Copyright © 2020 memo. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var restaurantsArray: [Restaurant] = []
    var filteredRestaurants: [Restaurant] = []

    //search bar
    var filteredData: [Restaurant]!
    var searchController: UISearchController!

    //infinite scrolling
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        getAPIData()

        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self

        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        search.searchBar.sizeToFit()
        navigationItem.searchController = search

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
            self.filteredRestaurants = restaurants
            self.tableView.reloadData()
        }
    }

    // How many cells there will be
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return filteredRestaurants.count
    }

    // Configure cell using MVC
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create Restaurant Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as! RestaurantCell

        let restaurant : Restaurant

        restaurant = filteredRestaurants[indexPath.row]

        cell.r = restaurant
        
        return cell
    }

    func updateSearchResults(for searchController: UISearchController) {
      let serchText = searchController.searchBar.text
      filterStores(for: serchText!)

   }

   func filterStores(for searchText:String) {
      if searchText.isEmpty{
         filteredRestaurants = restaurantsArray
      }else{
         filteredRestaurants = restaurantsArray.filter {
            restaurant in
            return
            restaurant.name.lowercased().contains(searchText.lowercased())
         }
      }

      tableView.reloadData()
   }

    // Override segue to pass the restaurant object to the DetailsViewController
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let cell = sender as! UITableViewCell
      if let indexPath = tableView.indexPath(for: cell) {
         let r = filteredRestaurants[indexPath.row]
         let detailViewController = segue.destination as! RestaurantDetailViewController
         detailViewController.r = r
      }
   }

   /*
   //infinite scrolling
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      if (!isMoreDataLoading){
         //calcuate the position of one screen length before the bottom of the results
         let scrollViewContentHwight = tableView.contentSize.height
         let scrollOffsetThreshold = scrollViewContentHwight - tableView.bounds.size.height

         //when the user has scrolled past the threshold, start requesting
         if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging){
            isMoreDataLoading = true
            
         }

         //load more data when users reaches near end
         loadMoreData()
      }
   }

   func loadMoreData() {

       getAPIData()

       // Update flag
       self.isMoreDataLoading = false
   }*/
}


