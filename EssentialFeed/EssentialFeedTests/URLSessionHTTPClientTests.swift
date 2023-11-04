//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Davit Nahapetyan on 2023-11-04.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    private let session: URLSession

    init(_ session:URLSession) {
        self.session = session
    }

    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in
            
        }
    }
}

class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "http://some-url.com")!
        let session = URLSessionSpy()

        let sut = URLSessionHTTPClient(session)
        sut.get(from:url)

        XCTAssertEqual(session.requestedURLs, [url])
    }

    private class URLSessionSpy: URLSession {
        var requestedURLs = [URL]()

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            requestedURLs.append(url)
            return FakeURLSessionDataTask()
        }
    }

    private class FakeURLSessionDataTask:URLSessionDataTask {
        
    }
}
