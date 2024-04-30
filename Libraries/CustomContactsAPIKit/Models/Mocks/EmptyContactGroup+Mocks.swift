//
//  EmptyContactGroup+Mocks.swift
//  CustomContacts
//
//  Created by Robert Deans on 4/29/24.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation

extension EmptyContactGroup {
	public static var mock: EmptyContactGroup {
		EmptyContactGroup(
			id: "1",
			name: "Family",
			contactIDs: ["123", "456"],
			colorHex: "",
			index: 1
		)
	}
	public static var mockArray: [EmptyContactGroup] {
		[
			EmptyContactGroup(
				id: "1",
				name: "Family",
				contactIDs: ["123", "456"],
				colorHex: "",
				index: 1
			),
			EmptyContactGroup(
				id: "2",
				name: "Friends",
				contactIDs: ["789", "123"],
				colorHex: "",
				index: 2
			),
		]
	}
}
