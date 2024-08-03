//
//  DetailsRepository.swift
//  Task Movies
//
//  Created by Alexandra on 03.08.2024.
//

import Foundation
import RxSwift
import Alamofire

final class DetailsRepository {

    private let networkService: NetworkService<MovieDetails>
    private let apiKey: String

    init(networkService: NetworkService<MovieDetails>, apiKey: String) {
        self.networkService = networkService
        self.apiKey = apiKey
    }

    func loadDetails(for movieId: Int) -> Single<MovieDetails?> {
        networkService.fetchData(
            urlString: "https://api.themoviedb.org/3/movie/\(String(movieId))",
            parameters: Parameters(dictionaryLiteral: ("api_key", apiKey)))
    }
}
