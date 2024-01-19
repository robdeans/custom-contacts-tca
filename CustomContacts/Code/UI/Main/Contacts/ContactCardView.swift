//
//  ContactCardView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/30/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import SwiftData
import SwiftUI

private enum Layout {
	static let indicatorSize: CGFloat = 10.0
}

struct ContactCardView: View {
	@Environment(\.modelContext) private var modelContext
	@Query(sort: [SortDescriptor(\ContactGroup.name)])
	private var groups: [ContactGroup]

	let contact: Contact

	var body: some View {
		HStack {
			Text(contact.displayName)
			self.contactGroupIndicatorView
			Spacer()
		}
	}

	private var contactGroupIndicatorView: some View {
		let filteredGroups = groups.filter { $0.contactIDs.contains(contact.id) }

		return ZStack(alignment: .leading) {
			ForEach(Array(filteredGroups.enumerated()), id: \.element.id) { index, group in
				Circle()
					.fill(group.color)
					.frame(width: Layout.indicatorSize, height: Layout.indicatorSize)
					.padding(.leading, (Layout.indicatorSize / 1.4) * CGFloat(index))
			}
		}
	}
}
