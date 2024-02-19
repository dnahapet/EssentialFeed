//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-02-16.
//

import Foundation
import EssentialFeed

struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [FeedImage]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
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
        self.loadingView?.display(FeedLoadingViewModel(isLoading: true))
        feedLoader?.load() { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(FeedViewModel(feed: feed))
            }
            self?.loadingView?.display(FeedLoadingViewModel(isLoading: false))
        }
    }
}
