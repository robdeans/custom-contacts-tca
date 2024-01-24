//
//  ContactDetailView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import SwiftUI

struct ContactDetailView: View {
	let contact: Contact

	var body: some View {
		Text(contact.displayName)
	}
}
