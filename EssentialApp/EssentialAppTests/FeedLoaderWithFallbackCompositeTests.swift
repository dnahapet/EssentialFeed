//
//  FeedLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Davit Nahapetyan on 2024-04-11.
//

import XCTest
import EssentialFeed

class FeedLoaderWithFallbackComposite: FeedLoader {
    private let primary: FeedLoader
    
    init(primary: FeedLoader, fallback: FeedLoader) {
        self.primary = primary
    }
    
    func load(completion: @escaping ((FeedLoader.Result) -> Void)) {
        primary.load(completion: completion)
    }
}

class FeedLoaderWithFallbackCompositeTests: XCTestCase {

    func test_load_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
        let primaryFeed = uniqueFeed()
        let fallbackFeed = uniqueFeed()
        let primaryLoader = LoaderStub(result: .success(primaryFeed))
        let fallbackLoader = LoaderStub(result: .success(fallbackFeed))
        let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        let exp = expectation(description: "Wait for load feed completion")
        
        sut.load { result in
            switch result {
            case let .success(receivedFeed):
                XCTAssertEqual(receivedFeed, primaryFeed)
            default:
                XCTFail("Expected successfully loaded feed, received \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: Helpers
    
    private func uniqueFeed() -> [FeedImage] {
        return [FeedImage(id: UUID(), description: "Any description", location: "Any location", url: URL(string: "https://any-url.com")!)]
    }
    
    private class LoaderStub: FeedLoader {
        private let result: FeedLoader.Result
        
        init(result: FeedLoader.Result) {
            self.result = result
        }
        
        func load(completion: @escaping ((FeedLoader.Result) -> Void)) {
            completion(result)
        }
    }
}
