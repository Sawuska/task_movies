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
        let language = getLanguage()
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
                        apiKey: apiKey, 
                        language: language),
                    remoteGenreRepository: RemoteGenreRepository(
                        networkService: NetworkService<GenreResponse>(
                            jsonMapper: JSONMapper<GenreResponse>()),
                        apiKey: apiKey, 
                        language: language),
                    networkMonitor: NetworkMonitor()),
                uiMovieMapper: MovieUIMapper(), 
                uiSortTypeMapper: MovieSortTypeUIMapper()), 
            detailsViewModel: MovieDetailsViewModel(
                repository: DetailsRepository(
                    detailsNetworkService: 
                        NetworkService<MovieDetails>(
                            jsonMapper: JSONMapper<MovieDetails>()),
                    videosNetworkService: NetworkService<MovieVideosResponse>(
                        jsonMapper: JSONMapper<MovieVideosResponse>()),
                    trailerMapper: TrailerMapper(),
                    apiKey: apiKey, 
                    language: language),
                detailsMapper: MovieDetailsUIMapper(),
                genreMapper: GenreMapper()),
            alertFactory: AlertFactory())

        window.rootViewController = UINavigationController(rootViewController: mainVC)
        self.window = window
        window.makeKeyAndVisible()
    }

    private func getLanguage() -> String {
        Bundle.main.preferredLocalizations[0]
    }

}

