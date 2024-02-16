//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-02-12.
//

import Foundation
import EssentialFeed
import UIKit

public final class FeedUIComposer {
    private init() {}

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let feedViewModel = FeedViewModel(feedLoader: feedLoader)
        let feedRefreshController = FeedRefreshViewController(viewModel: feedViewModel)
        let feedViewController = FeedViewController(feedRefreshController: feedRefreshController)
        feedViewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedViewController, imageLoader: imageLoader)
        return feedViewController
    }

    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, imageLoader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init))
            }
        }
    }
}
