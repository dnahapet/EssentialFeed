//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-10-22.
//

import Foundation

public final class RemoteFeedLoader {
    var httpClient: HTTPClient
    var httpURL: URL

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }

    public init(client: HTTPClient, url: URL) {
        httpClient = client
        httpURL = url
    }

    public func load(completion: @escaping ((Result) -> Void)) {
        httpClient.get(from: httpURL) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data, let response):
                completion(FeedItemsMapper.map(data, from:response))
            case.failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
