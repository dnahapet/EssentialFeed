//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-10-22.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping ((Error) -> Void))
}

public final class RemoteFeedLoader {
    var httpClient: HTTPClient
    var httpURL: URL

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(client: HTTPClient, url: URL) {
        httpClient = client
        httpURL = url
    }

    public func load(completion: @escaping ((Error) -> Void)) {
        httpClient.get(from: httpURL) { _ in
            completion(.connectivity)
        }
    }
}
