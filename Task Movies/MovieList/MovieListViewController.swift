//
//  MovieListViewController.swift
//  Task Movies
//
//  Created by Alexandra on 31.07.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class MovieListViewController: UIViewController {

    let contentView = MovieListView()

    private let viewModel: MovieListViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.moviesTableView.dataSource = self
        contentView.moviesTableView.delegate = self
        contentView.moviesTableView.contentInset = UIEdgeInsets(top: MovieListView.tableViewInset, left: .zero, bottom: MovieListView.tableViewInset, right: .zero)


    }

}

extension MovieListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        MovieCell.getCellHeight(for: tableView.bounds.width)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height > 0,
              scrollView.bounds.size.height > 0 else { return }
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
            viewModel.getNextPage()
        }
    }
}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell else {
            return UITableViewCell()
        }
        cell.updateInfo()
        return cell
    }
    

}

