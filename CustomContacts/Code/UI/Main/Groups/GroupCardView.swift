//
//  GroupCardView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/15/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import SwiftUI

struct GroupCardView: View {
	let group: ContactGroup
	let onGroupTapped: () -> Void

	@State private var isExpanded = false

	var body: some View {
		DisclosureGroup(
			isExpanded: $isExpanded,
			content: {
				ForEach(Array(group.contactIDs), id: \.hashValue) {
					Text($0)
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
