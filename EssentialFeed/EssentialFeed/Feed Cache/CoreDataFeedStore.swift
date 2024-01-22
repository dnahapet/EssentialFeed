//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-01-22.
//

import Foundation

public final class CoreDataFeedStore: FeedStore {

    public init() {}

    public func deleteCache(completion: @escaping DeletionCompletion) {
        
    }

    public func insert(_ feed: [LocalFeedImage], _ timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}
