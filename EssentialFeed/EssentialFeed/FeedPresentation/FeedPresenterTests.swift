//
//  FeedPresenterTests.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-03-03.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()

        _ = FeedPresenter(view: view)

        XCTAssertTrue(view.messages.isEmpty, "Expected view not receive any message")
    }

    // MARK: - Helpers

    private class ViewSpy {
        let messages = [Any]()
    }
}
