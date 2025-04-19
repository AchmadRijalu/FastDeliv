//
//  SearchViewmodel.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 18/04/25.
//

protocol SearchViewModelProtocol: AnyObject {
    func onViewDidLoad()
    var delegate : SearchViewModelDelegate? { get set }
    func getFilteredRestaurantList() -> [RestaurantListCellModel]
    func getFilteredCuisineList() -> [CuisineListCellModel]
    
}

protocol SearchViewModelDelegate: AnyObject {
    func setupView()
    func reloadData()
}

class SearchViewModel: SearchViewModelProtocol {
    weak var delegate: SearchViewModelDelegate?
    
    private var restaurantFilteredList: [RestaurantListCellModel] {
        return RestaurantListFetcher.shared.convertRestaurantListToRestaurantListCell()
    }
    private var cuisineFilteredList:[CuisineListCellModel] {
        return RestaurantListFetcher.shared.convertCuisineList()
    }
    
    private var filteredRestaurantList: [RestaurantListCellModel] = []
    private var filteredCuisineList: [CuisineListCellModel] = []
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
    
    func getFilteredRestaurantList() -> [RestaurantListCellModel] {
        return filteredRestaurantList
    }
    
    func getFilteredCuisineList() -> [CuisineListCellModel] {
        return filteredCuisineList
    }
    
    
}
