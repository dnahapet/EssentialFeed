//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-03-11.
//

import Foundation

public struct ResourceErrorViewModel {
    public let message: String?
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
