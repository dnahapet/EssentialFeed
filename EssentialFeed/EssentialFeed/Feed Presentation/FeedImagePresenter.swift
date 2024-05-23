//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-02-16.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location)
    }
}
