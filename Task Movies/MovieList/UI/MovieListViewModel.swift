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
    private let uiMovieMapper: MovieUIMapper
    private let uiSortTypeMapper: MovieSortTypeUIMapper

    init(
        movieRepository: MovieRepository,
        uiMovieMapper: MovieUIMapper,
        uiSortTypeMapper: MovieSortTypeUIMapper
    ) {
        self.movieRepository = movieRepository
        self.uiMovieMapper = uiMovieMapper
        self.uiSortTypeMapper = uiSortTypeMapper
    }

    func observeMovies() -> Observable<[MovieUIModel]> {
        movieRepository
            .observeMovies()
            .map { movies in
                self.uiMovieMapper.mapEntitiesToUI(movies: movies)
            }
    }

    func getNextPage() {
        movieRepository.loadNextPage()
    }

    func changeSort(sortUIModel: MovieSortTypeUIModel) {
        guard let sort = uiSortTypeMapper.mapUIToSortType(uiModel: sortUIModel) else { return }
        movieRepository.changeSort(to: sort)
    }

    func getSortList() -> [MovieSortTypeUIModel] {
        uiSortTypeMapper.mapSortTypesToUI(
            sortTypes: movieRepository.getSortTypes(),
            currentSortType: movieRepository.getCurrentSortType())
    }

    func searchMovie(for query: String) {
        movieRepository.searchMovie(query: query)
    }
}
