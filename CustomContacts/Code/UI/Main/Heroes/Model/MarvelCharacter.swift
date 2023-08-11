//
//  MarvelCharacter.swift
//  CustomContacts
//
//  Created by Aqsa Masood on 03/01/23.
//  Copyright © 2023 Fueled. All rights reserved.
//

import Foundation

struct MarvelCharacter: Codable, Identifiable {
	let name: String
	let id: Int
	let description: String?
	let thumbnail: MarvelCharacterThumbnail

	var imageString: String? {
		guard
			let path = thumbnail.path,
			let ext = thumbnail.ext
		else {
			return nil
		}
		return path + "." + ext
	}
}

extension MarvelCharacter: Equatable {
	static func == (lhs: MarvelCharacter, rhs: MarvelCharacter) -> Bool {
		lhs.id == rhs.id
	}
}

extension MarvelCharacter {
	static var example: MarvelCharacter {
		MarvelCharacter(
			name: "A.I.M",
			id: 102123,
			description: "AIM is a terrorist organization bent on destroying the world.",
			thumbnail: MarvelCharacterThumbnail(path: "", ext: "")
		)
	}
}
