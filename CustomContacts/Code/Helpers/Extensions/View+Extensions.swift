//
//  View+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

extension View {
	func cornerRadius(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) -> some View {
		clipShape(RoundedCorner(radius: radius, corners: corners))
	}
}

private struct RoundedCorner: Shape {
	let radius: CGFloat
	let corners: UIRectCorner

	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		return Path(path.cgPath)
	}
}

extension View {
	func frame(size: CGSize) -> some View {
		frame(width: size.width, height: size.height)
	}
}
