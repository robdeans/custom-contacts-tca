//
//  NavigationStackManager.swift
//  CustomContacts
//
//  Created by Robert Deans on 12/1/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Combine
import SwiftUI

protocol NavigationPath<Destination>: Hashable {
	associatedtype Destination: View
	@ViewBuilder var destination: Destination { get }
}

protocol NavigationStackManager<Path>: AnyObject, ObservableObject {
	associatedtype Path: NavigationPath
	var path: [Path] { get set }
}

extension NavigationStackManager {
	func dismissToRoot() {
		path.removeAll()
	}
}

extension View {
	func navigationDestination<Manager: NavigationStackManager>(
		for manager: Manager
	) -> some View {
		navigationDestination(for: Manager.Path.self) {
			$0.destination
		}
	}
}
