//
//  MarvelCharacterList.swift
//  CustomContactsAPIKit
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
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
