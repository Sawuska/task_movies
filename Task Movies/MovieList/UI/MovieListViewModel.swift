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
    private let uiSortTypeMapper: MovieSortTypeUIMapper

    init(
        movieRepository: MovieRepository,
        uiMovieMapper: UIMovieMapper,
        uiSortTypeMapper: MovieSortTypeUIMapper
    ) {
        self.movieRepository = movieRepository
        self.uiMovieMapper = uiMovieMapper
        self.uiSortTypeMapper = uiSortTypeMapper
    }

    func observe() -> Observable<[MovieUIModel]> {
        movieRepository
            .observe()
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
}
