//
//  RootView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import ComposableArchitecture
import CustomContactsAPIKit
import SwiftUI

private enum Layout {
	static let rotationAngle = Angle(degrees: 180)
	static let rotationAxis = (x: CGFloat(0), y: CGFloat(1), z: CGFloat(0))
}

struct RootView: View {
	@State private var showContactList = false
	private let contactListViewModel = ContactListView.ViewModel()

	var body: some View {
		NavigationStack {
			contentView
		}
	}

	@MainActor
	private var contentView: some View {
		/// Ideally `contentView` would be a `Group { ... }` containing a switch statement,
		/// and each View maintain its own `NavigationStack`.
		/// However there is a bug when rotating/flipping the `GroupList` which causes the tappable button area to be mirrored.
		/// In the future animation and structure could be improved once this bug is addressed.
		ZStack {
			if showContactList {
				ContactListView(
					viewModel: contactListViewModel,
					onToggleTapped: { showContactList.toggle() }
				)
			} else {
				GroupsView(
					store: Store(
						initialState: GroupsFeature.State(),
						reducer: { GroupsFeature() }
					),
					onToggleTapped: { showContactList.toggle() }
				)
				// Handles mirror image
				.rotation3DEffect(-Layout.rotationAngle, axis: Layout.rotationAxis)
			}
		}
		.rotation3DEffect(showContactList ? .zero : Layout.rotationAngle, axis: Layout.rotationAxis)
		.animation(.easeInOut, value: showContactList)
	}
}

/*

Rotate on swipe-from-left-edge in continuous rotation UIScreenEdgePanGestureRecognizer

*/
