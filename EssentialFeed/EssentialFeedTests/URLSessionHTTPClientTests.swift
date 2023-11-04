//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Davit Nahapetyan on 2023-11-04.
//

import XCTest
import EssentialFeed

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionDataTask
}

protocol HTTPSessionDataTask {
    func resume()
}

class URLSessionHTTPClient {
    private let session: HTTPSession

    init(_ session: HTTPSession) {
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
        let session = HTTPSessionSpy()
        session.stub(url:url, task:task)

        let sut = URLSessionHTTPClient(session)
        sut.get(from:url) { _ in }

        XCTAssertEqual(task.resumeCount, 1)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "http://some-url.com")!
        let session = HTTPSessionSpy()
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

    private class HTTPSessionSpy: HTTPSession {
        private var stubs = [URL : Stub]()
        
        private struct Stub {
            let task: HTTPSessionDataTask
            let error: NSError?
        }

        func stub(url: URL, task: HTTPSessionDataTask = FakeURLSessionDataTask(), error: NSError? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }

        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }

    private class FakeURLSessionDataTask: HTTPSessionDataTask {
        func resume() {}
    }
    
    private class URLSessionDataTaskSpy: HTTPSessionDataTask {
        var resumeCount: Int = 0

        func resume() {
            resumeCount += 1
        }
    }
}
