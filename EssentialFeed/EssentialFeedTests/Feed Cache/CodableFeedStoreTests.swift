//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Davit Nahapetyan on 2024-01-09.
//

import XCTest
import EssentialFeed

class CodableFeedStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        setupEmptyStoreState()
    }

    override func tearDown() {
        super.tearDown()

        undoStoreSideEffects()
    }

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()

        expect(sut, toRetrieve: .empty)
    }

    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()

        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueFeed().localModels
        let timestamp = Date()

        insert((feed, timestamp), into: sut)

        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp))
    }

    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueFeed().localModels
        let timestamp = Date()

        insert((feed, timestamp), into: sut)

        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timestamp))
    }

    func test_retrieve_deliversFailureOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)

        try! "Invalid Data".write(to: storeURL, atomically: true, encoding: .utf8)

        expect(sut, toRetrieve: .failure(anyNSError()))
    }

    func test_retrieve_hasNoSideEffectsOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)

        try! "Invalid Data".write(to: storeURL, atomically: true, encoding: .utf8)

        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }

    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSUT()

        let firstInsertionError = insert((feed: uniqueFeed().localModels, timestamp: Date()), into: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert cache successfully")

        let latestFeed = uniqueFeed().localModels
        let latestTimestamp = Date()
        let latestInsertionError = insert((feed: latestFeed, timestamp: latestTimestamp), into: sut)

        XCTAssertNil(latestInsertionError, "Expected to override cache successfully")
        expect(sut, toRetrieve: .found(feed: latestFeed, timestamp: latestTimestamp))
    }

    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)

        let feed = uniqueFeed().localModels
        let timestamp = Date()
        let insertionError = insert((feed: feed, timestamp: timestamp), into: sut)

        XCTAssertNotNil(insertionError, "Expected cache insertion to fail")
    }

    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()

        let deletionError = deleteCache(from: sut)

        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
        expect(sut, toRetrieve: .empty)
    }

    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()
        insert((uniqueFeed().localModels, Date()), into: sut)

        let deletionError = deleteCache(from: sut)

        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
        expect(sut, toRetrieve: .empty)
    }

    func test_delete_deliversFailureOnDeletionError() {
        let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)

        let deletionError = deleteCache(from: sut)

        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
        expect(sut, toRetrieve: .empty)
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()

        var operationsInOrder = [XCTestExpectation]()
        let op1 = expectation(description: "Operation1")
        sut.insert(uniqueFeed().localModels, Date()) { _ in
            operationsInOrder.append(op1)
            op1.fulfill()
        }

        let op2 = expectation(description: "Operation2")
        sut.deleteCache() { _ in
            operationsInOrder.append(op2)
            op2.fulfill()
        }

        let op3 = expectation(description: "Operation3")
        sut.insert(uniqueFeed().localModels, Date()) { _ in
            operationsInOrder.append(op3)
            op3.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)

        XCTAssertEqual(operationsInOrder, [op1, op2, op3], "Expected operations ti run serially")
    }

    // MARK: - Helpers

    private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let sut = CodableFeedStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    @discardableResult
    private func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), into sut: FeedStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        let exp = expectation(description: "Wait for cache insertion completion")
        var error: Error? = nil
        sut.insert(cache.feed, cache.timestamp) { insertionError in
            error = insertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return error
    }

    private func expect(_ sut: FeedStore, toRetrieve expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval completion")

        sut.retrieve { actualResult in
            switch (actualResult, expectedResult) {
            case (.empty, .empty),
                (.failure, .failure):
                break
            case let (.found(actualFeed, actualTimestamp), .found(expectedFeed, expectedTimestamp)):
                XCTAssertEqual(actualFeed, expectedFeed, file: file, line: line)
                XCTAssertEqual(actualTimestamp, expectedTimestamp, file: file, line: line)
            default:
                XCTFail("Expected to retrieve \(expectedResult) and \(actualResult) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    private func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }

    private func deleteCache(from sut: FeedStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        let exp = expectation(description: "Wait for cache deletion completion")
        var error: Error? = nil
        sut.deleteCache { deletionError in
            error = deletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return error
    }

    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }

    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }

    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }

    private func testSpecificStoreURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }

    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
