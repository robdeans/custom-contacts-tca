//
//  FilterRowView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/31/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import Dependencies
import SwiftData
import SwiftUI

struct FilterRowView: View {
	@Dependency(\.contactsRepository) private var contactsRepository

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
			Text(contactsRepository.allContactsGroup.name)
				.tag(contactsRepository.allContactsGroup as ContactGroup?)
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

extension FilterQuery.AndOr: PickerProtocol {
	var title: String {
		rawValue.capitalized
	}
}

extension FilterQuery.Relation: PickerProtocol {
	var title: String {
		switch self {
		case .included:
			return "Found"
		case .excluded:
			return "Not found"
		}
	}
}
