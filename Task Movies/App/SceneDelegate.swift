//
//  SceneDelegate.swift
//  Task Movies
//
//  Created by Alexandra on 31.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let managedObjContext = AppDelegate().persistentContainer.viewContext
        let mainVC = MovieListViewController(
            viewModel: MovieListViewModel(
                movieRepository: MovieRepository(
                    coreDataRepository: MovieCoreDataRepository(
                        managedObjContext: managedObjContext),
                    paginationRepository: MoviePaginationRepository(
                        paginationFactory: PaginationFactory<MovieResponse>(
                            networkService: NetworkService<MovieResponse>(
                                jsonMapper: JSONMapper<MovieResponse>()))),
                    networkMonitor: NetworkMonitor()),
                uiMovieMapper: UIMovieMapper()))

        window.rootViewController = UINavigationController(rootViewController: mainVC)
        self.window = window
        window.makeKeyAndVisible()
    }


}

