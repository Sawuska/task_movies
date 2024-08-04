//
//  WebVideoViewController.swift
//  Task Movies
//
//  Created by Alexandra on 04.08.2024.
//

import UIKit
import WebKit

final class WebVideoViewController: UIViewController, WKNavigationDelegate {
    private let trailerUrl: URL

    init(trailerUrl: URL) {
        self.trailerUrl = trailerUrl
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        setUpView()
    }

    private func setUpView() {
        let webView = WKWebView()
        webView.useAutoLayout()
        view.addSubview(webView)
        view.backgroundColor = .systemBackground
        webView.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])

        webView.load(URLRequest(url: trailerUrl))
        webView.navigationDelegate = self
    }
}
