//
//  CuisineCarouselListCell.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 03/03/25.
//

import UIKit

class CuisineCarouselListCell: UICollectionViewCell {
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 32.0
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CuisineListCell.self, forCellWithReuseIdentifier: "cuisine_list")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func getHeight() -> CGFloat {
        return 128.0
    }
    
}

private extension CuisineCarouselListCell {
    func setupView() {
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension CuisineCarouselListCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cuisine_list", for: indexPath) as? CuisineListCell else {
           return UICollectionViewCell()
        }
        let mockData: CuisineListCellModel = CuisineListCellModel(cuisineImageUrl: "", cuisineName: "Indonesian indonesian ")
        cell.setupCellData(cellModel: mockData)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 112)
    }
    
}

class CuisineListCell: UICollectionViewCell {
    private lazy var cuisineImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.layer.cornerRadius = 32.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var cuisineLabel: UILabel = {
        let uiLabel: UILabel = UILabel(frame: .zero)
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        uiLabel.adjustsFontSizeToFitWidth = true
        uiLabel.minimumScaleFactor = 0.5
        uiLabel.numberOfLines = 0
        return uiLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupCellData(cellModel: CuisineListCellModel) {
        if let cuisineImageUrl = cellModel.cuisineImageUrl, let imageURL: URL = URL(string: cuisineImageUrl) {
            cuisineImageView.load(url: imageURL)
        }
        cuisineLabel.text = cellModel.cuisineName
    }
}

private extension CuisineListCell {
    func setupView() {
        contentView.addSubview(cuisineLabel)
        contentView.addSubview(cuisineImageView)
        NSLayoutConstraint.activate([
            cuisineImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cuisineImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            cuisineLabel.topAnchor.constraint(equalTo: cuisineImageView.bottomAnchor, constant: 8),
            cuisineLabel.centerXAnchor.constraint(equalTo: cuisineImageView.centerXAnchor),
            cuisineLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
