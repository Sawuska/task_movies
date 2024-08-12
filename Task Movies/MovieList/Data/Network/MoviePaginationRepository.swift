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
    private var currentPaginationWithRequest: (request: MovieRequestType, pagination: Pagination<MovieResponse>)?

    private let defaultParams: Parameters

    private var shouldLoadGenres = true

    init(paginationFactory: PaginationFactory<MovieResponse>, apiKey: String, language: String) {
        self.paginationFactory = paginationFactory
        defaultParams = Parameters(dictionaryLiteral: ("api_key", apiKey), ("page", 1), ("language", language))
    }

    func getPagination(for request: MovieRequestType) -> Pagination<MovieResponse> {
        let pagination: Pagination<MovieResponse>
        if let currentPaginationWithRequest = currentPaginationWithRequest,
           currentPaginationWithRequest.request == request {
            pagination = currentPaginationWithRequest.pagination
        } else {
            pagination = createPagination(request: request)
            currentPaginationWithRequest = (request, pagination)
        }
        return pagination
    }

    func loadNextPage(for request: MovieRequestType) {
        getPagination(for: request).loadNextPage()
    }

    func refresh(for request: MovieRequestType) {
        getPagination(for: request).refresh()
    }

    private func createPagination(request: MovieRequestType) -> Pagination<MovieResponse> {
        var params = defaultParams
        let pagination: Pagination<MovieResponse>
        switch request {
        case .discover(let sort):
            params.updateValue(sort.rawValue, forKey: "sort_by")
            pagination = paginationFactory.create(urlString: APIURL.url + "discover/movie", requestParams: params)

        case .search(let query):
            params.updateValue(query, forKey: "query")
            pagination = paginationFactory.create(urlString: APIURL.url + "search/movie", requestParams: params)
        }
        return pagination
    }
}
