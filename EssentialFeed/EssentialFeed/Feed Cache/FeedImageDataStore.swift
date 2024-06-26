//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-04-06.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
