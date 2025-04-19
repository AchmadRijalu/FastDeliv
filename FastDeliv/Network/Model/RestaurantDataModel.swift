//
//  RestaurantDataModel.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 16/04/25.
//

struct RestaurantDataModel: Decodable {
    let name: String
    let cuisine: String
    let cuisineImageURL: String
    let imageURL: String
    let menus: [MenuData]
    let location: Location
    
}

struct Location: Decodable {
    let city: String
    let lat: Float
    let long: Float
}

struct MenuData: Decodable {
    let description: String
    let imageURL: String
    let name: String
    let price: Float
}
