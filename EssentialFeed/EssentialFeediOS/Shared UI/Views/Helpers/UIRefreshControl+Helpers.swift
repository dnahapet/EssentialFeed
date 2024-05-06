//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-03-11.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
