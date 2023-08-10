//
//  URLRequest+CURL.swift
//  FueledTemplateAPIKit
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import Foundation

extension URLRequest {
	public var curlRepresentation: String {
		var representation = "curl -L -X \(httpMethod ?? "GET")"

		representation += (allHTTPHeaderFields ?? [:]).map { " -H \"\($0.key): \($0.value)\"" }.joined()
		representation += " \"\(url?.absoluteString ?? "")\""

		if httpMethod != "GET", let body = httpBody.flatMap({ String(data: $0, encoding: .utf8) }), !body.isEmpty {
			representation += " -d \"\(body.replacingOccurrences(of: "\"", with: "\\\""))\""
		}

		return representation
	}
}
