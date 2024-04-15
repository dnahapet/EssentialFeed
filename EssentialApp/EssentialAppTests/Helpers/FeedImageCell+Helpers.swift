//
//  FeedImageCell+Helpers.swift
//  EssentialFeediOSTests
//
//  Created by Davit Nahapetyan on 2024-02-26.
//

import Foundation
import EssentialFeediOS

extension FeedImageCell {
    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }

    var isShowingRetryAction: Bool {
        return !feedImageRetryButton.isHidden
    }

    var locationText: String? {
        return locationLabel.text
    }

    var descriptionText: String? {
        return descriptionLabel.text
    }
    
    var isShowingImageLoadingIndicator: Bool {
        return feedImageContainer.isShimmering
    }

    var renderedImage: Data? {
        return feedImageView.image?.pngData()
    }

    func simulateRetryAction() {
        feedImageRetryButton.simulateTap()
    }
}
