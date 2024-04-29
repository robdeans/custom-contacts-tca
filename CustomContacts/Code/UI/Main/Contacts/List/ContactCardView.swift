//
//  ContactCardView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/30/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import SwiftUI

private enum Layout {
	static let indicatorSize: CGFloat = 10.0
}

struct ContactCardView: View {
	let contact: Contact

	init(contact: Contact) {
		self.contact = contact
	}

	var body: some View {
		HStack {
			Text(contact.displayName)
			self.contactGroupIndicatorView
			Spacer()
		}
	}

	private var contactGroupIndicatorView: some View {
		ZStack(alignment: .leading) {
			ForEach(Array(contact.groups.enumerated()), id: \.element.id) { index, group in
				Circle()
					.fill(group.color)
					.frame(width: Layout.indicatorSize, height: Layout.indicatorSize)
					.padding(.leading, (Layout.indicatorSize / 1.4) * CGFloat(index))
			}
		}
	}
}
