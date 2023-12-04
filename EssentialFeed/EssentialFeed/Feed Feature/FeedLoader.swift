//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-10-17.
//

import Foundation

public enum FeedLoadResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping ((FeedLoadResult) -> Void))
}
