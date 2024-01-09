//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Davit Nahapetyan on 2024-01-09.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }
}

class CodableFeedStoreTests: XCTestCase {

    func test_retieve_deliversEmptyOnEmptyCache() {
        let sut = CodableFeedStore()

        let exp = expectation(description: "Wait for cache retrieval completion")

        sut.retrieve { result in
            switch result {
            case .empty:
                break
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func test_retieve_hasNoSideEffectsOnEmptyCache() {
        let sut = CodableFeedStore()

        let exp = expectation(description: "Wait for cache retrieval completion")

        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                default:
                    XCTFail("Expected empty result twice, got \(firstResult) and \(secondResult) instead")
                }

                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1.0)
    }
}
