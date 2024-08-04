//
//  PosterViewController.swift
//  Task Movies
//
//  Created by Alexandra on 04.08.2024.
//

import UIKit

final class PosterViewController: UIViewController {

    let contentView = PosterView()

    private let posterURL: URL?

    init(posterURL: URL?) {
        self.posterURL = posterURL
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
        
        contentView.setPoster(url: posterURL)
        contentView.scrollView.delegate = self
        setUpCloseButton()
    }

    private func setUpCloseButton() {
        contentView.closeButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
    }

    @objc
    private func closeButtonTap() {
        dismiss(animated: true)
    }
}

extension PosterViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        contentView.poster
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            preferredContentSize.height = scrollView.frame.height - scrollView.contentOffset.y
        }
    }

}
