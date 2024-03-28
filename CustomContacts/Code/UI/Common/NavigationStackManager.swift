//
//  NavigationStackManager.swift
//  CustomContacts
//
//  Created by Robert Deans on 12/1/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
protocol NavigationPath<Destination>: Hashable {
	associatedtype Destination: View
	@MainActor @ViewBuilder var destination: Destination { get }
}

protocol NavigationStackManager<Path>: AnyObject, ObservableObject {
	associatedtype Path: NavigationPath
	@MainActor
	var path: [Path] { get set }
}

extension NavigationStackManager {
	@MainActor
	func dismissToRoot() {
		path.removeAll()
	}
}

extension View {
	@MainActor
	func navigationDestination<Manager: NavigationStackManager>(
		for manager: Manager
	) -> some View {
		navigationDestination(for: Manager.Path.self) {
			$0.destination
		}
	}
}
