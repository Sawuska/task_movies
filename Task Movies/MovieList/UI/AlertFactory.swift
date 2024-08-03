//
//  SortActionSheet.swift
//  Task Movies
//
//  Created by Alexandra on 03.08.2024.
//

import Foundation
import UIKit

final class AlertFactory {

    func createActionSheet(
        sortUIModels: [MovieSortTypeUIModel],
        onSelect: @escaping (MovieSortTypeUIModel) -> Void
    ) -> UIAlertController {
        let actionSheetController = UIAlertController(title: "Sorting options", message: "Select how to sort the movies", preferredStyle: .actionSheet)

        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            actionSheetController.dismiss(animated: true)
        }
        actionSheetController.addAction(cancelActionButton)

        sortUIModels.forEach { uiModel in
            let action = UIAlertAction(title: uiModel.title, style: .default) { _ in
                onSelect(uiModel)
            }
            if uiModel.isSelected {
                action.setValue(true, forKey: "checked")
            }
            actionSheetController.addAction(action)
        }

        return actionSheetController
    }

    func createNoInternetAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: "You are offline. Please, enable your Wi-Fi or connect using cellular data.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(action)

        return alertController
    }
}
