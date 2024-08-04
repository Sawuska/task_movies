//
//  PosterView.swift
//  Task Movies
//
//  Created by Alexandra on 04.08.2024.
//

import UIKit
import Kingfisher

final class PosterView: UIView {

    private static let closeButtonOffset: CGFloat = 20

    let scrollView: UIScrollView = {
        @UseAutoLayout var view = UIScrollView()
        view.minimumZoomScale = 1
        view.maximumZoomScale = 5
        return view
    }()

    let poster: UIImageView = {
        @UseAutoLayout var view = UIImageView()
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        return view
    }()

    let closeButton: UIButton = {
        @UseAutoLayout var button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(scrollView)
        scrollView.addSubview(poster)
        addSubview(closeButton)
        backgroundColor = .black
        useAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.constraintFrameToMatchParent(child: self, parent: superview)
        NSLayoutConstraint.constraintFrameToMatchParent(child: scrollView, parent: self)

        NSLayoutConstraint.activate([
            poster.widthAnchor.constraint(equalTo: widthAnchor),
            poster.topAnchor.constraint(equalTo: scrollView.topAnchor),
            poster.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -PosterView.closeButtonOffset),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: PosterView.closeButtonOffset),
        ])
    }

    func setPoster(url: URL?) {
        poster.kf.setImage(
            with: url,
            placeholder: UIColor.lightGray,
            options: [.transition(.fade(0.2))]
        )
    }
}
