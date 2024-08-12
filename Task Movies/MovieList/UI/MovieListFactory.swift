//
//  MovieListFactory.swift
//  Task Movies
//
//  Created by Alexandra on 12.08.2024.
//

import Foundation
import CoreData
import RxSwift

final class MovieListFactory {
    
    private let apiKey: String
    private let language: String
    private let managedObjContext: NSManagedObjectContext

    init(apiKey: String, language: String, managedObjContext: NSManagedObjectContext) {
        self.apiKey = apiKey
        self.language = language
        self.managedObjContext = managedObjContext
    }

    func create(router: Router) -> MovieListViewController {
        let coreDataRepository = MovieCoreDataRepository(
            managedObjContext: managedObjContext,
            genreMapper: GenreMapper())
        let paginationRepository = MoviePaginationRepository(
            paginationFactory: PaginationFactory<MovieResponse>(
                networkService: NetworkService<MovieResponse>(
                    jsonMapper: JSONMapper<MovieResponse>())),
            apiKey: apiKey,
            language: language)
        let genreRepository = RemoteGenreRepository(
            networkService: NetworkService<GenreResponse>(
                jsonMapper: JSONMapper<GenreResponse>()),
            apiKey: apiKey,
            language: language)
        let repository = MovieRepository(
            coreDataRepository: coreDataRepository,
            paginationRepository: paginationRepository,
            remoteGenreRepository: genreRepository, 
            networkMonitor: NetworkMonitor.shared)

        let viewModel = MovieListViewModel(
            movieRepository: repository,
            uiMovieMapper: MovieUIMapper(),
            uiSortTypeMapper: MovieSortTypeUIMapper(), 
            scheduler: MainScheduler.instance)
        let vc = MovieListViewController(
            viewModel: viewModel,
            router: router)

        return vc
    }

}
