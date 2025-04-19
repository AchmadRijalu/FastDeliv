//
//  RestaurantListFetcher.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 16/04/25.
//

import Foundation

class RestaurantListFetcher {
    
    static let shared = RestaurantListFetcher()
    
    var restaurantData: [RestaurantDataModel]?
    
    /// Fetch Restaurant List
    /// - Parameter completionBlock:
    func requestRestaurantList(completionBlock: @escaping ([RestaurantDataModel]?, Error?) -> Void) {
        
        //Creating the URL
        guard let url: URL = URL(string: "https://restaurant-api-f0974-default-rtdb.firebaseio.com/restaurants.json")
        else {
            completionBlock(nil, NSError(domain: "Invalid URL", code: -1))
            return
        }
        
        //Creating the URL Session
        let urlRequest: URLRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completionBlock(nil, error)
            }
            //Getting the data, if nil return it Completionblock with nil result
            guard let data = data else {
                completionBlock(nil, NSError(domain: "Invalid Data", code: -2))
                return
            }
            
            //Decode the JSON
            do {
                let decoder = JSONDecoder()
                let restaurants = try decoder.decode([RestaurantDataModel].self, from: data)
                self.restaurantData = restaurants
                completionBlock(restaurants, nil)
            }
            catch {
                completionBlock(nil, error)
            }
        }
        task.resume()
        
    }
    
    func convertRestaurantListToRestaurantListCell() -> [RestaurantListCellModel] {
        guard let restaurantData else {return []}
        //Create empty array first for append the data later
        var restaurants: [RestaurantListCellModel] = []
        for restaurant in restaurantData {
            let restaurantListCellModel: RestaurantListCellModel = RestaurantListCellModel(restaurantImageURL: restaurant.imageURL, restaurantName: restaurant.name, cuisinName: restaurant.cuisine)
            restaurants.append(restaurantListCellModel)
        }
        return restaurants
    }
    
    func convertCuisineList() ->[CuisineListCellModel] {
        guard let restaurantData else {return [] }
        var cuisines: [CuisineListCellModel] = []
        for restaurant in restaurantData {
            let cuisineModel: CuisineListCellModel = CuisineListCellModel(cuisineImageUrl: restaurant.cuisineImageURL, cuisineName: restaurant.cuisine)
           if  cuisines.filter({$0.cuisineName == restaurant.cuisine}).isEmpty {
               cuisines.append(cuisineModel)
            }
        }
        return cuisines
    }
}
