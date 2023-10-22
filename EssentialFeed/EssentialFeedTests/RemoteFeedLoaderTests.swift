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

        sut.load()

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http://given-url.com")!
        let (client, sut) = makeSUT(url: url)

        sut.load()
        sut.load()

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
}

//MARK: - Helpers

func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (HTTPClientSpy, RemoteFeedLoader) {
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(client: client, url: url)
    return (client, sut)
}

class HTTPClientSpy: HTTPClient {
    var requestedURLs = [URL]()

    func get(from url: URL) {
        requestedURLs.append(url)
    }
}
