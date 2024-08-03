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
        let apiKey = "3fd5e68de77c9877441e0d99f37857e5"
        let mainVC = MovieListViewController(
            viewModel: MovieListViewModel(
                movieRepository: MovieRepository(
                    coreDataRepository: MovieCoreDataRepository(
                        managedObjContext: managedObjContext, 
                        genreMapper: GenreMapper()),
                    paginationRepository: MoviePaginationRepository(
                        paginationFactory: PaginationFactory<MovieResponse>(
                            networkService: NetworkService<MovieResponse>(
                                jsonMapper: JSONMapper<MovieResponse>())), 
                        apiKey: apiKey), 
                    remoteGenreRepository: RemoteGenreRepository(
                        networkService: NetworkService<GenreResponse>(
                            jsonMapper: JSONMapper<GenreResponse>()),
                        apiKey: apiKey),
                    networkMonitor: NetworkMonitor()),
                uiMovieMapper: MovieUIMapper(), 
                uiSortTypeMapper: MovieSortTypeUIMapper()), 
            detailsViewModel: MovieDetailsViewModel(
                repository: DetailsRepository(
                    networkService: NetworkService<MovieDetails>(
                        jsonMapper: JSONMapper<MovieDetails>()),
                    apiKey: apiKey),
                detailsMapper: MovieDetailsUIMapper(),
                genreMapper: GenreMapper()),
            alertFactory: AlertFactory())

        window.rootViewController = UINavigationController(rootViewController: mainVC)
        self.window = window
        window.makeKeyAndVisible()
    }


}

