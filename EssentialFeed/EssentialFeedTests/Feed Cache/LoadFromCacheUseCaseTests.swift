//
//  LoadFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Davit Nahapetyan on 2023-11-29.
//

import XCTest

class LocalFeedLoader {
    let store: FeedStore
    init(store: FeedStore) {
        self.store = store
    }
}

class FeedStore {
    let deletedCacheCount = 0
}

class LoadFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deletedCacheCount, 0)
    }
}
