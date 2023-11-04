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
        session.dataTask(with: url) { _, _, _ in }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "http://some-url.com")!
        let task = FakeURLSessionDataTask()
        let session = URLSessionSpy(with: task)

        let sut = URLSessionHTTPClient(session)
        sut.get(from:url)

        XCTAssertEqual(session.requestedURLs, [url])
    }
    
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "http://some-url.com")!
        let task = URLSessionDataTaskSpy()
        let session = URLSessionSpy(with: task)

        let sut = URLSessionHTTPClient(session)
        sut.get(from:url)

        XCTAssertEqual(task.resumeCount, 1)
    }
    
    // MARK: - Helpers

    private class URLSessionSpy: URLSession {
        var requestedURLs = [URL]()
        private let dataTask: URLSessionDataTask

        init(with dataTask:URLSessionDataTask) {
            self.dataTask = dataTask
        }

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            requestedURLs.append(url)
            return dataTask
        }
    }

    private class FakeURLSessionDataTask:URLSessionDataTask {
        override func resume() {}
    }
    
    private class URLSessionDataTaskSpy:URLSessionDataTask {
        var resumeCount: Int = 0

        override func resume() {
            resumeCount += 1
        }
    }
}
