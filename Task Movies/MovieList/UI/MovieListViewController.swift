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
    private let alertFactory: AlertFactory
    private let disposeBag = DisposeBag()

    init(viewModel: MovieListViewModel, alertFactory: AlertFactory) {
        self.viewModel = viewModel
        self.alertFactory = alertFactory
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

        setUpNavigationBar()

        contentView.moviesTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        contentView.moviesTableView.contentInset = UIEdgeInsets(top: MovieListView.tableViewInset, left: .zero, bottom: MovieListView.tableViewInset, right: .zero)

        setObserver()
    }

    private func setUpNavigationBar() {
        navigationItem.title = "Popular Movies"
        let button = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTap))
        button.tintColor = .label
        navigationItem.rightBarButtonItem = button
    }

    @objc
    private func sortButtonTap() {
        openSortActionSheet()
    }

    private func openSortActionSheet() {
        let actionSheet = alertFactory
            .createActionSheet(sortUIModels: viewModel.getSortList()) { [weak self] in self?.viewModel.changeSort(sortUIModel: $0)
                self?.contentView.moviesTableView.setContentOffset(.zero, animated: true)
            }
        present(actionSheet, animated: true)
    }

    private func setObserver() {
        contentView.moviesTableView.dataSource = nil
        viewModel.observe()
            .observe(on: SerialDispatchQueueScheduler(qos: .userInteractive))
            .bind(to: contentView.moviesTableView.rx.items) { tableView, index, item in
                self.dequeueMovieCell(tableView: tableView, at: index, with: item)
            }
            .disposed(by: self.disposeBag)
    }

    private func dequeueMovieCell(
        tableView: UITableView,
        at index: Int,
        with item: MovieUIModel
    ) -> UITableViewCell {
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieCell",
            for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        cell.updateInfo(for: item)
        return cell
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
