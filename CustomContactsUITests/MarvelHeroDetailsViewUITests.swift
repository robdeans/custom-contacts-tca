//
//  MarvelHeroDetailsViewUITests.swift
//  CustomContacts
//
//  Created by Vinay Kharb on 02/05/23.
//  Copyright © 2023 Fueled. All rights reserved.
//

import XCTest

// MARK: Initial Setup
final class MarvelHeroDetailsViewUITests: XCTestCase {
	let app = TemplateApp()

	override func setUpWithError() throws {
		continueAfterFailure = false
		app.launch()
	}

	private func navigateToMarvelHeroDetailsView() {
		heroesListFirstItem.tap()
	}
}

// MARK: Tests
extension MarvelHeroDetailsViewUITests {
	func testHeroDetails() {
		let parentViewExists1 = parentView.waitForExistence(timeout: 2)
		XCTAssertFalse(parentViewExists1, "Has not navigated to hero details view")

		navigateToMarvelHeroDetailsView()

		let parentViewExists2 = parentView.waitForExistence(timeout: 2)
		XCTAssertTrue(parentViewExists2, "Has navigated to hero details view")
	}
}

// MARK: Items
extension MarvelHeroDetailsViewUITests {
	var parentView: XCUIElement {
		app.staticText(id: ObjectNames.marvelHeroDetailsParentView.rawValue)
	}

	var heroesListFirstItem: XCUIElement {
		app.staticText(id: MarvelHeroesViewUITests.ObjectNames.heroesListFirstItem.rawValue)
	}
}

extension MarvelHeroDetailsViewUITests {
	enum ObjectNames: String {
		case marvelHeroDetailsParentView = "MarvelHeroDetailsParentView"
	}
}
