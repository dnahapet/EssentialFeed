//
//  RemoteImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-04-24.
//

import Foundation

public final class RemoteImageCommentsLoader: FeedLoader {
    var httpClient: HTTPClient
    var httpURL: URL

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = FeedLoader.Result

    public init(client: HTTPClient, url: URL) {
        httpClient = client
        httpURL = url
    }

    public func load(completion: @escaping ((Result) -> Void)) {
        httpClient.get(from: httpURL) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success((let data, let response)):
                completion(RemoteImageCommentsLoader.map(data, from: response))
            case.failure:
                completion(.failure(RemoteImageCommentsLoader.Error.connectivity))
            }
        }
    }

    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try ImageCommentsMapper.map(data, from:response)
            return .success(items.toModels())
        }
        catch {
            return .failure(error)
        }
    }
}
