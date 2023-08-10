//
//  NavigationStackView.swift
//  CustomContactsHelpers
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import SwiftUI

// Required to infer Path datatype in case path param is not provided by caller
public let emptyPath: [Int] = []

public struct NavigationStackView<Content: View, Path: Hashable>: View {
	@Binding var path: [Path]
	@ViewBuilder let contentView: () -> Content

	public init(
		path: Binding<[Path]> = .constant(emptyPath),
		contentView: @escaping () -> Content
	) {
		self._path = path
		self.contentView = contentView
	}

	public var body: some View {
		parentView
	}

	@ViewBuilder
	private var parentView: some View {
		if #available(iOS 16.0, *) {
			NavigationStack(path: $path, root: contentView)
		} else {
			NavigationView(content: contentView)
				.navigationViewStyle(.stack)
		}
	}
}
