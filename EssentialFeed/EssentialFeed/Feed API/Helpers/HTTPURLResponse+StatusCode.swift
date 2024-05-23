//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-04-06.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
