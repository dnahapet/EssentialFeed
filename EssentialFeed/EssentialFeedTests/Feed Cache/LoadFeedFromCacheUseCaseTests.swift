//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Davit Nahapetyan on 2023-12-08.
//

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()

        sut.load() { _ in }

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError()

        expect(sut, completeWith: .failure(expectedError)) {
            store.completeRetrieval(with: expectedError)
        }
    }

    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()

        expect(sut, completeWith: .success([])) {
            store.completeRetrievalWithEmptyCache()
        }
    }

    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    private func expect(_ sut: LocalFeedLoader, completeWith expectedResult: LocalFeedLoader.LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")

        sut.load() { receivedResult in
            switch (receivedResult, expectedResult) {
            case (let .success(receivedImages), let .success(expectedImages)):
                XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
            case (let .failure(receivedError), let .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError, expectedError as NSError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead")
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "Any Error", code: 1, userInfo: nil)
    }
}
