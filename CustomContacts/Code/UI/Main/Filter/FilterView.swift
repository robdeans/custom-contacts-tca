//
//  FilterView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/30/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

struct FilterView: View {
	@State private var isExpanded = false

	let filterQueries: [FilterQuery]
	let onAddQueryTapped: (FilterQuery) -> Void
	let onRemoveQueryTapped: (FilterQuery) -> Void
	let onClearTapped: () -> Void

	var body: some View {
		DisclosureGroup(
			isExpanded: $isExpanded,
			content: { filterContent },
			label: { toggleExpandButton }
		)
		.padding(.horizontal, Constants.UI.Padding.default)
	}

	private var filterContent: some View {
		VStack {
			Text(Localizable.Filter.Content.title)
				.frame(maxWidth: .infinity, alignment: .leading)
			Group {
				ForEach(Array(filterQueries.enumerated()), id: \.element.id) { index, query in
					FilterRowView(filterQuery: query, isFirstRow: index == 0)
						.swipeable(
							onDelete: {
								withAnimation {
									onRemoveQueryTapped(query)
								}
							}
						)
				}

				HStack {
					Button(Localizable.Common.Actions.clear) {
						withAnimation {
							onClearTapped()
						}
					}
					.frame(maxWidth: .infinity)

					Button(Localizable.Filter.Content.addFilter) {
						withAnimation {
							onAddQueryTapped(FilterQuery(isFirstQuery: filterQueries.isEmpty))
						}
					}
					.frame(maxWidth: .infinity)
				}
				.padding(.top, Constants.UI.Padding.default)
			}
		}
	}

	private var toggleExpandButton: some View {
		Button(
			action: {
				withAnimation {
					isExpanded.toggle()
				}
			},
			label: { Text(Localizable.Filter.Content.expandSection) }
		)
	}
}

// MARK: - Preview Content
#Preview {
	let filterQueries: [FilterQuery] = [
		FilterQuery(isFirstQuery: true),
		FilterQuery(isFirstQuery: false),
	]
	return FilterView(
		filterQueries: filterQueries,
		onAddQueryTapped: { _ in },
		onRemoveQueryTapped: { _ in },
		onClearTapped: {}
	)
}
