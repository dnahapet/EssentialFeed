//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-10-17.
//

import Foundation

public typealias FeedLoadResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping ((FeedLoadResult) -> Void))
}
