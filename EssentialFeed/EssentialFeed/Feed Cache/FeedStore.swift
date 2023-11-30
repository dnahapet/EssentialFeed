//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-11-30.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (NSError?) -> Void
    typealias InsertionCompletion = (NSError?) -> Void

    func deleteCache(completion: @escaping DeletionCompletion)
    func insert(_ items: [FeedItem], _ timestamp: Date, completion: @escaping InsertionCompletion)
}
