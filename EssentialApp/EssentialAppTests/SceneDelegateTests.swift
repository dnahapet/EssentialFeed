//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by Davit Nahapetyan on 2024-04-15.
//

import XCTest
import EssentialFeediOS
@testable import EssentialApp

class SceneDelegateTests: XCTestCase {
    
    func test_sceneWillConnectToSession_configuresRootView() {
        let sut = SceneDelegate()
        sut.window = UIWindow()
        
        sut.configureRootView()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is FeedViewController, "Expected a feed view controller as top controller, got \(String(describing: topController)) instead")
    }
}
