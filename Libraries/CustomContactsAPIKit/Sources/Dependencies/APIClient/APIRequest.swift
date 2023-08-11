//
//  APIRequest.swift
//  CustomContactsAPIKit
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation

struct APIRequest<Response: Decodable> {
	var path: String
	var query: [String: String]?
	var method: Method = .get
	var headers: [String: String]?
	var decoder: JSONDecoder = .init()

	enum Method {
		case get
		case post(Data)
		case put(Data)

		var stringValue: String {
			switch self {
			case .get:
				return "GET"
			case .post:
				return "POST"
			case .put:
				return "PUT"
			}
		}
	}
}

struct EmptyResponse: Decodable {}
typealias NoResponseRequest = APIRequest<EmptyResponse>

extension APIRequest: CustomStringConvertible {
	var description: String {
"""
	Request(
	path: \(path),
	query: \(query ?? [:]),
	method: \(method),
	headers: \(headers?.mapValues { $0.description.localizedCaseInsensitiveContains("Bearer") ? "***" : $0 } ?? [:])
)
"""
	}
}
