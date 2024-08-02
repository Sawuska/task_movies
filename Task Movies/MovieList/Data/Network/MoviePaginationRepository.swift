//
//  MoviePaginationRepository.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import CoreData
import RxSwift
import Alamofire

final class MoviePaginationRepository {

    private let paginationFactory: PaginationFactory<MovieResponse>
    private var moviesPagination: [String: Pagination<MovieResponse>] = [:]

    private let defaultParams: Parameters

    private var shouldLoadGenres = true

    init(paginationFactory: PaginationFactory<MovieResponse>, apiKey: String) {
        self.paginationFactory = paginationFactory
        defaultParams = Parameters(dictionaryLiteral: ("api_key", apiKey), ("page", 1))
    }

    func getPagination(for sort: MovieSortType) -> Pagination<MovieResponse> {
        moviesPagination[sort.rawValue] ?? createPagination(for: sort)
    }

    func loadNextPage(for sort: MovieSortType) {
        moviesPagination[sort.rawValue]?.loadNextPage()
    }

    private func createPagination(for sort: MovieSortType) -> Pagination<MovieResponse> {
        var params = defaultParams
        params.updateValue(sort.rawValue, forKey: "sort_by")
        let pagination = paginationFactory.create(urlString: "https://api.themoviedb.org/3/discover/movie", requestParams: params)
        moviesPagination[sort.rawValue] = pagination
        return pagination
    }
}
