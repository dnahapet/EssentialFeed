//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-10-17.
//

import Foundation

public struct FeedItem: Equatable, Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
