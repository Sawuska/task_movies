//
//  MovieListView.swift
//  Task Movies
//
//  Created by Alexandra on 31.07.2024.
//

import UIKit

final class MovieListView: UIView {
    
    static let tableViewInset: CGFloat = 10
    private static let searchHeightToViewHeight: CGFloat = 0.08

    private let loadingView: UIActivityIndicatorView = {
        @UseAutoLayout var view = UIActivityIndicatorView(style: .large)
        view.backgroundColor = .clear
        view.hidesWhenStopped = true
        return view
    }()

    let searchBarView: UISearchBar = {
        @UseAutoLayout var view = UISearchBar()
        view.searchBarStyle = .minimal
        view.placeholder = String(localized: "Search")
        view.searchTextField.backgroundColor = .systemFill
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

    let refreshControl = UIRefreshControl()

    private let placeholder: UILabel = {
        @UseAutoLayout var view = UILabel(withSystemFontOfSize: 24)
        view.text = String(localized: "Nothing found")
        view.backgroundColor = .clear
        view.textColor = .darkGray
        view.numberOfLines = 3
        view.textAlignment = .center
        view.isHidden = true
        return view
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [searchBarView, moviesTableView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.useAutoLayout()
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        [mainStackView, loadingView, placeholder].forEach(addSubview)
        backgroundColor = .systemBackground
        useAutoLayout()
        moviesTableView.refreshControl = refreshControl
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

            searchBarView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: MovieListView.searchHeightToViewHeight),

            placeholder.topAnchor.constraint(equalTo: moviesTableView.topAnchor),
            placeholder.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            placeholder.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            placeholder.heightAnchor.constraint(equalTo: moviesTableView.heightAnchor, multiplier: 0.5),
        ])

        NSLayoutConstraint.constraintFrameToMatchParent(child: loadingView, parent: moviesTableView)
    }

    func scrollToTop() {
        moviesTableView.setContentOffset(.zero, animated: true)
    }

    func startLoadingIndicator() {
        loadingView.isHidden = false
        loadingView.startAnimating()
    }

    func stopLoadingIndicator() {
        loadingView.stopAnimating()
        loadingView.isHidden = true
    }

    func hideKeyboard() {
        if searchBarView.isFirstResponder {
            searchBarView.endEditing(true)
        }
    }

    func showNoResultsPlaceholder() {
        placeholder.isHidden = false
    }

    func hideNoResultsPlaceholder() {
        placeholder.isHidden = true
    }
}
