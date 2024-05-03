//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-02-25.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String.init(describing: T.self)
        let cell = dequeueReusableCell(withIdentifier: identifier) as! T
        return cell
    }
}
