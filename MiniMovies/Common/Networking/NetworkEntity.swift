//
//  NetworkEntity.swift
//  MiniMovies
//
//  Created by Ade on 6/13/23.
//

import Foundation

// MARK: - APIError
public struct APIError: Error, Codable {
    let success: Bool?
    let statusCode: Int?
    let statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
