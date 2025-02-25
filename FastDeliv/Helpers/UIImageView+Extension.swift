//
//  UIImageView+Extension.swift
//  FastDeliv
//
//  Created by Achmad Rijalu on 24/02/25.
//

import UIKit
import Foundation

extension UIImageView {
    
    /// Load URL for UIImage View
    /// - Parameter url: url to be loaded
    func load(url: URL) {
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
