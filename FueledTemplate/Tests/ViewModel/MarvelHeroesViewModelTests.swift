//
//  MarvelHeroesViewModelTests.swift
//  FueledTemplateTests
//
//  Created by Aqsa Masood on 04/01/23.
//  Copyright © 2023 Fueled. All rights reserved.
//

import Dependencies
import XCTest
import FueledTemplateAPIKit

@testable import FueledTemplate

@MainActor
final class MarvelHeroesViewModelTests: XCTestCase {
	private var viewModel: MarvelHeroesViewModel!

    override func setUp() {
		self.viewModel = MarvelHeroesViewModel()
    }

	func testSuccessFetchData() async {
		/*
		 Task.yield() can be used in this scenario, but it may not be the optimal approach for handling such cases.
		 The goal is to ensure that the loadData() task in the viewModel is executed before the below tests.
		 Sleeping for some time can also be done to allow for the task to complete, but these solutions may not be convenient.
		 Swift Concurrency should provide a more streamlined way of running async tasks in a synchronized manner for testing purposes.
		 More context on this topic can be found in the following forum discussion: https://forums.swift.org/t/reliably-testing-code-that-adopts-swift-concurrency/57304.
		 Additionally, there is a promising pull request for the swift-dependencies library that could potentially address this issue: https://github.com/pointfreeco/swift-dependencies/pull/84.
		*/
		await Task.yield()
		XCTAssertTrue(!viewModel.isLoading)
		XCTAssertEqual(viewModel.superHeroes.count, 1)
	}

	func testNavigateToMarvelHeroDetailsView() {
		let character = MarvelCharacter.example
		viewModel.navigateToMarvelHeroDetailsView(character: character)
		XCTAssertNotNil(viewModel.marvelHeroDetailsViewModel)
	}
}
