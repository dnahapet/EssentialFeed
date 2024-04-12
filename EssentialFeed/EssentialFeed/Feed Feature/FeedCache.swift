//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-04-12.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
