//
//  MovieListViewModel.swift
//  Task Movies
//
//  Created by Alexandra on 31.07.2024.
//

import Foundation
import RxSwift

final class MovieListViewModel {

    private let movieRepository: MovieRepository
    private let uiMovieMapper: UIMovieMapper

    init(movieRepository: MovieRepository, uiMovieMapper: UIMovieMapper) {
        self.movieRepository = movieRepository
        self.uiMovieMapper = uiMovieMapper
    }

    func observe() -> Observable<[MovieUIModel]> {
        movieRepository
            .observe()
            .map { movies in
                self.uiMovieMapper.mapToUI(movies: movies)
            }
    }

    func getNextPage(for sort: MovieSortType) {
        movieRepository.loadNextPage(for: sort)
    }
}
