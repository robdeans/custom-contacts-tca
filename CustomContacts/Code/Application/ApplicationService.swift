//
//  ApplicationService.swift
//  CustomContacts
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import UIKit

protocol ApplicationService: UIApplicationDelegate {
}

extension ApplicationService {
	var window: UIWindow? {
		UIApplication.shared.delegate?.window.flatMap { $0 }
	}
}
