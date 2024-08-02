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
    private let apiKey: String

    init(networkService: NetworkService<GenreResponse>, apiKey: String) {
        self.networkService = networkService
        self.apiKey = apiKey
    }

    func loadGenres() -> Single<[Genre]> {
        networkService.fetchData(
            urlString: "https://api.themoviedb.org/3/genre/movie/list",
            parameters: Parameters(dictionaryLiteral: ("api_key", apiKey)))
        .map { response in
            response?.genres ?? []
        }
    }
}
