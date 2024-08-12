//
//  UIView+UseAutoLayout.swift
//  Task Movies
//
//  Created by Alexandra on 31.07.2024.
//

import UIKit

@propertyWrapper
public struct UseAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            setAutoLayout()
        }
    }
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        setAutoLayout()
    }
    func setAutoLayout() {
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIView {

    func useAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
