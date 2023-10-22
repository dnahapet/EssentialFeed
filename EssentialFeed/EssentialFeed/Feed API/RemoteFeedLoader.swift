//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-10-22.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteFeedLoader {
    var httpClient: HTTPClient
    var httpURL: URL

    public init(client: HTTPClient, url: URL) {
        httpClient = client
        httpURL = url
    }

    public func load() {
        httpClient.get(from: httpURL)
    }
}
