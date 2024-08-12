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
    private let defaultParams: Parameters

    init(
        detailsNetworkService: NetworkService<MovieDetails>,
        videosNetworkService: NetworkService<MovieVideosResponse>,
        trailerMapper: TrailerMapper,
        apiKey: String,
        language: String
    ) {
        self.detailsNetworkService = detailsNetworkService
        self.videosNetworkService = videosNetworkService
        self.trailerMapper = trailerMapper
        defaultParams = Parameters(dictionaryLiteral: ("api_key", apiKey), ("page", 1), ("language", language))
    }

    func loadDetails(for movieId: Int) -> Single<(MovieDetails?, MovieTrailer?)> {
        Single.zip(
            loadInfo(for: movieId),
            loadTrailer(for: movieId)
        )
    }

    private func loadInfo(for movieId: Int) -> Single<MovieDetails?> {
        detailsNetworkService.fetchData(
            urlString: APIURL.url + "movie/\(String(movieId))",
            parameters: defaultParams)
    }

    private func loadTrailer(for movieId: Int) -> Single<MovieTrailer?> {
        videosNetworkService.fetchData(
            urlString: APIURL.url + "movie/\(String(movieId))/videos",
            parameters: defaultParams)
        .map { response in
            self.trailerMapper.mapFromResponse(response: response)
        }
    }
}
