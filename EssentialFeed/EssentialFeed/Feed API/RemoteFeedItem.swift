//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-12-04.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
