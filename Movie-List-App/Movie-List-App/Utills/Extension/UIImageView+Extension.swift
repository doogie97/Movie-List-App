//
//  UIImageView+Extension.swift
//  Movie-List-App
//
//  Created by Doogie on 5/24/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(_ url: String) {
        if url == "N/A" {
            self.image = UIImage(systemName: "camera")
            self.tintColor = .xButtonBG
            self.contentMode = .scaleAspectFit
            return
        }
        self.kf.indicatorType = .activity
        self.kf.setImage(with: URL(string: url),
                         options: [.scaleFactor(UIScreen.main.scale),
                                   .cacheMemoryOnly,
                                   .transition(.fade(0.7))])
    }
}
