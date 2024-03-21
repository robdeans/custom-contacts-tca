//
//  GroupCardView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/15/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import SwiftUI

struct GroupCardView: View {
	@EnvironmentObject private var groupNavigation: GroupListNavigation
	@State private var isExpanded = false

	private let group: ContactGroup
	private let onGroupTapped: () -> Void

	init(group: ContactGroup, onGroupTapped: @escaping () -> Void) {
		self.group = group
		self.onGroupTapped = onGroupTapped
	}

	var body: some View {
		DisclosureGroup(
			isExpanded: $isExpanded,
			content: {
				ForEach(group.contacts().sorted()) { contact in
					Button(
						action: {
							groupNavigation.path.append(.contactDetail(contact))
						},
						label: {
							Text(contact.displayName)
						}
					)
					.buttonStyle(PlainButtonStyle())
				}
			},
			label: {
				Button(
					action: onGroupTapped,
					label: {
						Text(group.name)
							.fontWeight(.bold)
							.foregroundStyle(group.color)
					}
				)
			}
		)
	}
}
