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
		onChanged: ((Angle) -> Void)? = nil,
		onEnded: ((Angle) -> Void)? = nil
	) -> some View {
		modifier(EdgeSwipeCardFlipModifier(minThreshold: minThreshold, onChanged: onChanged, onEnded: onEnded))
	}
}

private struct EdgeSwipeCardFlipModifier: ViewModifier {
	@Environment(\.screenSize) private var screenSize

	let minThreshold: CGFloat
	let onChanged: ((Angle) -> Void)?
	let onEnded: ((Angle) -> Void)?

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

						let relativeAngle: Angle
						switch rotationAngle.degrees {
						case 360, -360:
							relativeAngle = .zero
						case -360...(-180):
							relativeAngle = Angle(degrees: rotationDegrees - 180)
						case -180..<180:
							relativeAngle = Angle(degrees: rotationDegrees)
						case 180..<360:
							relativeAngle = Angle(degrees: rotationDegrees + 180)
						default:
							LogWarning("These cases should never be accessible")
							if rotationDegrees > 360 {
								relativeAngle = Angle(degrees: rotationDegrees - 360)
							} else if rotationDegrees < -360 {
								relativeAngle = Angle(degrees: rotationDegrees + 360)
							} else {
								relativeAngle = .zero
							}
						}

						onChanged?(relativeAngle)
					}
					.onEnded { gesture in
						guard gestureExceedsThreshold(gesture) else {
							return
						}
						let startAngle = rotationAngle
						let endAngle: Angle

						// If is swiping from left
						if 0...minThreshold ~= gesture.startLocation.x {
							// and predictedEndLocation is more than half the screen
							if gesture.predictedEndLocation.x > (screenSize.width / 2) {
								// continue to full rotation
								switch startAngle.degrees {
								case .zero:
									endAngle = Angle(degrees: 180)
								case 180:
									endAngle = Angle(degrees: 360)
								case -180:
									endAngle = Angle(degrees: 0)
								default:
									LogFatal("DO NOT DO THIS")
								}
							} else {
								// otherwise cancel rotation
								endAngle = startAngle
							}
						}
						// If is swiping from right
						else if (screenSize.width - minThreshold)...screenSize.width ~= gesture.startLocation.x {
							// and predictedEndLocation is more than half the screen
							if gesture.predictedEndLocation.x < (screenSize.width / 2) {
								// continue to full rotation
								switch startAngle.degrees {
								case .zero:
									endAngle = Angle(degrees: -180)
								case 180:
									endAngle = Angle(degrees: 0)
								case -180:
									endAngle = Angle(degrees: -360)
								default:
									LogFatal("DO NOT DO THIS")
								}
							} else {
								// otherwise cancel rotation, and unflip the card if it has already been flipped
								endAngle = startAngle
							}
						} else {
							LogWarning("End angle not initialized correctly")
							endAngle = .zero
						}

						onEnded?(endAngle)

						switch endAngle.degrees {
						case 360, -360:
							rotationAngle = Angle(degrees: 0)
						default:
							rotationAngle = endAngle
						}
					}
			)
	}
}

extension EdgeSwipeCardFlipModifier {
	private func gestureExceedsThreshold(_ gesture: DragGesture.Value) -> Bool {
		gesture.startLocation.x <= minThreshold
		|| gesture.startLocation.x >= (screenSize.width - minThreshold)
	}
}
