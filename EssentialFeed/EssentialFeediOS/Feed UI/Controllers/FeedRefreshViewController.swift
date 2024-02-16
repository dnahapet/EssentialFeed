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
        feedViewModel.onLoadingStateChange = { [weak view] isLoading in
            if isLoading {
                view?.beginRefreshing()
            } else {
                view?.endRefreshing()
            }
        }

        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
