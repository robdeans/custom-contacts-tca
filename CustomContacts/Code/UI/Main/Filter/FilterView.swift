//
//  FilterView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/30/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import SwiftData
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
			Text("Show me all contacts who are...")
				.frame(maxWidth: .infinity, alignment: .leading)
			Group {
				ForEach(Array(filterQueries.enumerated()), id: \.element.id) { index, query in
					FilterRowView(filterQuery: query, isFirstRow: index == 0)
				}

				HStack {
					Button("Clear") {
						withAnimation {
							onClearTapped()
						}
					}
					.frame(maxWidth: .infinity)

					Button("Add filter") {
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
			label: { Text("Venn with friends!") }
		)
	}
}

// MARK: - Preview Content
#Preview {
	MainActor.assumeIsolated {
		let container = previewContainer
		return FilterView(
			filterQueries: filterQueries,
			onAddQueryTapped: { _ in },
			onRemoveQueryTapped: { _ in },
			onClearTapped: {}
		)
		.modelContainer(container)
	}
}

private let filterQueries: [FilterQuery] = [
	FilterQuery(isFirstQuery: true),
	FilterQuery(isFirstQuery: false),
]

@MainActor
private let previewContainer: ModelContainer = {
	do {
		let container = try ModelContainer(for: ContactGroup.self, ModelConfiguration(inMemory: true))
		ContactGroup.mockArray.forEach { container.mainContext.insert($0) }
		return container
	} catch {
		fatalError("Failed to create container")
	}
}()
