//
//  MovieRepository.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import CoreData
import RxSwift

final class MovieRepository {

    private let sortSubject = BehaviorSubject<MovieSortType>(value: .popularityDescending)

    private let coreDataRepository: MovieCoreDataRepository
    private let paginationRepository: MoviePaginationRepository
    private let remoteGenreRepository: RemoteGenreRepository

    private let networkMonitor: NetworkMonitor

    private let sortTypes = MovieSortType.allCases

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
        return sortSubject
            .flatMap { sort in
                self.networkMonitor.start().flatMap { isConnected in
                    guard isConnected else {
                        return self.coreDataRepository.fetchFromCoreData(for: sort)
                    }
                    let pagination = self.paginationRepository.getPagination(for: sort)
                    return pagination.observe()
                        .withLatestFrom(self.remoteGenreRepository.loadGenres()) { ($0, $1) }
                        .do (onNext: { (response, genres) in
                            self.coreDataRepository.cacheMovies(
                                for: sort,
                                movies: response.results, 
                                genres: genres,
                                page: response.page)
                        })
                        .flatMap { _ in
                            self.coreDataRepository.fetchFromCoreData(for: sort)
                        }
                }
            }
    }

    func loadNextPage() {
        guard let sort = try? sortSubject.value() else { return }
        paginationRepository.loadNextPage(for: sort)
    }

    func changeSort(to sort: MovieSortType) {
        sortSubject.onNext(sort)
    }

    func getSortTypes() -> [MovieSortType] {
        sortTypes
    }

    func getCurrentSortType() -> MovieSortType {
        guard let sortType = try? sortSubject.value() else {
            return .popularityDescending
        }
        return sortType
    }
}
