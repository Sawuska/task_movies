//
//  FetchedResultController.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Foundation
import CoreData
import RxSwift
import UIKit

extension NSManagedObjectContext {

    func observeOnChange <T>(
        request: NSFetchRequest<T>
    ) -> Observable<[T]> {
        Observable<[T]>.create { observable in
            var controller: NSFetchedResultsController? = NSFetchedResultsController(fetchRequest: request,
                                                        managedObjectContext: self,
                                                        sectionNameKeyPath: nil,
                                                        cacheName: nil)
            var fetchResultControllerDelegate: FetchedResultController? = FetchedResultController(onDidChangeContent: { result in
                observable.on(.next(result))
            })
            controller?.delegate = fetchResultControllerDelegate
            do {
                try controller?.performFetch()
            } catch let error {
                print(error.localizedDescription)
                observable.onError(error)
            }
            return Disposables.create {
                controller = nil
                fetchResultControllerDelegate = nil
            }
        }
    }
}

class FetchedResultController<T>: NSObject, NSFetchedResultsControllerDelegate {

    private let onDidChangeContent: ([T]) -> Void

    init(onDidChangeContent: @escaping ([T]) -> Void) {
        self.onDidChangeContent = onDidChangeContent
        super.init()
    }

    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        onDidChangeContent(controller.fetchedObjects?.compactMap { $0 as? T } ?? [])
    }
}
