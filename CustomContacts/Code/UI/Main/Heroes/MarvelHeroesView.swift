//
//  MarvelHeroesView.swift
//  CustomContacts
//
//  Created by Aqsa Masood on 03/01/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsHelpers
import SwiftUI

struct MarvelHeroesView: View {
	@StateObject private var viewModel = MarvelHeroesViewModel()

	var body: some View {
		NavigationStackView {
			parentView
				.segue(viewModel: $viewModel.marvelHeroDetailsViewModel) {
					MarvelHeroDetailsView(viewModel: $0)
				}
		}
	}

	@ViewBuilder private var parentView: some View {
		if viewModel.isLoading {
			ProgressView()
		} else {
			contentView
		}
	}

	private var contentView: some View {
		ScrollView {
			LazyVStack {
				titleView
				heroesListView
			}
		}
	}

	private var titleView: some View {
		Text("Sample view to demonstrate accessibility features. Unit tests also included for reference.")
			.font(.title)
			.padding()
			.background(Rectangle().foregroundColor(.accentColor))
			.accessibilityAddTraits(.isHeader)
	}

	private var heroesListView: some View {
		ForEach(viewModel.superHeroes.indices, id: \.self) { index in
			let character = viewModel.superHeroes[index]
			MarvelCharacterView(character: character)
				.accessibilityIdentifier("HeroesListItem\(index)")
				.onTapGesture {
					viewModel.navigateToMarvelHeroDetailsView(character: character)
				}
		}
		.accessibilityLabel("List of \(viewModel.superHeroes.count) super heroes.")
	}
}

struct MarvelHeroesView_Previews: PreviewProvider {
	static var previews: some View {
		MarvelHeroesView()
	}
}
