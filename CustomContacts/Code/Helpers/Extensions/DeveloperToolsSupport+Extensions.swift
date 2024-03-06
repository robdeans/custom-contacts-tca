//
//  DeveloperToolsSupport+Extensions.swift
//  CustomContacts
//
//  Created by Robert Deans on 3/25/24.
//  Copyright © 2024 RBD. All rights reserved.
//

#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif
import Foundation

// https://forums.swift.org/t/xcode-15-3-rc-issues-warnings-for-generated-code/70353/8
extension DeveloperToolsSupport.ColorResource: @unchecked Sendable {}
extension DeveloperToolsSupport.ImageResource: @unchecked Sendable {}
