//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-11-30.
//

import Foundation

public final class LocalFeedLoader {
    let store: FeedStore
    let currentDate: () -> Date
    let calendar = Calendar(identifier: .gregorian)

    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }

    private var maxCacheAgeInDays: Int {
        return 7
    }

    private func validateTimestamp(_ timestamp: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return currentDate() < maxCacheAge
    }
}

extension LocalFeedLoader {
    public typealias SaveResult = Error?

    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCache() { [weak self] error in
            guard let self = self else { return }

            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            }
            else {
                self.cache(feed, with:completion)
            }
        }
    }

    private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), self.currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}

extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = FeedLoadResult

    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .found(localFeedImages, timestamp) where self.validateTimestamp(timestamp):
                completion(.success(localFeedImages.toModels()))

            case .found, .empty:
                completion(.success([]))
            }
        }
    }
}

extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve() { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                self.store.deleteCache() { _ in }

            case let .found(_, timestamp) where !self.validateTimestamp(timestamp):
                self.store.deleteCache() { _ in }

            case .found, .empty:
                break
            }
        }
    }
}

extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return self.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}

extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return self.map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}
