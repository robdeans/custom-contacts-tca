//
//  MarvelHeroesViewModel.swift
//  CustomContacts
//
//  Created by Aqsa Masood on 03/01/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Combine
import CryptoKit
import Dependencies
import CustomContactsAPIKit
import FueledUtilsCombine

@MainActor
final class MarvelHeroesViewModel: ObservableObject {
	@Published var superHeroes: [MarvelCharacter] = []
	@Published var isLoading = false
	@Published var marvelHeroDetailsViewModel: MarvelHeroDetailsViewModel?

	@Dependency(\.marvelHeroesService) var marvelHeroesService

	init() {
		self.loadData()
	}

	func navigateToMarvelHeroDetailsView(character: MarvelCharacter) {
		marvelHeroDetailsViewModel = MarvelHeroDetailsViewModel(character: character)
	}

	@discardableResult
	func loadData() -> Task<Void, Error> {
		self.isLoading = true
		return Task {
			self.superHeroes = try await marvelHeroesService.fetchMarvelHeroes()
			self.isLoading = false
		}
	}
}
