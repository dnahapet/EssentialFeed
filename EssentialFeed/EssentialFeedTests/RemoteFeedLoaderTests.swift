//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Davit Nahapetyan on 2023-10-20.
//

import XCTest

class RemoteFeedLoader {
    
}

class HTTPClient {
    let requestedURL: URL? = nil
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesnotRequestURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
