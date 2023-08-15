//
//  GroupCardView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/15/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import Dependencies
import SwiftUI

struct GroupCardView: View {
	@Dependency(\.contactsRepository) private var contactsRepository
	let group: ContactGroup
	let onGroupTapped: () -> Void

	@State private var isExpanded = false

	var body: some View {
		DisclosureGroup(
			isExpanded: $isExpanded,
			content: {
				ForEach(Array(group.contactIDs), id: \.hashValue) {
					Text(contactsRepository.contact(for: $0)?.fullName ?? Localizable.Groups.Card.nameMissing)
				}
			},
			label: {
				Button(
					action: onGroupTapped,
					label: {
						Text(group.name)
							.fontWeight(.bold)
					}
				)
			}
		)
		.foregroundStyle(group.color)
	}
}
