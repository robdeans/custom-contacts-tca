//
//  MarvelHeroDetailsView.swift
//  FueledTemplate
//
//  Created by Vinay Kharb on 02/05/23.
//  Copyright © 2023 Fueled. All rights reserved.
//

import FueledTemplateAPIKit
import SwiftUI

struct MarvelHeroDetailsView: View {
	@ObservedObject var viewModel: MarvelHeroDetailsViewModel

	var body: some View {
		VStack(spacing: 16) {
			MarvelCharacterView(character: viewModel.character)
			Text("This is detailed view")
				.font(.subheadline)
				.accessibilityAddTraits(.isStaticText)
		}
		.accessibilityIdentifier("MarvelHeroDetailsParentView")
	}
}

struct MarvelHeroDetailsView_Previews: PreviewProvider {
	static var previews: some View {
		MarvelHeroDetailsView(
			viewModel: MarvelHeroDetailsViewModel(
				character: MarvelCharacter.example
			)
		)
	}
}
