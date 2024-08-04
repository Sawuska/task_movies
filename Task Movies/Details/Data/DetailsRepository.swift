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

    private let detailsNetworkService: NetworkService<MovieDetails>
    private let videosNetworkService: NetworkService<MovieVideosResponse>
    private let trailerMapper: TrailerMapper
    private let apiKey: String

    init(
        detailsNetworkService: NetworkService<MovieDetails>,
        videosNetworkService: NetworkService<MovieVideosResponse>,
        trailerMapper: TrailerMapper,
        apiKey: String
    ) {
        self.detailsNetworkService = detailsNetworkService
        self.videosNetworkService = videosNetworkService
        self.trailerMapper = trailerMapper
        self.apiKey = apiKey
    }

    func loadDetails(for movieId: Int) -> Single<(MovieDetails?, MovieTrailer?)> {
        Single.zip(
            loadInfo(for: movieId),
            loadTrailer(for: movieId)
        )
    }

    private func loadInfo(for movieId: Int) -> Single<MovieDetails?> {
        detailsNetworkService.fetchData(
            urlString: "https://api.themoviedb.org/3/movie/\(String(movieId))",
            parameters: Parameters(dictionaryLiteral: ("api_key", apiKey)))
    }

    private func loadTrailer(for movieId: Int) -> Single<MovieTrailer?> {
        videosNetworkService.fetchData(
            urlString: "https://api.themoviedb.org/3/movie/\(String(movieId))/videos",
            parameters: Parameters(dictionaryLiteral: ("api_key", apiKey)))
        .map { response in
            self.trailerMapper.mapFromResponse(response: response)
        }
    }
}
