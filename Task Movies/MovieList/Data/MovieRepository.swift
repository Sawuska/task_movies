//
//  MovieRepository.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import CoreData
import RxSwift

final class MovieRepository {

    private let movieRequestTypeSubject = BehaviorSubject<MovieRequestType>(value: .discover(sort: .popularityDescending))

    private let coreDataRepository: MovieCoreDataRepository
    private let paginationRepository: MoviePaginationRepository
    private let remoteGenreRepository: RemoteGenreRepository

    private let networkMonitor: NetworkMonitor

    private let sortTypes = MovieSortType.allCases

    private var currentSortType: MovieSortType = .popularityDescending

    init(coreDataRepository: MovieCoreDataRepository,
         paginationRepository: MoviePaginationRepository,
         remoteGenreRepository: RemoteGenreRepository,
         networkMonitor: NetworkMonitor
    ) {
        self.coreDataRepository = coreDataRepository
        self.paginationRepository = paginationRepository
        self.remoteGenreRepository = remoteGenreRepository
        self.networkMonitor = networkMonitor
    }

    func observeMovies() -> Observable<([MovieEntity], Bool)> {
        movieRequestTypeSubject
            .flatMapLatest { request in
                self.networkMonitor.observeConnectedStatus().flatMapLatest { isConnected in
                    if isConnected {
                        return self.loadWithPagination(request: request)
                            .map { ($0, isConnected) }
                    } else {
                        return self.coreDataRepository.fetchFromCoreData(for: request, shouldSearchLocal: true)
                            .map { ($0, isConnected) }
                    }
                }
            }
    }

    private func loadWithPagination(request: MovieRequestType) -> Observable<[MovieEntity]> {
        let pagination = self.paginationRepository.getPagination(for: request)
        return pagination.observe()
            .withLatestFrom(self.remoteGenreRepository.loadGenres()) { ($0, $1) }
            .do (onNext: { (response, genres) in
                self.coreDataRepository.cacheMovies(
                    for: request,
                    movies: response.results,
                    genres: genres,
                    page: response.page)
            })
            .flatMap { _ in
                self.coreDataRepository.fetchFromCoreData(for: request, shouldSearchLocal: false)
            }
    }

    func loadNextPage() {
        guard let request = try? movieRequestTypeSubject.value() else { return }
        paginationRepository.loadNextPage(for: request)
    }

    func refresh() {
        guard let request = try? movieRequestTypeSubject.value() else { return }
        paginationRepository.refresh(for: request)
    }

    func changeSort(to sort: MovieSortType) {
        movieRequestTypeSubject.onNext(.discover(sort: sort))
        currentSortType = sort
    }

    func getSortTypes() -> [MovieSortType] {
        sortTypes
    }

    func getCurrentSortType() -> MovieSortType {
        currentSortType
    }

    func searchMovie(query: String) {
        guard !query.isEmpty else {
            movieRequestTypeSubject.onNext(.discover(sort: currentSortType))
            return
        }
        movieRequestTypeSubject.onNext(.search(query: query))
    }
}
