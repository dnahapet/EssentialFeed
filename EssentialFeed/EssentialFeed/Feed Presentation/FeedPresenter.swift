//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-03-11.
//

import Foundation

public final class FeedPresenter {
    
    public static var title: String {
        NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the Feed view")
    }
}
