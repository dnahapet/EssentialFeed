//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-12-04.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
