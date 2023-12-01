//
//  EdgeSwipeCardFlipModifier.swift
//  CustomContacts
//
//  Created by Robert Deans on 11/30/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsHelpers
import SwiftUI

extension View {
	/// Used primarily to rotate double-sided Views.
	///
	/// A method that detects leading/trailing swipe gestures within a minimum threshold
	/// and returns an angle of rotation, as well as a Boolean indicating whether the top card is visibile.
	func onEdgeSwipe(
		minThreshold: CGFloat = 20.0,
		onChanged: ((Angle, Bool) -> Void)? = nil,
		onEnded: ((Angle, Bool) -> Void)? = nil
	) -> some View {
		modifier(EdgeSwipeCardFlipModifier(minThreshold: minThreshold, onChanged: onChanged, onEnded: onEnded))
	}
}

private struct EdgeSwipeCardFlipModifier: ViewModifier {
	@Environment(\.screenSize) private var screenSize

	let minThreshold: CGFloat
	let onChanged: ((Angle, Bool) -> Void)?
	let onEnded: ((Angle, Bool) -> Void)?

	@State private var rotationAngle = Angle.zero

	func body(content: Content) -> some View {
		content
			.gesture(
				DragGesture()
					.onChanged { gesture in
						guard gestureExceedsThreshold(gesture) else {
							return
						}

						let rotationDegrees = (gesture.location.x - gesture.startLocation.x)
						/ screenSize.width
						* 180

						switch rotationAngle.degrees {
						case 360, -360:
							rotationAngle = .zero
						case -179...179:
							rotationAngle = Angle(degrees: rotationDegrees)
						case 180..<360:
							rotationAngle = Angle(degrees: rotationDegrees + 180)
						case -359...(-180):
							rotationAngle = Angle(degrees: rotationDegrees - 180)
						default:
							if rotationDegrees > 360 {
								rotationAngle = Angle(degrees: rotationDegrees - 360)
							} else if rotationDegrees < -360 {
								rotationAngle = Angle(degrees: rotationDegrees + 360)
							}
						}

						onChanged?(rotationAngle, Self.showTopCard(degrees: rotationAngle.degrees))
					}
					.onEnded { gesture in
						guard gestureExceedsThreshold(gesture) else {
							return
						}
						var endAngle = Angle.zero

						// If is swiping from left
						if 0...minThreshold ~= gesture.startLocation.x {
							// and predictedEndLocation is more than half the screen
							if gesture.predictedEndLocation.x > (screenSize.width / 2) {
								// continue to full rotation
								endAngle = Angle(degrees: rotationAngle.degrees > 180 ? 360 : 180)
							} else {
								// otherwise cancel rotation
								endAngle = Angle(degrees: rotationAngle.degrees > 180 ? 180 : .zero)
							}
						}
						// If is swiping from right
						else if (screenSize.width - minThreshold)...screenSize.width ~= gesture.startLocation.x {
							// and predictedEndLocation is more than half the screen
							if gesture.predictedEndLocation.x < (screenSize.width / 2) {
								// continue to full rotation, and flip the card if it hasn't already been flipped
								endAngle = Angle(degrees: rotationAngle.degrees < -180 ? -360 : -180)
							} else {
								// otherwise cancel rotation, and unflip the card if it has already been flipped
								endAngle = Angle(degrees: rotationAngle.degrees < -180 ? -180 : .zero)
							}
						}

						onEnded?(endAngle, Self.showTopCard(degrees: endAngle.degrees))
						rotationAngle = endAngle
					}
			)
	}
}

extension EdgeSwipeCardFlipModifier {
	private func gestureExceedsThreshold(_ gesture: DragGesture.Value) -> Bool {
		gesture.startLocation.x <= minThreshold
		|| gesture.startLocation.x >= (screenSize.width - minThreshold)
	}

	private static func showTopCard(degrees: Double) -> Bool {
		switch degrees {
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
