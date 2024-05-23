//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-04-12.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
