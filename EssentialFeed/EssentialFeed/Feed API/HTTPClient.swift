//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2023-10-27.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping ((HTTPClientResult) -> Void))
}
