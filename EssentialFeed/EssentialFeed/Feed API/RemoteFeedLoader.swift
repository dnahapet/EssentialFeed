//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-10-22.
//

import Foundation
import CloudKit

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping ((HTTPClientResult) -> Void))
}

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
        httpClient.get(from: httpURL) { result in
            switch result {
            case.failure:
                completion(.failure(.connectivity))
            case .success(let data, let response):
                if response.statusCode == 200 {
                    do {
                        let root = try JSONDecoder().decode(Root.self, from: data)
                        completion(.success(root.items.map({ $0.feedItem })))
                    } catch {
                        completion(.failure(.invalidData))
                    }
                }
                else {
                    completion(.failure(.invalidData))
                }
            }
        }
    }
}

private struct Root: Decodable {
    let items: [Item]
}

private struct Item: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL

    var feedItem: FeedItem {
        return FeedItem(id: id, description: description, location: location, imageURL: image)
    }
}