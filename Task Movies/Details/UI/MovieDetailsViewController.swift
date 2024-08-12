//
//  MovieDetailsViewController.swift
//  Task Movies
//
//  Created by Alexandra on 03.08.2024.
//

import UIKit
import RxSwift
import AVKit

final class MovieDetailsViewController: UIViewController {

    private let contentView = MovieDetailsView()

    private let disposeBag = DisposeBag()
    private let viewModel: MovieDetailsViewModel
    private let router: Router

    init(viewModel: MovieDetailsViewModel, router: Router) {
        self.viewModel = viewModel
        self.router = router
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
        setTrailerButtonTap()
    }

    private func loadDetails() {
        viewModel.loadDetails()
            .subscribe { uiModel in
                self.navigationItem.title = uiModel.title
                self.contentView.updateInfo(for: uiModel)
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
        router.navigateBack()
    }

    private func setImageViewTap() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTap))
        contentView.poster.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc
    private func imageViewTap() {
        router.navigateToPoster(url: viewModel.posterURL)
    }

    private func setTrailerButtonTap() {
        contentView.trailerButton.addTarget(self, action: #selector(trailerButtonTap), for: .touchUpInside)
    }

    @objc
    private func trailerButtonTap() {
        router.navigateToTrailer(url: viewModel.trailerURL)
    }

}
