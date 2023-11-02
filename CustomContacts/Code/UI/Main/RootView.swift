//
//  RootView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

private enum Layout {
	static let rotationAxis = (x: CGFloat(0), y: CGFloat(1), z: CGFloat(0))
	static let flippedAngle = -Angle(degrees: 180)
}

struct RootView: View {
	private let contactListViewModel = ContactListView.ViewModel()
	@State private var showContactList = true
	@State private var rotationAngle = Angle.zero

	var body: some View {
		contentView
			.rotation3DEffect(rotationAngle, axis: Layout.rotationAxis)
			.onEdgeSwipe(
				onChanged: { angle, showTopCard in
					rotationAngle = angle
					showContactList = showTopCard
				},
				onEnded: { angle, showTopCard in
					withAnimation {
						rotationAngle = angle
						showContactList = showTopCard
					}
				}
			)
			.background(
				Color.pink.opacity(0.2)
					.ignoresSafeArea()
			)
	}

	private var contentView: some View {
		ZStack {
			if showContactList {
				ContactListView(viewModel: contactListViewModel)
			} else {
				GroupListView()
					// Handles mirrored image
					.rotation3DEffect(
						Layout.flippedAngle,
						axis: Layout.rotationAxis
					)
			}
		}
	}
}
