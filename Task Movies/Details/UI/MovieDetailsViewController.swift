//
//  MovieDetailsViewController.swift
//  Task Movies
//
//  Created by Alexandra on 03.08.2024.
//

import UIKit
import RxSwift

final class MovieDetailsViewController: UIViewController {

    let contentView = MovieDetailsView()

    private let disposeBag = DisposeBag()
    private let viewModel: MovieDetailsViewModel
    private let movieId: Int
    private var posterURL: URL?

    init(movieId: Int, viewModel: MovieDetailsViewModel) {
        self.movieId = movieId
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(contentView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationItem()

        loadDetails()

        setImageViewTap()
    }

    private func loadDetails() {
        viewModel.loadDetails(id: movieId)
            .subscribe { uiModel in
                self.navigationItem.title = uiModel.title
                self.contentView.updateInfo(for: uiModel)
                self.posterURL = uiModel.posterURL
            }
            .disposed(by: disposeBag)
    }

    private func setUpNavigationItem() {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTap))
        button.tintColor = .label
        navigationItem.leftBarButtonItem = button
    }

    @objc
    private func backButtonTap() {
        navigationController?.popViewController(animated: true)
    }

    private func setImageViewTap() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTap))
        contentView.poster.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc
    private func imageViewTap() {
        let posterVC = PosterViewController(posterURL: posterURL)
        present(posterVC, animated: true)
    }

}
