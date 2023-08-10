//
//  MarvelHeroesService.swift
//  CustomContactsAPIKit
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import ArkanaKeys
import Dependencies
import Foundation
import CustomContactsHelpers

public struct MarvelHeroesService {
	private static var sharedQueryItems: [String: String]? = {
		let timestamp = Date().timeIntervalSince1970
		let hash = "\(timestamp)" + ArkanaKeys.Global().marvelAPIPrivateKey + ArkanaKeys.Global().marvelAPIPublicKey
		return [
			"apikey": ArkanaKeys.Global().marvelAPIPublicKey,
			"ts": "\(timestamp)",
			"hash": hash.md5,
		]
	}()

	public var fetchMarvelHeroes: () async throws -> [MarvelCharacter]
}

extension DependencyValues {
	public var marvelHeroesService: MarvelHeroesService {
		get { self[MarvelHeroesService.self] }
		set { self[MarvelHeroesService.self] = newValue }
	}
}

// MARK: Live
extension MarvelHeroesService: DependencyKey {
	public static var liveValue = MarvelHeroesService(
		fetchMarvelHeroes: {
			@Dependency(\.apiClient) var apiClient

			let fetchSuperHeroesRequest = APIRequest<ResponseData>(
				path: "v1/public/characters",
				query: sharedQueryItems
			)
			let response = try await apiClient.request(fetchSuperHeroesRequest)
			return response.data.results
		}
	)
}

// MARK: Preview & Tests
extension MarvelHeroesService {
	private static let mockService = MarvelHeroesService(
		fetchMarvelHeroes: {
			let character = MarvelCharacter(
				name: "A.I.M.",
				id: 1011334,
				description: "AIM is a terrorist organization bent on destroying the world.",
				thumbnail: MarvelCharacterThumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/6/20/52602f21f29ec", ext: "jpg")
			)
			return [character]
		}
	)
	public static var previewValue = mockService
	public static var testValue = mockService
}
