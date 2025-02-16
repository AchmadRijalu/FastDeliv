//
//  HomeViewModel.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 04/09/24.
//

import Foundation


protocol HomeViewModelProtocol: AnyObject {
    func onViewDidLoad()
    var delegate: HomeViewModelDelegate? {get set}
}


protocol HomeViewModelDelegate: AnyObject {
    func onSetupView()
}

class HomeViewModel: HomeViewModelProtocol {
    weak var delegate: HomeViewModelDelegate?
    
    func onViewDidLoad() {
        delegate?.onSetupView()
    }
    
    
}
