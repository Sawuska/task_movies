//
//  MovieRepository.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import CoreData
import RxSwift

final class MovieRepository {

    private let requestSubject = BehaviorSubject<MovieRequestType>(value: .discover(sort: .popularityDescending))

    private let coreDataRepository: MovieCoreDataRepository
    private let paginationRepository: MoviePaginationRepository
    private let remoteGenreRepository: RemoteGenreRepository

    private let networkMonitor: NetworkMonitor

    private let sortTypes = MovieSortType.allCases

    private var lastSortType: MovieSortType = .popularityDescending

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

    func observeMovies() -> Observable<[MovieEntity]> {
        return requestSubject
            .flatMap { request in
                self.saveLastSortType(from: request)
                return self.networkMonitor.start().flatMap { isConnected in
                    guard isConnected else {
                        return self.coreDataRepository.fetchFromCoreData(for: request, shouldSearchLocal: true)
                    }
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
            }
    }

    private func saveLastSortType(from request: MovieRequestType) {
        if case .discover(let sort) = request {
            lastSortType = sort
        }
    }

    func loadNextPage() {
        guard let request = try? requestSubject.value() else { return }
        paginationRepository.loadNextPage(for: request)
    }

    func refresh() {
        guard let request = try? requestSubject.value() else { return }
        coreDataRepository.clearCachedMovies(for: request)
        paginationRepository.refresh(for: request)
    }

    func changeSort(to sort: MovieSortType) {
        requestSubject.onNext(.discover(sort: sort))
    }

    func getSortTypes() -> [MovieSortType] {
        sortTypes
    }

    func getCurrentSortType() -> MovieSortType {
        guard case .discover(let sortType) = try? requestSubject.value() else {
            return .popularityDescending
        }
        return sortType
    }

    func searchMovie(query: String) {
        guard !query.isEmpty else {
            requestSubject.onNext(.discover(sort: lastSortType))
            return
        }
        requestSubject.onNext(.search(query: query))
    }
}
