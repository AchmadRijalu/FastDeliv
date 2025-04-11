//
//  HomeHeaderView.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 17/03/25.
//

import UIKit

class HomeHeaderView: UICollectionReusableView {
    private lazy var titlelabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupTitle(title: String) {
        self.titlelabel.text = title 
    }
    
    static func getHeight() -> CGFloat {
        return 64.0
    }
}

private extension HomeHeaderView {
    private func setupview() {
        addSubview(titlelabel)
        NSLayoutConstraint.activate([
            titlelabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            titlelabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            titlelabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            titlelabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        backgroundColor = .white
    }
}
