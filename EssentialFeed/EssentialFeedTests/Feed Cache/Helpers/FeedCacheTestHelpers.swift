//
//  FeedCacheTestHelper.swift
//  EssentialFeedTests
//
//  Created by Davit Nahapetyan on 2023-12-13.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: nil, location: nil, url: anyURL())
}

func uniqueFeed() -> (models: [FeedImage], localModels: [LocalFeedImage]) {
    let images = [uniqueImage(), uniqueImage()]
    let localImages = images.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    return (images, localImages)
}

extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }

    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
