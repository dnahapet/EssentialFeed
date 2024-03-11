//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-03-11.
//

import Foundation

public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
