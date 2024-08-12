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
        let title = String(localized: "Sorting options")
        let message = String(localized: "Select how to sort the movies")
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        let cancelActionButton = UIAlertAction(title: String(localized: "Cancel"), style: .cancel) { _ in
            actionSheetController.dismiss(animated: true)
        }
        actionSheetController.addAction(cancelActionButton)

        sortUIModels.forEach { uiModel in
            let action = UIAlertAction(title: uiModel.title, style: .default) { _ in
                onSelect(uiModel)
            }
            // The task implied that it's better to use a "checked" property instead of
            // a custom implementation of a UI element, but I'm also aware that it's a private API
            // that might be subject to change.
            action.setValue(uiModel.isSelected, forKey: "checked")
            actionSheetController.addAction(action)
        }

        return actionSheetController
    }

    func createNoInternetAlert() -> UIAlertController {
        let alertController = UIAlertController(title: String(localized: "Error"), message: String(localized: "You are offline. Please, enable your Wi-Fi or connect using cellular data."), preferredStyle: .alert)
        let action = UIAlertAction(title: String(localized: "Ok"), style: .cancel) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(action)

        return alertController
    }
}
