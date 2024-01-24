//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-10-17.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>

    func load(completion: @escaping ((Result) -> Void))
}
