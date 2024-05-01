//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-02-19.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?

    public var hasLocation: Bool {
        return location != nil
    }
}
