//
//  MovieDetailsViewModel.swift
//  Task Movies
//
//  Created by Alexandra on 03.08.2024.
//

import Foundation
import RxSwift

final class MovieDetailsViewModel {

    private let repository: DetailsRepository
    private let detailsMapper: MovieDetailsUIMapper
    private let movieID: Int

    var posterURL: URL?
    var trailerURL: URL?

    init(
        repository: DetailsRepository,
        detailsMapper: MovieDetailsUIMapper,
        movieID: Int
    ) {
        self.repository = repository
        self.detailsMapper = detailsMapper
        self.movieID = movieID
    }

    func loadDetails() -> Single<MovieDetailsUIModel> {
        repository.loadDetails(for: movieID)
            .map { (details, trailer) in
                self.detailsMapper
                    .mapDetailsToUI(details: details, trailer: trailer)
            }
            .do { uiModel in
                self.posterURL = uiModel.posterURL
                self.trailerURL = uiModel.trailerURL
            }
    }
}
