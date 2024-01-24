//
//  XCTestCase+FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Davit Nahapetyan on 2024-01-21.
//

import EssentialFeed
import XCTest

extension FeedStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.empty))
    }

    func assertThatRetrieveTwiceHasNoSideEffectsOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .success(.empty))
    }

    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let feed = uniqueFeed().localModels
        let timestamp = Date()

        insert((feed, timestamp), to: sut)

        expect(sut, toRetrieve: .success(.found(feed: feed, timestamp: timestamp)))
    }

    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let feed = uniqueFeed().localModels
        let timestamp = Date()

        insert((feed, timestamp), to: sut)

        expect(sut, toRetrieveTwice: .success(.found(feed: feed, timestamp: timestamp)))
    }

    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert((uniqueFeed().localModels, Date()), to: sut)

        XCTAssertNil(insertionError, "Expected to insert cache successfully")
    }

    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueFeed().localModels, Date()), to: sut)

        let insertionError = insert((uniqueFeed().localModels, Date()), to: sut)

        XCTAssertNil(insertionError, "Expected to override cache successfully")
    }

    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueFeed().localModels, Date()), to: sut)

        let latestFeed = uniqueFeed().localModels
        let latestTimestamp = Date()
        insert((latestFeed, latestTimestamp), to: sut)

        expect(sut, toRetrieve: .success(.found(feed: latestFeed, timestamp: latestTimestamp)))
    }

    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)

        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
    }

    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)

        expect(sut, toRetrieve: .success(.empty))
    }

    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueFeed().localModels, Date()), to: sut)

        let deletionError = deleteCache(from: sut)

        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
    }

    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueFeed().localModels, Date()), to: sut)

        deleteCache(from: sut)

        expect(sut, toRetrieve: .success(.empty))
    }

    func assertThatStoreSideEffectsRunSerially(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        var operationsInOrder = [XCTestExpectation]()
        let op1 = expectation(description: "Operation1")
        sut.insert(uniqueFeed().localModels, Date()) { _ in
            operationsInOrder.append(op1)
            op1.fulfill()
        }

        let op2 = expectation(description: "Operation2")
        sut.deleteCachedFeed() { _ in
            operationsInOrder.append(op2)
            op2.fulfill()
        }

        let op3 = expectation(description: "Operation3")
        sut.insert(uniqueFeed().localModels, Date()) { _ in
            operationsInOrder.append(op3)
            op3.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)

        XCTAssertEqual(operationsInOrder, [op1, op2, op3], "Expected operations to run serially")
    }

    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        let exp = expectation(description: "Wait for cache insertion completion")
        var error: Error? = nil
        sut.insert(cache.feed, cache.timestamp) { insertionError in
            error = insertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return error
    }

    func expect(_ sut: FeedStore, toRetrieve expectedResult: FeedStore.RetrievalResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval completion")

        sut.retrieve { actualResult in
            switch (actualResult, expectedResult) {
            case (.success(.empty), .success(.empty)),
                (.failure, .failure):
                break
            case let (.success(.found(actualFeed, actualTimestamp)), .success(.found(expectedFeed, expectedTimestamp))):
                XCTAssertEqual(actualFeed, expectedFeed, file: file, line: line)
                XCTAssertEqual(actualTimestamp, expectedTimestamp, file: file, line: line)
            default:
                XCTFail("Expected to retrieve \(expectedResult) and \(actualResult) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }

    func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: FeedStore.RetrievalResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }

    @discardableResult
    func deleteCache(from sut: FeedStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        let exp = expectation(description: "Wait for cache deletion completion")
        var error: Error? = nil
        sut.deleteCachedFeed { deletionError in
            error = deletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        return error
    }
}
