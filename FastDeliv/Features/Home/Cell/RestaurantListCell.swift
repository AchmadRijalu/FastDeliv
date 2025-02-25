//
//  Untitled.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 13/02/25.
//

import UIKit

class RestaurantListCell: UICollectionViewCell {
    
    private lazy var restaurantImageView: UIImageView =  {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var restaurantNameLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cuisineLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupData(cellModel: RestaurantListCellModel) {
        //1. Buat function untuk load data dari url menjadi UIImage
        //2. Set UIImage hasil load ke ke restaurantImageView
        if let imageURLString = cellModel.restaurantImageURL , let url: URL = URL(string: imageURLString) {
            restaurantImageView.load(url: url)
        }
        restaurantNameLabel.text = cellModel.cuisinName
        cuisineLabel.text = cellModel.cuisinName
        
    }
    
    static func getHeightCell() -> CGFloat {
        return 290
    }
}

private extension RestaurantListCell {
    func setupView() {
        contentView.addSubview(restaurantImageView)
        contentView.addSubview(restaurantNameLabel)
        contentView.addSubview(cuisineLabel)
        
        NSLayoutConstraint.activate([
            restaurantImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            restaurantImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            restaurantImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 200),
            
            restaurantNameLabel.topAnchor.constraint(equalTo: restaurantImageView.bottomAnchor, constant: 16),
            restaurantNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            restaurantNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            cuisineLabel.topAnchor.constraint(equalTo: restaurantNameLabel.bottomAnchor, constant: 16),
            cuisineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cuisineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cuisineLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 6.0
    }
}
