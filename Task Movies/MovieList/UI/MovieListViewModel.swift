//
//  MovieListViewModel.swift
//  Task Movies
//
//  Created by Alexandra on 31.07.2024.
//

import Foundation
import RxSwift

final class MovieListViewModel {

    let loadingSubject = BehaviorSubject<Bool>(value: false)

    private let movieRepository: MovieRepository
    private let uiMovieMapper: MovieUIMapper
    private let uiSortTypeMapper: MovieSortTypeUIMapper
    private let scheduler: ImmediateSchedulerType

    init(
        movieRepository: MovieRepository,
        uiMovieMapper: MovieUIMapper,
        uiSortTypeMapper: MovieSortTypeUIMapper,
        scheduler: ImmediateSchedulerType
    ) {
        self.movieRepository = movieRepository
        self.uiMovieMapper = uiMovieMapper
        self.uiSortTypeMapper = uiSortTypeMapper
        self.scheduler = scheduler
    }

    func observeMovies() -> Observable<MovieListData> {
        loadingSubject.onNext(true)
        return movieRepository
            .observeMovies()
            .map { (movies, isConnected) in
                self.loadingSubject.onNext(false)
                let uiModels = self.uiMovieMapper.mapEntitiesToUI(movies: movies)
                return MovieListData(movies: uiModels, isConnected: isConnected)
            }
            .observe(on: scheduler)
    }

    func getNextPage() {
        movieRepository.loadNextPage()
    }

    func refresh() {
        movieRepository.refresh()
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
