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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
            restaurantImageView.heightAnchor.constraint(equalToConstant: 200)
            
            
        ])
    }
}
