//
//  NSLayoutConstraint+constraintToMatchParent.swift
//  Task Movies
//
//  Created by Alexandra on 31.07.2024.
//

import UIKit

extension NSLayoutConstraint {

    static func constraintFrameToMatchParent(child: UIView?, parent: UIView?, leadingConstraint: CGFloat = 0, trailingConstraint: CGFloat = 0, topConstraint: CGFloat = 0, bottomConstraint: CGFloat = 0) {
        guard let child = child, let parent = parent else {
            return
        }
        NSLayoutConstraint.activate([
            child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: leadingConstraint),
            child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: trailingConstraint),
            child.topAnchor.constraint(equalTo: parent.topAnchor, constant: topConstraint),
            child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: bottomConstraint),
        ])
    }

    static func getConstraintsToParent(child: UIView?, parent: UIView?, leadingConstraint: CGFloat = 0, trailingConstraint: CGFloat = 0, topConstraint: CGFloat = 0, bottomConstraint: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let child = child, let parent = parent else {
            return []
        }
        return [
            child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: leadingConstraint),
            child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: trailingConstraint),
            child.topAnchor.constraint(equalTo: parent.topAnchor, constant: topConstraint),
            child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: bottomConstraint),
        ]
    }

    static func constraintCenterToMatchParent(child: UIView, parent: UIView) {
        NSLayoutConstraint.activate([
            child.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            child.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
        ])
    }

    static func constraintFrameToMatchParentSafeArea(child: UIView?, parent: UIView?) {
        guard let child = child, let parent = parent else {
            return
        }
        NSLayoutConstraint.activate([
            child.leadingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leadingAnchor),
            child.trailingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.trailingAnchor),
            child.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor),
            child.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
