//
//  Contact+SortOption.swift
//  CustomContacts
//
//  Created by Robert Deans on 1/26/24.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation

extension Contact {
	public struct SortOption: Codable {
		public enum Parameter: String, Codable, CaseIterable {
			/// silences swiftlint warning `raw_value_for_camel_cased_codable_enum`
			case firstName = "first_name"
			case lastName = "last_name"
		}
		public var parameter: Parameter
		public var ascending: Bool

		public  init(parameter: Contact.SortOption.Parameter, ascending: Bool) {
			self.parameter = parameter
			self.ascending = ascending
		}
	}
}
