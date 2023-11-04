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

    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "http://some-url.com")!
        let task = URLSessionDataTaskSpy()
        let session = URLSessionSpy()
        session.stub(url:url, task:task)

        let sut = URLSessionHTTPClient(session)
        sut.get(from:url) { _ in }

        XCTAssertEqual(task.resumeCount, 1)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "http://some-url.com")!
        let session = URLSessionSpy()
        let error = NSError(domain: "Any Error", code: 1, userInfo: nil)
        session.stub(url:url, error:error)

        let sut = URLSessionHTTPClient(session)
        
        let exp = expectation(description: "Wait for expectation")
        sut.get(from:url) { result in
            switch result {
            case let .failure(resultedError):
                XCTAssertEqual(resultedError as NSError, error)
            default:
                XCTFail("Expected \(error), got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    // MARK: - Helpers

    private class URLSessionSpy: URLSession {
        private var stubs = [URL : Stub]()
        
        private struct Stub {
            let task: URLSessionDataTask
            let error: NSError?
        }

        func stub(url: URL, task: URLSessionDataTask = FakeURLSessionDataTask(), error: NSError? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task
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
