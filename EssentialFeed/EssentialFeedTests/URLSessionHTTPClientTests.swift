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

    init(_ session: URLSession = .shared) {
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
    
    override func setUp() {
        super.setUp()

        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()

        URLProtocolStub.stopInterceptingRequests()
    }

    func test_getFromURL_performsGETRequestWithURL() {
        let url = URL(string: "http://some-url.com")!
        let exp = expectation(description: "Wait for expectation")

        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }

        makeSUT().get(from: url) { _ in }

        wait(for: [exp], timeout: 0.1)
    }

    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "http://some-url.com")!
        let error = NSError(domain: "Any Error", code: 1, userInfo: nil)
        URLProtocolStub.stub(data:nil, response:nil, error:error)

        let exp = expectation(description: "Wait for expectation")

        makeSUT().get(from:url) { result in
            switch result {
            case let .failure(resultedError as NSError):
                XCTAssertEqual(resultedError.domain, error.domain)
            default:
                XCTFail("Expected \(error), got \(result) instead")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> URLSessionHTTPClient {
        return URLSessionHTTPClient()
    }

    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?

        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: NSError?
        }

        static func stub(data: Data?, response: URLResponse?, error: NSError?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        static func observeRequest(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }

        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }

            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}
    }
}