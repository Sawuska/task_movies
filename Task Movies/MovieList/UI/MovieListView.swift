//
//  MovieListView.swift
//  Task Movies
//
//  Created by Alexandra on 31.07.2024.
//

import UIKit

final class MovieListView: UIView {
    
    static let tableViewInset: CGFloat = 10

    private let loadingView: UIActivityIndicatorView = {
        @UseAutoLayout var view = UIActivityIndicatorView(style: .large)
        view.backgroundColor = .clear
        view.hidesWhenStopped = true
        return view
    }()

    let moviesTableView: UITableView = {
        @UseAutoLayout var view = UITableView(frame: .zero)
        view.backgroundColor = .clear
        view.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        return view
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [moviesTableView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.useAutoLayout()
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(mainStackView)
        addSubview(loadingView)
        backgroundColor = .systemBackground
        useAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.constraintFrameToMatchParent(child: self, parent: self.superview)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])

        NSLayoutConstraint.constraintFrameToMatchParent(child: loadingView, parent: moviesTableView)
    }

    func scrollToTop() {
        moviesTableView.contentOffset = .zero
    }

    func startLoadingIndicator() {
        loadingView.isHidden = false
        loadingView.startAnimating()
    }

    func stopLoadingIndicator() {
        loadingView.stopAnimating()
        loadingView.isHidden = true
    }
}
