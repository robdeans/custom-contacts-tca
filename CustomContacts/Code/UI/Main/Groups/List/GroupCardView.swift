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

	let group: ContactGroup
	let onGroupTapped: () -> Void

	var body: some View {
		DisclosureGroup(
			isExpanded: $isExpanded,
			content: {
				ForEach(group.contacts.sorted()) { contact in
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
