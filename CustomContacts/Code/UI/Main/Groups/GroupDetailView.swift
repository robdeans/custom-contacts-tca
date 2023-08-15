//
//  GroupDetailView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import SwiftUI

struct GroupDetailView: View {
	let group: ContactGroup

	var body: some View {
		Text(group.name)
		List {
			ForEach(Array(group.contactIDs), id: \.hashValue) {
				Text($0)
			}
		}
	}
}
