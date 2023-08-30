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
	let filterQueries: [FilterQuery]
	let onAddQueryTapped: (FilterQuery) -> Void
	let onRemoveQueryTapped: (FilterQuery) -> Void

	var body: some View {
		VStack {
			Text("Show me all contacts who are...")
				.frame(maxWidth: .infinity, alignment: .leading)
			Group {
				ForEach(Array(filterQueries.enumerated()), id: \.element.id) { index, query in
					FilterRowView(filterQuery: query, isFirstRow: index == 0)
				}

				Button("Add filter") {
					onAddQueryTapped(FilterQuery())
				}
				.padding(.top, Constants.UI.Padding.default)
			}
		}
		.padding(.horizontal, Constants.UI.Padding.default)
	}
}

let filterQueries: [FilterQuery] = [
	FilterQuery(),
	FilterQuery(),
]

#Preview {
	MainActor.assumeIsolated {
		let container = previewContainer
		return FilterView(
			filterQueries: filterQueries,
			onAddQueryTapped: { _ in },
			onRemoveQueryTapped: { _ in }
		)
		.modelContainer(container)
	}
}

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

struct FilterRowView: View {
	@StateObject var filterQuery: FilterQuery
	let isFirstRow: Bool

	@Environment(\.modelContext) private var modelContext
	@Query(sort: [SortDescriptor(\ContactGroup.name)])
	private var groups: [ContactGroup]

	var body: some View {
		Group {
			if isFirstRow {
				firstRowContentView
			} else {
				rowContentView
			}
		}
		.border(filterQuery.group?.color ?? .clear)
	}
}

// MARK: - View Components
extension FilterRowView {
	@ViewBuilder
	private var firstRowContentView: some View {
		HStack {
			pickerView(for: FilterQuery.Relation.allCases, selected: $filterQuery.relation)

			Text("within the group")

			groupsPickerView
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}

	@ViewBuilder
	private var rowContentView: some View {
		VStack {
			HStack {
				pickerView(for: FilterQuery.AndOr.allCases, selected: $filterQuery.andOr)

				Text("contacts who are")

				pickerView(for: FilterQuery.Relation.allCases, selected: $filterQuery.relation)
			}
			.frame(maxWidth: .infinity, alignment: .leading)

			HStack {
				Text("within the group")

				groupsPickerView
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
	}

	private var groupsPickerView: some View {
		Picker("", selection: $filterQuery.group) {
			ForEach(groups) {
				Text($0.name)
					.tag($0 as ContactGroup?)
				// cast as optional to handle `nil` default value
			}
		}
	}

	private func pickerView<T: PickerProtocol>(for collection: [T], selected: Binding<T>) -> some View {
		Picker("", selection: selected) {
			ForEach(collection) {
				Text($0.title)
					.tag($0)
			}
		}
	}
}

private protocol PickerProtocol: Identifiable, Hashable {
	var title: String { get }
}

final class FilterQuery: ObservableObject, Identifiable {
	enum Relation: String, CaseIterable, PickerProtocol {
		case included
		case excluded

		var title: String {
			switch self {
			case .included:
				return "Found"
			case .excluded:
				return "Not found"
			}
		}

		var id: String {
			rawValue
		}
	}

	enum AndOr: String, CaseIterable, PickerProtocol {
		case and
		case or

		var title: String {
			rawValue.capitalized
		}

		var id: String {
			rawValue
		}
	}

	@Published var group: ContactGroup?
	@Published var relation = Relation.included
	@Published var andOr = AndOr.and
	let id = UUID().uuidString
}
