//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-04-06.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
