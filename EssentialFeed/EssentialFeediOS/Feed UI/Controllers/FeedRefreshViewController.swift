//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-02-12.
//

import UIKit
import EssentialFeed

final class FeedRefreshViewController: NSObject {
    private var feedLoader: FeedLoader?

    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()

    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    var onRefresh: (([FeedImage]) -> Void)?

    @objc func refresh() {
        view.beginRefreshing()

        feedLoader?.load() { [weak self] result in
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
            self?.view.endRefreshing()
        }
    }
}
