//
//  MovieDetailsViewController.swift
//  Task Movies
//
//  Created by Alexandra on 03.08.2024.
//

import UIKit
import RxSwift

final class MovieDetailsViewController: UIViewController {

    let contentView = MovieDetailsView()

    private let disposeBag = DisposeBag()
    private let movieId: Int
    private let viewModel: MovieDetailsViewModel

    init(movieId: Int, viewModel: MovieDetailsViewModel) {
        self.movieId = movieId
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(contentView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.loadDetails(id: movieId)
            .subscribe { uiModel in
                self.navigationItem.title = uiModel.title
                self.contentView.updateInfo(for: uiModel)
            }
            .disposed(by: disposeBag)
    }

}
