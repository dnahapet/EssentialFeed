//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-02-29.
//

import Foundation
import EssentialFeed

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()

        feedLoader.load() { [weak self] result in
            switch result {
            case .success(let feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)
            case .failure(let error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}
