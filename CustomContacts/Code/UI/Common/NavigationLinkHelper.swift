//
//  NavigationLinkHelper.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/15/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

extension View {
	func navigationDestination<T, Destination: View>(
		to segueType: Binding<T?>,
		destination: @escaping (T) -> Destination
	) -> some View {
		modifier(
			NavigationLinkHelper(
				segueType: segueType,
				destination: destination
			)
		)
	}
}

private struct NavigationLinkHelper<T, Destination: View>: ViewModifier {
	@Binding var segueType: T?
	let destination: (T) -> Destination

	public func body(content: Content) -> some View {
		content
			.navigationDestination(
				isPresented: .init(
					get: { segueType != nil },
					set: { segueType = $0 ? segueType : nil }
				),
				destination: {
					if let segueType {
						destination(segueType)
					}
				}
			)
	}
}
