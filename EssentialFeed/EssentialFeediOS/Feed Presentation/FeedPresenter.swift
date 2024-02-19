//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-02-16.
//

import Foundation
import EssentialFeed

protocol FeedLoadingView {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {
    typealias Observer<T> = (T) -> Void

    private var feedLoader: FeedLoader?

    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    var loadingView: FeedLoadingView?
    var feedView: FeedView?

    func loadFeed() {
        self.loadingView?.display(isLoading: true)
        feedLoader?.load() { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
