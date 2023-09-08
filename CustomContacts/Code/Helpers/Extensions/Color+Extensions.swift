//
//  Color+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/8/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

extension Color {
	static var random: Color {
		Color(
			red: .random(in: 0...1),
			green: .random(in: 0...1),
			blue: .random(in: 0...1),
			opacity: 1
		)
	}
}
