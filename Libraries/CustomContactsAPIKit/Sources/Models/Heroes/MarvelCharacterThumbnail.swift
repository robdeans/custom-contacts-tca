//
//  MarvelCharacterThumbnail.swift
//  CustomContactsAPIKit
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation

public struct MarvelCharacterThumbnail: Codable {
	enum CodingKeys: String, CodingKey {
		case path
		case ext = "extension"
	}
	public let path: String?
	public let ext: String?

	public init(path: String?, ext: String?) {
		self.path = path
		self.ext = ext
	}
}
