//
//  RootView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsHelpers
import SwiftUI

private enum Layout {
	static let rotationAxis = (x: CGFloat(0), y: CGFloat(1), z: CGFloat(0))
	static let flippedAngle = -Angle(degrees: 180)
}

@MainActor
struct RootView: View {
	@Bindable private var viewModel = RootView.ViewModel()
	@State private var showContactList = true
	@State private var rotationAngle = Angle.zero

	private let contactListViewModel = ContactListView.ViewModel()

	var body: some View {
		if viewModel.isLoading {
			ProgressView()
				.task {
					await viewModel.initializeApp()
				}
		} else {
			rotatingSplitView
		}
	}

	private var rotatingSplitView: some View {
		contentView
			.rotation3DEffect(rotationAngle, axis: Layout.rotationAxis)
			.onEdgeSwipe(
				onChanged: { angle in
					rotationAngle = angle
					showContactList = Self.showTopCard(angle: angle)
				},
				onEnded: { angle in
					withAnimation {
						rotationAngle = angle
						showContactList = Self.showTopCard(angle: angle)
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
			ContactListView(viewModel: contactListViewModel)
				.opacity(showContactList ? 1 : 0)
			GroupListView()
				.opacity(showContactList ? 0 : 1)
				// Handles mirrored image
				.rotation3DEffect(
					Layout.flippedAngle,
					axis: Layout.rotationAxis
				)
		}
		// Hack to prevent NavigationStack resizing jitters
		.frame(height: Constants.UI.Screen.bounds.height + 25)
	}
}

extension RootView {
	private static func showTopCard(angle: Angle) -> Bool {
		switch angle.degrees {
		case 0...90:
			return true
		case 90...180:
			return false
		case 180...270:
			return false
		case 270...360:
			return true
		case -90...0:
			return true
		case -180...(-90):
			return false
		case -270...(-180):
			return false
		case -360...(-270):
			return true
		default:
			LogFatal("Should never exceed 360 degrees")
		}
	}
}
