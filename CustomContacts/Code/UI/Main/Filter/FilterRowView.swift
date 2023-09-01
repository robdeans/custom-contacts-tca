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
		.border(filterQuery.group.color)
	}
}

// MARK: - View Components
extension FilterRowView {
	private var firstRowContentView: some View {
		HStack {
			pickerView(for: FilterQuery.Filter.allCases, selected: $filterQuery.filter)
			Text("within the group")
			groupsPickerView
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}

	private var rowContentView: some View {
		VStack {
			HStack {
				pickerView(for: FilterQuery.Operator.allCases, selected: $filterQuery.operator)
				Text("contacts who are")
				pickerView(for: FilterQuery.Filter.allCases, selected: $filterQuery.filter)
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
				.tag(contactsRepository.allContactsGroup)
			ForEach(groups) {
				Text($0.name)
					.tag($0)
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

extension FilterQuery.Operator: PickerProtocol {
	var id: String {
		rawValue
	}

	fileprivate var title: String {
		rawValue.capitalized
	}
}

extension FilterQuery.Filter: PickerProtocol {
	var id: String {
		rawValue
	}

	fileprivate var title: String {
		switch self {
		case .include:
			return "Found"
		case .exclude:
			return "Not found"
		}
	}
}
