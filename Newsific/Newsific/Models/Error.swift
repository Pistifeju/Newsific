//
//  Error.swift
//  Newsific
//
//  Created by István Juhász on 2022. 08. 05..
//

import Foundation

enum NetworkError: Error {
    case serverError
    case decodingError
}
