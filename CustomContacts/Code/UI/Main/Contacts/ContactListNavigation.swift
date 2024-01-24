//
//  ContactListNavigation.swift
//  CustomContacts
//
//  Created by Robert Deans on 12/1/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsModels
import SwiftUI

final class ContactListNavigation: NavigationStackManager {
	@Published var path: [Path] = []
}

extension ContactListNavigation {
	enum Path: NavigationPath {
		case contactDetail(Contact)
	}
}

extension ContactListNavigation.Path {
	@ViewBuilder
	var destination: some View {
		switch self {
		case .contactDetail(let contact):
			ContactDetailView(contact: contact)
		}
	}
}
