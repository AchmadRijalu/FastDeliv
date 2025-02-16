//
//  HomeTabBarViewModel.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 21/01/25.
//

import Foundation


protocol HomeTabBarViewModelProtocol: AnyObject {
    //Tabbar using will appear
    func onViewWillAppear()
    var delegate: HomeTabBarViewModelDelegate? { get set }
}

protocol HomeTabBarViewModelDelegate: AnyObject {
    func setupView()
}

class HomeTabBarViewModel: HomeTabBarViewModelProtocol {
    weak var delegate: HomeTabBarViewModelDelegate?

    func onViewWillAppear() {
        delegate?.setupView()
    }
    
    
}
