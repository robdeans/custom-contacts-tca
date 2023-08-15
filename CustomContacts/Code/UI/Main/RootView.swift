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
	@State private var showContactList = false

	var body: some View {
		NavigationStack {
			contentView
				.toolbar {
					ToolbarItem(placement: .topBarLeading) {
						Button("🔄") {
							showContactList.toggle()
						}
					}
				}
		}
	}

	@ViewBuilder
	private var contentView: some View {
		ZStack {
			if showContactList {
				ContactListView()
			} else {
				GroupListView()
					// Handles mirror image
					.rotation3DEffect(.degrees(-180), axis: Layout.rotationAxis)
			}
		}
		.rotation3DEffect(showContactList ? .zero : Layout.rotationAngle, axis: Layout.rotationAxis)
		.animation(.easeInOut, value: showContactList)
	}
}
