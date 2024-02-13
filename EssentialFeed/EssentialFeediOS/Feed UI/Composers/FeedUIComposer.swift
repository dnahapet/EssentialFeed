//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-02-12.
//

import Foundation
import EssentialFeed

public final class FeedUIComposer {
    private init() {}

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let feedRefreshController = FeedRefreshViewController(feedLoader: feedLoader)
        let feedViewController = FeedViewController(feedRefreshController: feedRefreshController)
        feedRefreshController.onRefresh = adaptFeedToCellControllers(forwardingTo: feedViewController, imageLoader: imageLoader)
        return feedViewController
    }

    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, imageLoader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                FeedImageCellController(model: model, imageLoader: imageLoader)
            }
        }
    }
}
