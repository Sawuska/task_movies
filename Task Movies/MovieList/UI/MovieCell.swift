//
//  MovieCell.swift
//  Task Movies
//
//  Created by Alexandra on 31.07.2024.
//

import UIKit
import Kingfisher

final class MovieCell: UITableViewCell {

    private static let horizontalInset: CGFloat = 15
    private static let verticalInset: CGFloat = 10
    private static let infoHorizontalInset: CGFloat = 20
    private static let titleTopInset: CGFloat = 30
    private static let genresBottomInset: CGFloat = 40
    private static let titleFontSize: CGFloat = 24
    private static let secondaryFontSize: CGFloat = 18
    private static let heightToWidth: CGFloat = 0.7

    private let titleAndYear: UILabel = {
        @UseAutoLayout var label = UILabel(withBoldFontOfSize: titleFontSize)
        label.textColor = .white
        label.numberOfLines = 4
        return label
    }()

    private let genres: UILabel = {
        @UseAutoLayout var label = UILabel(withSystemFontOfSize: secondaryFontSize)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    private let rating: UILabel = {
        @UseAutoLayout var label = UILabel(withSystemFontOfSize: secondaryFontSize)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()

    private let poster: UIImageView = {
        @UseAutoLayout var view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.kf.indicatorType = .activity
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    private let posterContainer: UIView = {
        @UseAutoLayout var view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 8
        return view
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [genres, rating])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .bottom
        stackView.useAutoLayout()
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(posterContainer)
        posterContainer.addSubview(poster)
        contentView.addSubview(titleAndYear)
        contentView.addSubview(horizontalStackView)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        poster.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            posterContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: MovieCell.horizontalInset),
            posterContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -MovieCell.horizontalInset),
            posterContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -MovieCell.verticalInset),
            posterContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: MovieCell.verticalInset),

            titleAndYear.leadingAnchor.constraint(equalTo: poster.leadingAnchor, constant: MovieCell.infoHorizontalInset),
            titleAndYear.topAnchor.constraint(equalTo: poster.topAnchor, constant: MovieCell.titleTopInset),
            titleAndYear.trailingAnchor.constraint(equalTo: poster.trailingAnchor, constant: -MovieCell.infoHorizontalInset),

            horizontalStackView.leadingAnchor.constraint(equalTo: titleAndYear.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: poster.trailingAnchor, constant: -MovieCell.infoHorizontalInset),
            horizontalStackView.bottomAnchor.constraint(equalTo: poster.bottomAnchor, constant: -MovieCell.genresBottomInset),
        ])

        NSLayoutConstraint.constraintFrameToMatchParent(child: poster, parent: posterContainer)
    }

    func updateInfo(for movie: MovieUIModel) {
        titleAndYear.text = movie.titleAndYear
        genres.text = movie.genres
        rating.text = movie.rating
        
        poster.kf.setImage(
            with: movie.posterURL,
            placeholder: UIColor.lightGray,
            options: [.transition(.fade(0.2))]
        )
    }

    static func getCellHeight(for width: CGFloat) -> CGFloat {
        width * heightToWidth
    }
}
