//
//  SearchViewmodel.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 18/04/25.
//

import Foundation

protocol SearchViewModelProtocol: AnyObject {
    var delegate: SearchViewModelDelegate? { get set }
    func onViewDidLoad()
    func getFilteredRestaurantList() -> [RestaurantListCellModel]
    func getFilteredCuisineList() -> [CuisineListCellModel]
    func onTextFieldValueDidChanged(text: String)
}

protocol SearchViewModelDelegate: AnyObject {
    func setupView()
    func reloadData()
}

class SearchViewModel: SearchViewModelProtocol {
    
    weak var delegate: SearchViewModelDelegate?
    
    private var restaurantList: [RestaurantListCellModel] {
        return RestaurantListFetcher.shared.convertRestaurantListToRestaurantListCell()
    }
    
    private var cuisineList: [CuisineListCellModel] {
        return RestaurantListFetcher.shared.convertCuisineList()
    }
    
    private var filteredRestaurantList: [RestaurantListCellModel] = []
    private var filterredCuisineList: [CuisineListCellModel] = []
    
    func getFilteredRestaurantList() -> [RestaurantListCellModel] {
        return filteredRestaurantList
    }
    
    func getFilteredCuisineList() -> [CuisineListCellModel] {
        return filterredCuisineList
    }
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
    
    func onTextFieldValueDidChanged(text: String) {
        if text.isEmpty {
            resetFilterList()
        } else {
            filterCuisineList(text: text)
            filterRestaurantList(text: text)
            delegate?.reloadData()
        }
    }
}

private extension SearchViewModel {
    func resetFilterList() {
        filterredCuisineList = []
        filteredRestaurantList = []
        delegate?.reloadData()
    }
    
    func filterRestaurantList(text: String) {
        
        let newFilteredRestaurantList = self.restaurantList.filter({$0.cuisinName.lowercased().contains(text.lowercased()) || $0.restaurantName.lowercased().contains(text.lowercased())})
        filteredRestaurantList = newFilteredRestaurantList
    }
    
    func filterCuisineList(text: String) {
        let newFilterCuisineList = self.cuisineList.filter({$0.cuisineName.lowercased().contains(text.lowercased())})
        filterredCuisineList = newFilterCuisineList
    }
}


