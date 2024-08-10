//
//  MovieCoreDataRepository.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Foundation
import CoreData
import RxSwift

final class MovieCoreDataRepository {

    private let managedObjContext: NSManagedObjectContext
    private let genreMapper: GenreMapper
    private let limit: Int = 20

    init(managedObjContext: NSManagedObjectContext, genreMapper: GenreMapper) {
        self.managedObjContext = managedObjContext
        self.genreMapper = genreMapper
    }

    func fetchFromCoreData(for request: MovieRequestType, shouldSearchLocal: Bool) -> Observable<[MovieEntity]> {
        guard let request = self.createMovieFetchRequest(for: request, shouldSearchLocal: shouldSearchLocal) else {
            return Observable.empty()
        }
        return managedObjContext
            .observeOnChange(request: request)
    }

    private func createMovieFetchRequest(for request: MovieRequestType, shouldSearchLocal: Bool) -> NSFetchRequest<MovieEntity>? {
        let entityDescription = NSEntityDescription.entity(
            forEntityName: "MovieEntity",
            in: managedObjContext)
        let fetchRequest = MovieEntity.fetchRequest()
        fetchRequest.entity = entityDescription

        let predicate: NSPredicate

        if shouldSearchLocal, case .search(let query) = request {
            predicate = NSPredicate(format: "title contains[c] %@", query)
        } else {
            predicate = NSPredicate(format: "sort = %@", request.description)
        }

        fetchRequest.predicate = predicate
        let sortDecriptor = NSSortDescriptor(key: "showOrder", ascending: true)
        fetchRequest.sortDescriptors = [sortDecriptor]
        return fetchRequest
    }

    func cacheMovies(for request: MovieRequestType, movies: [Movie], genres: [Genre], page: Int) {
        if page == 1 {
            clearMovies()
        }
        guard let movieEntityDescription =
            NSEntityDescription.entity(forEntityName: "MovieEntity",
                                       in: managedObjContext) else { return }
        for (i, movie) in movies.enumerated() {
            let movieEntity = MovieEntity(
                entity: movieEntityDescription,
                insertInto: managedObjContext)
            movieEntity.id = Int64(movie.id)
            movieEntity.title = movie.title
            movieEntity.sort = request.description
            movieEntity.showOrder = Int64(page * limit + i)
            movieEntity.releaseDate = movie.releaseDate
            movieEntity.rating = movie.voteAverage ?? .zero
            movieEntity.posterPath = movie.posterPath
            movieEntity.genres = genreMapper.mapToString(ids: movie.genreIds ?? [], from: genres)
        }
        do {
            try managedObjContext.save()
        } catch let error as NSError {
            guard let conflicts = error.userInfo["conflictList"] as? [NSConstraintConflict] else {
                print(error.localizedDescription)
                return
            }
            handleConflicts(conflicts)
            do {
                try managedObjContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    private func clearMovies() {
        let entityDescription = NSEntityDescription.entity(
            forEntityName: "MovieEntity",
            in: managedObjContext)
        let fetchRequest = MovieEntity.fetchRequest()
        fetchRequest.entity = entityDescription

        do {
            let results = try self.managedObjContext.fetch(fetchRequest)
            results.forEach { managedObjContext.delete($0) }
        } catch let error {
            print(error.localizedDescription)
        }
        do {
            try managedObjContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    private func handleConflicts(_ conflicts: [NSConstraintConflict]) {
        for conflict in conflicts {
            let dbObject = conflict.databaseObject
            let conflictingObjects = conflict.conflictingObjects
            switch(dbObject) {
            case let movie as MovieEntity:
                handleMovieConflicts(
                    movie: movie,
                    conflictingObjects: conflictingObjects)
            default:
                return
            }
        }
    }

    private func handleMovieConflicts(movie: MovieEntity, conflictingObjects: [NSManagedObject]) {
        guard let conflictingObjects = conflictingObjects as? [MovieEntity] else { return }
        let objectsToDelete = Array(conflictingObjects)
        objectsToDelete.forEach { managedObjContext.delete($0) }
    }

}
