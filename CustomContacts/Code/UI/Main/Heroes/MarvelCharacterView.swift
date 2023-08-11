//
//  MarvelCharacterView.swift
//  CustomContacts
//
//  Created by Aqsa Masood on 03/01/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import NukeUI
import SwiftUI

struct MarvelCharacterView: View {
	let character: MarvelCharacter

	var body: some View {
		ZStack {
			imageView
			infoView
		}
	}

	@ViewBuilder private var imageView: some View {
		if
			let urlString = character.imageString,
			let url = URL(string: urlString)
		{
			LazyImage(
				source: ImageRequest(url: url),
				resizingMode: .aspectFill
			)
			.frame(maxWidth: .infinity)
			.frame(height: 200)
			.clipped()
			.accessibilityLabel(character.name)
			.accessibilityAddTraits(.isImage)
		}
	}

	private var infoView: some View {
		VStack(spacing: .zero) {
			Spacer()
			VStack(alignment: .leading, spacing: .zero) {
				Text(character.name)
					.font(.title)
					.accessibilityAddTraits(.isHeader)
				Spacer()
					.frame(height: 6)
				Text(character.description ?? "No description available")
					.font(.subheadline)
					.accessibilityAddTraits(.isStaticText)
			}
			.foregroundColor(Color.white)
		}
	}
}

struct MarvelCharacterView_Previews: PreviewProvider {
	static var previews: some View {
		MarvelCharacterView(
			character: MarvelCharacter.example
		)
	}
}
