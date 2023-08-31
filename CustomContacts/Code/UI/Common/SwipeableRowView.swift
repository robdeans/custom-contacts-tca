//
//  SwipeableRowView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/31/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

private enum Layout {
	static let buttonCoordinateSpace = "RemoveButton"
}

private struct SwipeableRowViewModifier: ViewModifier {
	@State private var xOffset = CGFloat.zero
	@State private var hideButton = false

	@State private var swipeThreshold = CGFloat(0)

	let onDelete: (() -> Void)?
	func body(content: Content) -> some View {
		ZStack {
			deleteButton
				.frame(maxWidth: .infinity, alignment: .trailing)
				.background(Color.red)
				// Hack for background flash on View appearing
				.opacity(xOffset < 0 ? 1 : 0)
				// Hack for background flash on View disappearing
				.opacity(hideButton ? 0 : 1)

			content
				.background(Color(UIColor.systemBackground))
				.offset(x: xOffset)
				.gesture(
					DragGesture()
						.onChanged(onDragValueChanged)
						.onEnded(onDragValueEnded)
				)
		}
	}

	private func onDragValueChanged(_ value: DragGesture.Value) {
		let xOffset = value.translation.width
		guard xOffset < .zero else {
			return
		}
		self.xOffset = xOffset
	}

	private func onDragValueEnded(_ value: DragGesture.Value) {
		withAnimation {
			if value.translation.width < swipeThreshold {
				xOffset = swipeThreshold
			} else {
				xOffset = .zero
			}
		}
	}

	@ViewBuilder
	private var deleteButton: some View {
		if let onDelete {
			Button(
				action: {
					hideButton = true
					onDelete()
				},
				label: {
					Text(Localizable.Contacts.Filter.remove)
						.tint(.white)
						.frame(maxHeight: .infinity)
						.padding(.horizontal, Constants.UI.Padding.default)
				}
			)
			.background(
				GeometryReader { geometry in
					Color.clear
						.preference(
							key: FramePreferenceKey.self,
							value: geometry.frame(in: .named(Layout.buttonCoordinateSpace))
						)
				}
			)
			.coordinateSpace(name: Layout.buttonCoordinateSpace)
			.onPreferenceChange(FramePreferenceKey.self) { frame in
				swipeThreshold = -frame.width
			}
		}
	}
}

extension View {
	func swipeable(onDelete: (() -> Void)? = nil) -> some View {
		modifier(SwipeableRowViewModifier(onDelete: onDelete))
	}
}
