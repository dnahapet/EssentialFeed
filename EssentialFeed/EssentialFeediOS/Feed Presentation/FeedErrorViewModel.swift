//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-03-11.
//

import Foundation

struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
