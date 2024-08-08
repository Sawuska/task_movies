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

    init(paginationFactory: PaginationFactory<MovieResponse>, apiKey: String, language: String) {
        self.paginationFactory = paginationFactory
        defaultParams = Parameters(dictionaryLiteral: ("api_key", apiKey), ("page", 1), ("language", language))
    }

    func getPagination(for request: MovieRequestType) -> Pagination<MovieResponse> {
        moviesPagination[request.description] ?? createPagination(request: request)
    }

    func loadNextPage(for request: MovieRequestType) {
        moviesPagination[request.description]?.loadNextPage()
    }

    func refresh(for request: MovieRequestType) {
        moviesPagination[request.description]?.refresh()
    }

    private func createPagination(request: MovieRequestType) -> Pagination<MovieResponse> {
        var params = defaultParams
        let pagination: Pagination<MovieResponse>
        switch request {
        case .discover(let sort):
            params.updateValue(sort.rawValue, forKey: "sort_by")
            pagination = paginationFactory.create(urlString: "https://api.themoviedb.org/3/discover/movie", requestParams: params)
            
        case .search(let query):
            params.updateValue(query, forKey: "query")
            pagination = paginationFactory.create(urlString: "https://api.themoviedb.org/3/search/movie", requestParams: params)
        }
        moviesPagination[request.description] = pagination
        return pagination
    }
}
