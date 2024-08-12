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

    private let contentView = MovieListView()

    private let viewModel: MovieListViewModel
    private let router: Router
    private let disposeBag = DisposeBag()

    init(
        viewModel: MovieListViewModel,
        router: Router
    ) {
        self.viewModel = viewModel
        self.router = router
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

        setUpNavigationBar()

        contentView.moviesTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        contentView.moviesTableView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: MovieListView.tableViewInset, right: .zero)
        setUpRefreshControl()

        setObserver()
        setSearchBarObserver()
        setIsLoadingObserver()
    }

    private func setUpNavigationBar() {
        navigationItem.title = String(localized: "Popular Movies")
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
        router.navigateToSorting(sortUIModels: viewModel.getSortList()) { [weak self] in
            self?.viewModel.changeSort(sortUIModel: $0)
            self?.contentView.scrollToTop()
        }
    }

    private func setUpRefreshControl() {
        contentView.refreshControl.addTarget(self, action: #selector(tableViewPullToRefresh), for: .valueChanged)
    }

    @objc
    private func tableViewPullToRefresh() {
        viewModel.refresh()
    }

    private func setObserver() {
        contentView.moviesTableView.dataSource = nil
        viewModel.observeMovies()
            .do(
                onNext: { [weak self] listData in
                    self?.contentView.updateVisibilityOnResult(resultIsEmpty: listData.movies.isEmpty)
                    if !listData.isConnected {
                        self?.router.showNoInternetAlert()
                    }
                }
            )
            .map { $0.movies }
            .bind(to: contentView.moviesTableView.rx.items) { tableView, index, item in
                self.dequeueMovieCell(tableView: tableView, at: index, with: item)
            }
            .disposed(by: self.disposeBag)

        contentView.moviesTableView.rx.modelSelected(MovieUIModel.self)
            .subscribe { [weak self] event in
                guard let id = event.element?.id else { return }
                self?.router.navigateToDetails(movieID: id)
            }
            .disposed(by: disposeBag)
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

    private func setSearchBarObserver() {
        contentView.searchBarView.rx.text.orEmpty.changed
            .distinctUntilChanged()
            .do(onNext: { _ in
                self.viewModel.loadingSubject.onNext(true)
            })
            .debounce(
                .milliseconds(500),
                scheduler: ConcurrentDispatchQueueScheduler(qos: .utility)
            )
            .bind(onNext: { [weak self] query in
                self?.viewModel.searchMovie(for: query)
            })
            .disposed(by: disposeBag)
    }

    private func setIsLoadingObserver() {
        viewModel.loadingSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] shouldShowLoading in
                self?.contentView.updateLoadingVisibility(isLoading: shouldShowLoading)
            }
            .disposed(by: disposeBag)
    }
}

extension MovieListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        MovieCell.getCellHeight(for: tableView.bounds.width)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentView.hideKeyboard()
        guard scrollView.contentSize.height > 0,
              scrollView.bounds.size.height > 0 else { return }
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - (scrollView.bounds.size.height * 3))) {
            viewModel.getNextPage()
        }
    }
}
