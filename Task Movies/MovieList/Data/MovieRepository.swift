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

    private let networkMonitor: NetworkMonitor

    init(coreDataRepository: MovieCoreDataRepository,
         paginationRepository: MoviePaginationRepository,
         networkMonitor: NetworkMonitor
    ) {
        self.coreDataRepository = coreDataRepository
        self.paginationRepository = paginationRepository
        self.networkMonitor = networkMonitor
    }

    func observe() -> Observable<[MovieEntity]> {
        guard let sort = try? sortSubject.value() else { return Observable.empty() }
        let pagination = paginationRepository.getPagination(for: sort)
        return sortSubject
            .flatMap { sort in
                self.networkMonitor.start().flatMap { isConnected in
                    if isConnected {
                        return pagination.observe()
                            .do { response in
                                self.coreDataRepository.cacheMovies(
                                    for: sort,
                                    movies: response.results,
                                    page: response.page)
                            }
                            .flatMap { _ in
                                self.coreDataRepository.fetchFromCoreData(for: sort)
                            }
                    } else {
                        return self.coreDataRepository.fetchFromCoreData(for: sort)
                    }
                }
            }
    }

    func loadNextPage() {
        guard let sort = try? sortSubject.value() else { return }
        paginationRepository.loadNextPage(for: sort)
    }
}
