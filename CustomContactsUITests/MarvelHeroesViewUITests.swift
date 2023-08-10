//
//  MarvelHeroesViewUITests.swift
//  CustomContacts
//
//  Created by Vinay Kharb on 02/05/23.
//  Copyright © 2023 Fueled. All rights reserved.
//

import XCTest

// MARK: Initial Setup
final class MarvelHeroesViewUITests: XCTestCase {
	let app = TemplateApp()

	override func setUpWithError() throws {
		continueAfterFailure = false
		app.launch()
	}
}

// MARK: Tests
extension MarvelHeroesViewUITests {
	func testScrollView() {
		let scrollView = app.scrollView()

		scrollView.swipeUp(velocity: .slow)
		scrollView.swipeUp()
		scrollView.swipeDown(velocity: .fast)

		heroesListFirstItem.tap()
	}
}

// MARK: Items
extension MarvelHeroesViewUITests {
	var heroesListFirstItem: XCUIElement {
		app.staticText(id: ObjectNames.heroesListFirstItem.rawValue)
	}
}

extension MarvelHeroesViewUITests {
	enum ObjectNames: String {
		case heroesListFirstItem = "HeroesListItem0"
	}
}
