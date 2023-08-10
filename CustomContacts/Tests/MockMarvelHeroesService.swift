//
//  MockMarvelHeroesService.swift
//  CustomContacts
//
//  Created by Aqsa Masood on 04/01/23.
//  Copyright © 2023 Fueled. All rights reserved.
//

import Foundation

final class MockMarvelHeroesService: MarvelHeroesServiceProtocol {
	private static var mockData: MarvelCharacter {
		MarvelCharacter.example
	}

	func fetchSuperHeroes() async throws -> [MarvelCharacter] {
		[MockMarvelHeroesService.mockData]
	}
}
