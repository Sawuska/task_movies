//
//  RouterImplementation.swift
//  Task Movies
//
//  Created by Alexandra on 12.08.2024.
//

import Foundation
import UIKit
import RxSwift

final class RouterImplementation: Router {

    private let movieListFactory: MovieListFactory
    private let movieDetailsFactory: MovieDetailsFactory
    private let alertFactory: AlertFactory
    private let networkMonitor: NetworkMonitor

    private var rootVC: UINavigationController!

    init(
        movieListFactory: MovieListFactory,
        movieDetailsFactory: MovieDetailsFactory,
        alertFactory: AlertFactory,
        networkMonitor: NetworkMonitor
    ) {
        self.movieListFactory = movieListFactory
        self.movieDetailsFactory = movieDetailsFactory
        self.alertFactory = alertFactory
        self.networkMonitor = networkMonitor
        self.rootVC = createRootViewController()
    }

    func getRootViewController() -> UIViewController {
        rootVC
    }

    private func createRootViewController() -> UINavigationController {
        UINavigationController(rootViewController: movieListFactory.create(router: self))
    }

    func navigateToDetails(movieID: Int) {
        if networkMonitor.isConnected {
            let detailsVC = self.movieDetailsFactory.create(movieID: movieID, router: self)
            self.rootVC.pushViewController(detailsVC, animated: true)
        } else {
            let alert = self.alertFactory.createNoInternetAlert()
            self.rootVC.present(alert, animated: true)
        }
    }

    func navigateBack() {
        rootVC.popViewController(animated: true)
    }

    func navigateToTrailer(url: URL?) {
        guard let url = url else { return }
        let playerVC = WebVideoViewController(trailerUrl: url)
        rootVC.present(playerVC, animated: true)
    }

    func navigateToPoster(url: URL?) {
        let posterVC = PosterViewController(posterURL: url)
        rootVC.present(posterVC, animated: true)
    }

    func navigateToSorting(
        sortUIModels: [MovieSortTypeUIModel],
        onSelect: @escaping (MovieSortTypeUIModel) -> Void
    ) {
        if networkMonitor.isConnected {
            let actionSheet = self.alertFactory
                .createActionSheet(sortUIModels: sortUIModels, onSelect: onSelect)
            self.rootVC.present(actionSheet, animated: true)
        } else {
            self.showNoInternetAlert()
        }
    }

    func showNoInternetAlert() {
        let alert = alertFactory.createNoInternetAlert()
        rootVC.present(alert, animated: true)
    }

}
