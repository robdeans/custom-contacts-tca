//
//  ContactSelectorViewTCA.swift
//  CustomContacts
//
//  Created by Robert Deans on 9/7/23.
//  Copyright © 2023 RBD. All rights reserved.
//

import ComposableArchitecture
import CustomContactsAPIKit
import SwiftUI

struct ContactSelectorViewTCA: View {
	let store: StoreOf<ContactSelectorFeature>

	var body: some View {
		NavigationStack {
			WithViewStore(
				self.store,
				observe: { $0 },
				content: { viewStore in
					List(
						viewStore.contactsDisplayable,
						selection: viewStore.binding(
							get: \.selectedContactIDs,
							send: { .updateContactIDs($0) }
						)
					) {
						ContactCardView(contact: $0)
					}
					.searchable(text: viewStore.binding(get: \.searchText, send: { .setSearchText($0) }))
					.refreshable {
						store.send(.loadContacts(refresh: true))
					}
					.environment(\.editMode, .constant(.active))
					.toolbar {
						ToolbarItem(placement: .topBarLeading) {
							Button(Localizable.Common.Actions.cancel) {
								store.send(.cancelButtonTapped)
							}
						}
						ToolbarItem(placement: .topBarTrailing) {
							Button(Localizable.Common.Actions.done) {
								store.send(.doneButtonTapped)
							}
						}
					}
				}
			)
		}
		.task {
			store.send(.loadContacts(refresh: false))
		}
	}
}
