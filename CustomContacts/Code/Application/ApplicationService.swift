//
//  ApplicationService.swift
//  CustomContacts
//
//  Created by full_name on date_markup.
//  Copyright © year_markup Fueled. All rights reserved.
//

import UIKit

protocol ApplicationService: UIApplicationDelegate {
}

extension ApplicationService {
	var window: UIWindow? {
		UIApplication.shared.delegate?.window.flatMap { $0 }
	}
}
