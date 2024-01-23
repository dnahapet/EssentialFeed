//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-11-30.
//

import Foundation

public enum RetrieveCachedFeedResult {
    case empty
    case failure(Error)
    case found(feed: [LocalFeedImage], timestamp: Date)
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedFeedResult) -> Void

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedFeed(completion: @escaping DeletionCompletion)

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ feed: [LocalFeedImage], _ timestamp: Date, completion: @escaping InsertionCompletion)

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}
