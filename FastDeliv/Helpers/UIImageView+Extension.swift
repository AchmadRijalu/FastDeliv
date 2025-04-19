//
//  UIImageView+Extension.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 24/02/25.
//

import UIKit
import Foundation

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {
        ImageCache.shared.countLimit = 100
        ImageCache.shared.totalCostLimit = 1024 * 1024 * 100 //Max 100 MB
    }
}

extension UIImageView {
    /// Load URL for UIImage View
    /// - Parameter url: url to be loaded
    func load(url: URL, placeHolder: UIImage? = nil) {
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}
