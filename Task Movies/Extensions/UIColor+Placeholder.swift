//
//  UIColor+Placeholder.swift
//  Task Movies
//
//  Created by Alexandra on 31.07.2024.
//

import UIKit
import Kingfisher

extension UIColor: Placeholder {

    public func add(to imageView: Kingfisher.KFCrossPlatformImageView) {
        imageView.backgroundColor = self
    }

    public func remove(from imageView: Kingfisher.KFCrossPlatformImageView) {
        imageView.backgroundColor = .clear
    }

}
