//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-02-12.
//

import UIKit

final class FeedRefreshViewController: NSObject {
    private var feedViewModel: FeedViewModel

    private(set) lazy var view = binded(UIRefreshControl())

    init(viewModel: FeedViewModel) {
        self.feedViewModel = viewModel
    }

    @objc func refresh() {
        feedViewModel.loadFeed()
    }

    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        feedViewModel.onChange = { [weak self] viewModel in
            if viewModel.isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
        }

        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
