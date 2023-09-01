//
//  RootView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

private enum Layout {
	static let rotationAngle = Angle(degrees: 180)
	static let rotationAxis = (x: CGFloat(0), y: CGFloat(1), z: CGFloat(0))
}

struct RootView: View {
	@State private var showContactList = true

	var body: some View {
		contentView
			.ignoresSafeArea()
	}

	@ViewBuilder
	private var contentView: some View {
		ZStack {
			ContactListView(onToggleTapped: { showContactList.toggle() })
				.opacity(showContactList ? 1 : 0)
			GroupListView(onToggleTapped: { showContactList.toggle() })
				// Handles mirror image
				.rotation3DEffect(.degrees(-180), axis: Layout.rotationAxis)
				.opacity(showContactList ? 0 : 1)
		}
		.rotation3DEffect(showContactList ? .zero : Layout.rotationAngle, axis: Layout.rotationAxis)
		.animation(.easeInOut, value: showContactList)
	}
}
