//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-05-06.
//

import Foundation

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
