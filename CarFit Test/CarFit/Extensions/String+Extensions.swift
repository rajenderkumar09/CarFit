//
//  String+Extensions.swift
//  CarFit
//
//  Created by Rajender Sharma on 23/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
extension String {
	func date(format:String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format

		return dateFormatter.date(from: self)
	}
}
