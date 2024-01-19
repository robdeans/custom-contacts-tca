//
//  GroupListNavigation.swift
//  CustomContacts
//
//  Created by Robert Deans on 12/1/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsAPIKit
import SwiftUI

final class GroupListNavigation: NavigationStackManager {
	@Published var path: [Path] = []
}

extension GroupListNavigation {
	enum Path: NavigationPath {
		case groupDetail(ContactGroup)
	}
}

extension GroupListNavigation.Path {
	var destination: some View {
		switch self {
		case .groupDetail(let group):
			GroupDetailView(group: group)
		}
	}
}