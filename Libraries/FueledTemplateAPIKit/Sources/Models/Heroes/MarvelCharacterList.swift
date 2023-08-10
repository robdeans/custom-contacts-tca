//
//  MarvelCharacterList.swift
//  FueledTemplateAPIKit
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import Foundation

struct MarvelCharacterList: Codable {
	enum CodingKeys: String, CodingKey {
		case results
	}
	let results: [MarvelCharacter]
}

struct ResponseData: Codable {
	enum CodingKeys: String, CodingKey {
		case data
	}
	let data: MarvelCharacterList
}
