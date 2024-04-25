//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-10-22.
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(client: client, url: url, mapper: FeedItemsMapper.map)
    }
}
