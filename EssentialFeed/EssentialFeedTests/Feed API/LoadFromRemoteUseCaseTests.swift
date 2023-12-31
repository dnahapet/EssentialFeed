//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Davit Nahapetyan on 2023-10-20.
//

import XCTest
import EssentialFeed

class LoadFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestURL() {
        let (client, _) = makeSUT()

        XCTAssert(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "http://given-url.com")!
        let (client, sut) = makeSUT(url: url)

        sut.load() { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http://given-url.com")!
        let (client, sut) = makeSUT(url: url)

        sut.load() { _ in }
        sut.load() { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (client, sut) = makeSUT()

        expect(sut, toReceive: failure(.connectivity)) {
            let anyError = NSError(domain: "Any Error", code: 1, userInfo: nil)
            client.complete(with: anyError)
        }
    }

    func test_load_deliversErrorOnClientNon200HTTPStatusCode() {
        let (client, sut) = makeSUT()

        let samples = [199, 201, 300, 400, 500].enumerated()
        samples.forEach { index, code in
            expect(sut, toReceive: failure(.invalidData)) {
                client.complete(with: code, at: index)
            }
        }
    }

    func test_load_deliversErrorOnClientInvalidJSONList() {
        let (client, sut) = makeSUT()

        expect(sut, toReceive: failure(.invalidData)) {
            let invalidJSONList = Data("Invalid JSON".utf8)
            client.complete(with: 200, data: invalidJSONList)
        }
    }
    
    func test_load_deliversErrorOnClientEmptyJSONList() {
        let (client, sut) = makeSUT()

        expect(sut, toReceive: failure(.invalidData)) {
            let emptyJSONList = Data("\"items\":[]".utf8)
            client.complete(with: 200, data: emptyJSONList)
        }
    }

    func test_load_deliversItemsOnClientValidJSONList() {
        let (client, sut) = makeSUT()

        let item1 = makeFeedItem(id: UUID(),
                                 imageURL: URL(string: "http://some-url.com")!)
        let item2 = makeFeedItem(id: UUID(),
                                 description: "A description",
                                 location: "A location",
                                 imageURL: URL(string: "http://another-url.com")!)
        expect(sut, toReceive: .success([item1.model, item2.model])) {
            let data = try! JSONSerialization.data(withJSONObject: ["items": [item1.json, item2.json]])
            client.complete(with: 200, data: data)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string:"http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(client: client, url: url)

        var capturedResults = [RemoteFeedLoader.Result]()
        sut?.load() { capturedResults.append($0) }

        sut = nil
        client.complete(with: 200, data: makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    //MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "http://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (HTTPClientSpy, RemoteFeedLoader) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)

        trackForMemoryLeaks(sut, file:file, line:line)
        trackForMemoryLeaks(client, file:file, line:line)

        return (client, sut)
    }

    private func makeFeedItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model:FeedImage, json:[String: Any]) {
        let item = FeedImage(id: id,
                            description: description,
                            location: location,
                            url: imageURL)
        let itemJSON = [
            "id": item.id.uuidString,
            "description": item.description,
            "location": item.location,
            "image": item.url.absoluteString
        ]
        return (item, itemJSON as [String : Any])
    }

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }

    private func expect(_ sut: RemoteFeedLoader, toReceive expectedResult: RemoteFeedLoader.Result, _ action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {

        let exp = expectation(description: "Wait for load completion")

        sut.load() { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), but got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 0.1)
    }

    private func failure(_ error:RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }
}

private class HTTPClientSpy: HTTPClient {
    var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()

    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }

    func get(from url: URL, completion: @escaping ((HTTPClientResult) -> Void)) {
        messages.append((url, completion))
    }

    func complete(with error: NSError, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }

    func complete(with statusCode: Int, data: Data = Data(), at index: Int = 0) {
        let response = HTTPURLResponse(url: requestedURLs[index],
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)!
        messages[index].completion(.success(data, response))
    }
}
