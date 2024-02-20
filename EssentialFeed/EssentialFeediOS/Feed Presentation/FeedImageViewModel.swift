//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-02-19.
//

import Foundation

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool

    var hasLocation: Bool {
        return location != nil
    }
}
