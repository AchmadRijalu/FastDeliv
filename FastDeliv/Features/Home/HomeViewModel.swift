//
//  HomeViewModel.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 04/09/24.
//

import Foundation


protocol HomeViewModelProtocol: AnyObject {
    var delegate: HomeViewModelDelegate? {get set}
    func onViewDidLoad()
    func getRestaurantList() -> [RestaurantListCellModel]
    func getCuisineList() -> [CuisineListCellModel]
}


protocol HomeViewModelDelegate: AnyObject {
    func onSetupView()
    func reloadData()
}

class HomeViewModel: HomeViewModelProtocol {
    weak var delegate: HomeViewModelDelegate?
    
    private var restaurantCellListModel: [RestaurantListCellModel] = []
    private var cuisineListCellModel: [CuisineListCellModel] = []
    
    func onViewDidLoad() {
        delegate?.onSetupView()
        fetchRestaurant()
    }
    
    func getRestaurantList() -> [RestaurantListCellModel] {
        return restaurantCellListModel
    }
    
    func getCuisineList() -> [CuisineListCellModel] {
        return cuisineListCellModel
    }
}

private extension HomeViewModel {
    func fetchRestaurant() {
        RestaurantListFetcher.shared.requestRestaurantList { [weak self] restaurants, error in
            guard let self else { return}
            if let restaurants, !restaurants.isEmpty {
                self.restaurantCellListModel = RestaurantListFetcher.shared.convertRestaurantListToRestaurantListCell()
                self.cuisineListCellModel = RestaurantListFetcher.shared.convertCuisineList()
                self.delegate?.reloadData()
            }
            else if let error {
                //Handle Error Here
            }
        }
    }
}
