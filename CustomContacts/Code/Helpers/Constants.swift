//
//  Constants.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import SwiftUI

enum Constants {
	enum UI {
		enum Padding {
			/// CGFloat(20)
			static let `default` = CGFloat(20)
			/// CGFloat(24)
			static let extraLarge = CGFloat(24)
			/// CGFloat(16)
			static let large = CGFloat(16)
			/// CGFloat(8)
			static let small = CGFloat(8)
		}
		@MainActor
		enum Screen {
			static var safeAreaInsets: EdgeInsets {
				let keyWindow = UIApplication.shared.connectedScenes
					.compactMap { ($0 as? UIWindowScene)?.keyWindow }
					.last
				let insets = keyWindow?.safeAreaInsets ?? .zero
				return EdgeInsets(top: insets.top, leading: insets.left, bottom: insets.bottom, trailing: insets.right)
			}
			static var bounds: CGRect {
				UIScreen.main.bounds
			}
		}
	}
}
