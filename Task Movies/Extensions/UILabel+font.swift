//
//  UILabel+font.swift
//  Task Movies
//
//  Created by Alexandra on 31.07.2024.
//

import UIKit

extension UILabel {

    convenience init(withSystemFontOfSize fontSize: CGFloat) {
        self.init()
        font = UIFont.systemFont(ofSize: fontSize)
    }

    convenience init(withBoldFontOfSize fontSize: CGFloat) {
        self.init()
        font = UIFont.boldSystemFont(ofSize: fontSize)
    }
}
