//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Davit Nahapetyan on 2023-12-13.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "Any Error", code: 1, userInfo: nil)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
