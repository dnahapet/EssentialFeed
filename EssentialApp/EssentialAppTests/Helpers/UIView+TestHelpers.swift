//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Davit Nahapetyan on 2024-04-18.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
