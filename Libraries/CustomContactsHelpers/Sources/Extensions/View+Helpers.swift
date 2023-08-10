//
//  View+Helpers.swift
//  CustomContactsHelpers
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import SwiftUI

// MARK: - Segue to push
extension View {
	public func segue<T, Destination: View>(viewModel: Binding<T?>, destination: @escaping (T) -> Destination) -> some View {
		if #available(iOS 16.0, *) {
			return navigationDestination(
				isPresented: .init(
					get: { viewModel.wrappedValue != nil },
					set: { viewModel.wrappedValue = $0 ? viewModel.wrappedValue : nil }
				)
			) {
				if let viewModel = viewModel.wrappedValue {
					destination(viewModel)
				}
			}
		} else {
			return modifier(SegueViewModelModifier(viewModel: viewModel, destination: destination))
		}
	}

	public func segue<T: View>(isActive: Binding<Bool>, @ViewBuilder destination: @escaping () -> T) -> some View {
		if #available(iOS 16.0, *) {
			return navigationDestination(isPresented: isActive, destination: destination)
		} else {
			return modifier(SegueIsActiveModifier(isActive: isActive, destination: destination))
		}
	}
}

struct SegueViewModelModifier<T, Destination: View>: ViewModifier {
	@Binding var viewModel: T?
	let destination: (T) -> Destination

	func body(content: Content) -> some View {
		content
			.background(
				NavigationLink(
					isActive: .init(
						get: { viewModel != nil },
						set: { viewModel = $0 ? viewModel : nil }
					)
				) {
					if let viewModel = viewModel {
						destination(viewModel)
					}
				} label: {
					EmptyView()
				}
					.isDetailLink(false)
			)
	}
}

struct SegueIsActiveModifier<T: View>: ViewModifier {
	@Binding var isActive: Bool
	let destination: () -> T

	func body(content: Content) -> some View {
		content
			.background(
				NavigationLink(isActive: $isActive) {
					destination()
				} label: {
					EmptyView()
				}
					.isDetailLink(false)
			)
	}
}
