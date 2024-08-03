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
    private let genreMapper: GenreMapper

    init(
        repository: DetailsRepository,
        detailsMapper: MovieDetailsUIMapper,
        genreMapper: GenreMapper
    ) {
        self.repository = repository
        self.detailsMapper = detailsMapper
        self.genreMapper = genreMapper
    }

    func loadDetails(id: Int) -> Single<MovieDetailsUIModel> {
        repository.loadDetails(for: id)
            .map { details in
                self.detailsMapper
                    .mapDetailsToUI(details: details, genreMapper: self.genreMapper)
            }
    }
}
