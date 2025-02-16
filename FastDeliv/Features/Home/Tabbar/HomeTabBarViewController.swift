//
//  HomeTabBarViewController.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 07/09/24.
//

import UIKit

class HomeTabBarViewController: UITabBarController {

    
    let viewModel: HomeTabBarViewModelProtocol
    
    init(viewModel: HomeTabBarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.onViewWillAppear()
    }
    


}

extension HomeTabBarViewController: HomeTabBarViewModelDelegate {
    func setupView() {
        //set ui tabbar item
        let homeTabBar: UITabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        let searchTabBar: UITabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        let cartTabBar: UITabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), tag: 2)
        
        //set the view controller
        let homeViewModel: HomeViewModel = HomeViewModel()
        let homeViewController: HomeViewController = HomeViewController(viewModel: homeViewModel)
        //set the view controller to the tabbar
        homeViewController.tabBarItem = homeTabBar
        
        let searchViewController: SearchViewController = SearchViewController(nibName: nil, bundle: nil)
        searchViewController.tabBarItem = searchTabBar
        
        let cartViewController: CartViewController = CartViewController(nibName: nil, bundle: nil)
        cartViewController.tabBarItem = cartTabBar
        
        viewControllers = [homeViewController, searchViewController, cartViewController]
        tabBar.tintColor = UIColor(rgb: 0x872341)
        tabBar.isTranslucent = false
        navigationItem.title = homeViewController.tabBarItem.title
        delegate = self
    }
    
}

extension HomeTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else { return false }
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve])
            navigationItem.title = viewController.tabBarItem.title
        }
        return true
    }
}
