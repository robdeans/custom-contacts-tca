//
//  MarvelCharacterThumbnail.swift
//  FueledTemplateAPIKit
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
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
