//
//  GroupCreationView.swift
//  CustomContacts
//
//  Created by Robert Deans on 8/14/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import CustomContactsHelpers
import CustomContactsModels
import Dependencies
import SwiftUI

private enum Layout {
	static let bottomViewHeight = CGFloat(40)
}

@MainActor
struct GroupCreationView: View {
	@Environment(\.dismiss) private var dismiss
	@State var viewModel: ViewModel
	@State private var contactSelectorView: ContactSelectorView?

	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				Group {
					ColorPicker(
						selection: $viewModel.color,
						supportsOpacity: true,
						label: {
							TextField(Localizable.Groups.Edit.groupName, text: $viewModel.name)
								.autocorrectionDisabled()
								.foregroundStyle(viewModel.color)
								.fontWeight(.semibold)
						}
					)
					.padding(.vertical, Constants.UI.Padding.default)

					Button(Localizable.Groups.Edit.addRemove) {
						contactSelectorView = ContactSelectorView(selectedContacts: viewModel.selectedContacts) { contacts in
							viewModel.selectedContacts = contacts
						}
					}
				}
				.padding(Constants.UI.Padding.default)

				List {
					ForEach(viewModel.displayableContacts) {
						Text($0.displayName)
					}
				}

				Spacer()
			}

			HStack {
				Button(
					action: { dismiss() },
					label: {
						Text(Localizable.Common.Actions.cancel)
							.frame(maxWidth: .infinity)
					}
				)

				Button(
					action: {
						viewModel.createGroup()
					},
					label: {
						Text(Localizable.Common.Actions.save)
							.frame(maxWidth: .infinity)
					}
				)
			}
			.frame(height: Layout.bottomViewHeight)
			.frame(maxHeight: .infinity, alignment: .bottom)
		}
		.sheet(item: $contactSelectorView) { $0 }
	}
}

extension GroupCreationView: Identifiable {
	nonisolated var id: String {
		// TODO: is this the best way to determine ID?
		"GroupCreationView"
	}
}
