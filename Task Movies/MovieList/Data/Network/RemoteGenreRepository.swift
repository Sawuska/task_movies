//
//  RemoteGenreRepository.swift
//  Task Movies
//
//  Created by Alexandra on 02.08.2024.
//

import Foundation
import RxSwift
import Alamofire

final class RemoteGenreRepository {

    private let networkService: NetworkService<GenreResponse>
    private let defaultParams: Parameters

    init(networkService: NetworkService<GenreResponse>, apiKey: String, language: String) {
        self.networkService = networkService
        defaultParams = Parameters(dictionaryLiteral: ("api_key", apiKey), ("language", language))
    }

    func loadGenres() -> Single<[Genre]> {
        networkService.fetchData(
            urlString: APIURL.url + "genre/movie/list",
            parameters: defaultParams)
        .map { response in
            response?.genres ?? []
        }
    }
}
