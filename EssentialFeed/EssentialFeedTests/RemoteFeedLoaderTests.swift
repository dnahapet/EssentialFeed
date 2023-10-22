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

        XCTAssertNil(client.requestedURL)
    }

    func test_load_withRequestURL() {
        let (client, sut) = makeSUT(url: URL(string: "http://given-url.com")!)

        sut.load()

        XCTAssertNotNil(client.requestedURL)
    }
}

//MARK: - Helpers

func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (HTTPClientSpy, RemoteFeedLoader) {
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(client: client, url: url)
    return (client, sut)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?

    func get(from url: URL) {
        requestedURL = url
    }
}
