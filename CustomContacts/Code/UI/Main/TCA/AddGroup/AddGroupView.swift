//
//  AddGroupView.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/7/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import ComposableArchitecture
import CustomContactsAPIKit
import SwiftData
import SwiftUI

private enum Layout {
	static let bottomViewHeight = CGFloat(40)
}

struct AddGroupView: View {
	let store: StoreOf<AddGroupFeature>
	@Dependency(\.contactsRepository) private var contactsRepository

	var body: some View {
		WithViewStore(
			self.store,
			observe: { $0 },
			content: { viewStore in
				ZStack {
					VStack(spacing: 0) {
						Group {
							ColorPicker(
								selection: viewStore.binding(get: \.group.color, send: { .setColor($0) }),
								supportsOpacity: true,
								label: {
									TextField(
										Localizable.Groups.Edit.groupName,
										text: viewStore.binding(get: \.group.name, send: { .setName($0) })
									)
									.foregroundStyle(viewStore.group.color)
										.fontWeight(.semibold)
								}
							)
							.padding(.vertical, Constants.UI.Padding.default)

							Button(Localizable.Groups.Edit.addRemove) {
								store.send(.addContactsTapped)
							}
						}
						.padding(Constants.UI.Padding.default)

						List {
							ForEach(
								viewStore.state.group.contactIDs
									.compactMap { contactsRepository.contact(for: $0) }
									.sorted(by: { $0.fullName < $1.fullName })
							) {
								Text($0.fullName)
							}
						}

						Spacer()
					}

					HStack {
						Button(
							action: { viewStore.send(.cancelButtonTapped) },
							label: {
								Text(Localizable.Common.Actions.cancel)
									.frame(maxWidth: .infinity)
							}
						)

						Button(
							action: { viewStore.send(.saveButtonTapped) },
							label: {
								Text(Localizable.Common.Actions.save)
									.frame(maxWidth: .infinity)
							}
						)
					}
					.frame(height: Layout.bottomViewHeight)
					.frame(maxHeight: .infinity, alignment: .bottom)
				}
			}
		)
		.sheet(store: self.store.scope(state: \.$contactSelector, action: { .addContacts($0) })) {
			ContactSelectorViewTCA(store: $0)
		}
	}
}

#Preview {
	let container = previewContainer
	return MainActor.assumeIsolated {
		NavigationStack {
			AddGroupView(
				store: Store(
					initialState: AddGroupFeature.State(
						group: ContactGroup.empty
					)
				) {
					AddGroupFeature()
				}
			)
		}
		.modelContainer(container)
	}
}

@MainActor
private let previewContainer: ModelContainer = {
	do {
		let container = try ModelContainer(for: ContactGroup.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
		container.mainContext.insert(ContactGroup.mock)
		return container
	} catch {
		fatalError("Failed to create container")
	}
}()
