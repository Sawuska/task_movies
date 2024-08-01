//
//  MovieRepository.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import CoreData
import RxSwift

final class MovieRepository {

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

    func observe(for sort: MovieSortType = .popularityDescending) -> Observable<[Movie]> {
        let pagination = paginationRepository.getPagination(for: sort)
        return networkMonitor.start().flatMap { isConnected in
            if isConnected {
                return pagination.observe()
                    .map { response in
                        response.results
                }
            } else {
                return Observable<[Movie]>.empty()
            }
        }
    }

    func loadNextPage(for sort: MovieSortType) {
        paginationRepository.loadNextPage(for: sort)
    }
}
