//
//  MovieDetailsView.swift
//  Task Movies
//
//  Created by Alexandra on 03.08.2024.
//

import UIKit
import Kingfisher

final class MovieDetailsView: UIView {

    private static let horizontalInset: CGFloat = 20
    private static let verticalInset: CGFloat = 15
    private static let primaryFontSize: CGFloat = 24
    private static let secondaryFontSize: CGFloat = 18
    private static let trailerButtonSide: CGFloat = 40
    private static let heightToWidth: CGFloat = 0.7

    private let title: UILabel = {
        @UseAutoLayout var label = UILabel(withBoldFontOfSize: primaryFontSize)
        label.numberOfLines = 3
        return label
    }()

    private let countryAndYear: UILabel = {
        @UseAutoLayout var label = UILabel(withSystemFontOfSize: secondaryFontSize)
        label.numberOfLines = 3
        return label
    }()

    private let genres: UILabel = {
        @UseAutoLayout var label = UILabel(withSystemFontOfSize: secondaryFontSize)
        label.numberOfLines = 3
        return label
    }()

    private let rating: UILabel = {
        @UseAutoLayout var label = UILabel(withBoldFontOfSize: secondaryFontSize)
        label.textAlignment = .right
        return label
    }()

    let trailerButton: UIButton = {
        @UseAutoLayout var button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.image = UIImage(systemName: "play.rectangle.fill")
        configuration.baseForegroundColor = .systemBackground
        configuration.baseBackgroundColor = .label
        button.configuration = configuration
        button.isHidden = true
        return button
    }()

    let poster: UIImageView = {
        @UseAutoLayout var view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.kf.indicatorType = .activity
        return view
    }()

    private let overview: UITextView = {
        @UseAutoLayout var view = UITextView()
        view.font = UIFont.systemFont(ofSize: secondaryFontSize)
        view.isEditable = false
        view.isScrollEnabled = false
        view.textAlignment = .natural
        return view
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [trailerButton, rating])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.useAutoLayout()
        return stackView
    }()

    private let scrollView: UIScrollView = {
        @UseAutoLayout var view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        [poster, title, countryAndYear, genres, horizontalStackView, overview].forEach(scrollView.addSubview)
        backgroundColor = .systemBackground
        useAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.constraintFrameToMatchParent(child: self, parent: superview)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            poster.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            poster.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            poster.topAnchor.constraint(equalTo: scrollView.topAnchor),
            poster.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: MovieDetailsView.heightToWidth),

            title.leadingAnchor.constraint(equalTo: poster.leadingAnchor, constant: MovieDetailsView.horizontalInset),
            title.trailingAnchor.constraint(equalTo: poster.trailingAnchor, constant: -MovieDetailsView.horizontalInset),
            title.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: MovieDetailsView.verticalInset),

            countryAndYear.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            countryAndYear.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            countryAndYear.topAnchor.constraint(equalTo: title.bottomAnchor, constant: MovieDetailsView.verticalInset),

            genres.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            genres.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            genres.topAnchor.constraint(equalTo: countryAndYear.bottomAnchor, constant: MovieDetailsView.verticalInset),

            trailerButton.heightAnchor.constraint(equalToConstant: MovieDetailsView.trailerButtonSide),
            trailerButton.widthAnchor.constraint(equalToConstant: MovieDetailsView.trailerButtonSide),

            horizontalStackView.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: genres.bottomAnchor, constant: MovieDetailsView.verticalInset),

            overview.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            overview.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            overview.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: MovieDetailsView.verticalInset),
            overview.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])

    }

    func updateInfo(for movie: MovieDetailsUIModel) {
        title.text = movie.title
        countryAndYear.text = movie.countryAndYear
        genres.text = movie.genres
        rating.text = movie.rating
        overview.text = movie.overview
        trailerButton.isHidden = movie.shouldHideTrailerButton
        poster.isUserInteractionEnabled = movie.shouldEnableImageInteraction

        poster.kf.setImage(
            with: movie.posterURL,
            placeholder: UIColor.lightGray,
            options: [.transition(.fade(0.2))]
        )
    }

}
