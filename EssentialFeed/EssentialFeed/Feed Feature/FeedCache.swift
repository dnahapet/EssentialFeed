//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-04-12.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
