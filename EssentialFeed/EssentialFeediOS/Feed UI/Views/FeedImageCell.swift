//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Davit Nahapetyan on 2024-02-07.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    public var locationContainer: UIView = UIView()
    public var locationLabel: UILabel = UILabel()
    public var descriptionLabel: UILabel = UILabel()
    public var feedImageContainer: UIView = UIView()
    public var feedImageView: UIImageView = UIImageView()

    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()

    var onRetry: (() -> Void)?

    @objc func retryButtonTapped() {
        onRetry?()
    }
}
