//
//  ViewController.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 03/09/24.
//

import UIKit


class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModelProtocol
    
    private lazy var setLocationButton: UIButton =  {
        let button: UIButton = UIButton(type: .roundedRect)
        button.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        button.setTitle("Set Location", for: .normal)
        button.tintColor = .systemOrange
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.borderedTinted()
            config.buttonSize = .medium
            config.cornerStyle = .capsule
            button.configuration = config
        } else {
            button.backgroundColor = .systemYellow
            button.layer.cornerRadius = 6.0
            button.layer.masksToBounds = true
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.systemOrange.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 8, right: 12)
        }
        
        //For auto layout
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField: UISearchTextField = UISearchTextField(frame: .zero)
        textField.placeholder = "Search.."
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CuisineCarouselListCell.self, forCellWithReuseIdentifier: "CuisineCarousel")
        collectionView.register(RestaurantListCell.self, forCellWithReuseIdentifier: "RestaurantListCell")
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        return collectionView
    }()
    
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension HomeViewController : HomeViewModelDelegate {
    
    func onSetupView() {
        view.backgroundColor = .white
        title = "Home"
        view.addSubview(setLocationButton)
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            //Location Button
            setLocationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            setLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            setLocationButton.trailingAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: view.trailingAnchor, multiplier: -16),
            searchTextField.topAnchor.constraint(equalTo: setLocationButton.bottomAnchor, constant: 16.0),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if viewModel.getCuisineList().isEmpty && viewModel.getRestaurantList().isEmpty {
            return 0
        }
        if viewModel.getCuisineList().isEmpty || viewModel.getRestaurantList().isEmpty {
            return 1
        }
        return 2
        //Section 1 cuisine carousel
        //Section 2 restaurant list
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //get number of item
        if section == 0 {
            let numberSection = !viewModel.getCuisineList().isEmpty ? 1 : 0
            return numberSection
        }
        else {
            return viewModel.getRestaurantList().count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuisineCarousel", for: indexPath) as? CuisineCarouselListCell else {
                return UICollectionViewCell()
            }
            cell.setupDataModel(cuisineListCellModel: viewModel.getCuisineList())
            return cell
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantListCell", for: indexPath) as? RestaurantListCell else {
                return UICollectionViewCell()
            }
            //            let mockModel: RestaurantListCellModel = RestaurantListCellModel(restaurantImageURL: "", restaurantName: "Solaria", cuisinName: "Indonesian")
            
            cell.setupData(cellModel: viewModel.getRestaurantList()[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: CuisineCarouselListCell.getHeight())
        }
        else {
            return CGSize(width: UIScreen.main.bounds.width - 32, height: RestaurantListCell.getHeightCell())
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
                as?  HomeHeaderView else {return UICollectionReusableView()}
        
        if indexPath.section == 0 {
            if viewModel.getCuisineList().isEmpty && !viewModel.getRestaurantList().isEmpty {
                //Show restaurants section
                view.setupTitle(title: "Restaurants")
            }
            else {
                view.setupTitle(title: "Cuisines")
            }
        }
        else {
            view.setupTitle(title: "Restaurants")
        }
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height:  HomeHeaderView.getHeight())
    }
    
    
}
