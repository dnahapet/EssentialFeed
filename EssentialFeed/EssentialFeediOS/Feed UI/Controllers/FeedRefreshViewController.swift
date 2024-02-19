//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-02-12.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {
    private var presenter: FeedPresenter

    private(set) lazy var view = loadView()

    init(presenter: FeedPresenter) {
        self.presenter = presenter
    }

    @objc func refresh() {
        presenter.loadFeed()
    }

    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }

    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
