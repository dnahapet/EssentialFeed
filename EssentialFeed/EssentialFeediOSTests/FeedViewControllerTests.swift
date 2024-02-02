//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Davit Nahapetyan on 2024-02-02.
//

import XCTest
import UIKit

final class FeedViewController {

    init(loader: FeedViewControllerTests.LoaderSpy) {
    }
}

class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }

    // MARK: Helpers

    class LoaderSpy {
        var loadCallCount = 0
    }
}
