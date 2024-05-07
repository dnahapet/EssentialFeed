//
//  ImageCommentsEndpoint.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-05-06.
//

import Foundation

public enum ImageCommentsEndpoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/v1/image/\(id)/comments")
        }
    }
}
