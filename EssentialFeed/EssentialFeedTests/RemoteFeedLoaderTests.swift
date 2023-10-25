//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Davit Nahapetyan on 2023-10-20.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesnotRequestURL() {
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

    func test_load_deliversErrorOnClientHTTPError() {
        let url = URL(string: "http://given-url.com")!
        let (client, sut) = makeSUT(url: url)

        expect(sut, toReceive: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0, userInfo: nil)
            client.complete(with: clientError as! RemoteFeedLoader.Error)
        }
    }

    func test_load_deliversErrorOnClientNon200HTTPStatusCode() {
        let url = URL(string: "http://given-url.com")!
        let (client, sut) = makeSUT(url: url)

        let samples = [199, 201, 300, 400, 500].enumerated()
        samples.forEach { index, code in
            expect(sut, toReceive: .failure(.invalidData)) {
                client.complete(with: code, at: index)
            }
        }
    }

    func test_load_deliversErrorOnClientInvalidJSONList() {
        let url = URL(string: "http://given-url.com")!
        let (client, sut) = makeSUT(url: url)

        expect(sut, toReceive: .failure(.invalidData)) {
            let invalidJSONList = Data("Invalid JSON".utf8)
            client.complete(with: 200, data: invalidJSONList)
        }
    }
    
    func test_load_deliversErrorOnClientEmptyJSONList() {
        let url = URL(string: "http://given-url.com")!
        let (client, sut) = makeSUT(url: url)

        expect(sut, toReceive: .failure(.invalidData)) {
            let emptyJSONList = Data("\"items\":[]".utf8)
            client.complete(with: 200, data: emptyJSONList)
        }
    }
}

//MARK: - Helpers

func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (HTTPClientSpy, RemoteFeedLoader) {
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(client: client, url: url)
    return (client, sut)
}

func expect(_ sut: RemoteFeedLoader, toReceive result: RemoteFeedLoader.Result, _ action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
    var capturedResults = [RemoteFeedLoader.Result]()
    sut.load() { capturedResults.append($0) }

    action()

    XCTAssertEqual(capturedResults, [result], file:file, line:line)
}

class HTTPClientSpy: HTTPClient {
    var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()

    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }

    func get(from url: URL, completion: @escaping ((HTTPClientResult) -> Void)) {
        messages.append((url, completion))
    }

    func complete(with error: RemoteFeedLoader.Error, at index: Int = 0) {
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
