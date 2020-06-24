//
//  Date+Extensions.swift
//  CarFit
//
//  Created by Rajender Sharma on 23/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

extension Date {

	func numberOfDays() -> Int {
		let calendar = Calendar.current
		let range = calendar.range(of: .day, in: .month, for: self)!
		let numDays = range.count
		print(numDays) // 31
		return numDays
	}

	func toString (format:String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		return dateFormatter.string(from: self)
	}

	func adjustMonth(offset:Int) -> Date {
		var dateComp = DateComponents()
		dateComp.month = offset
		return Calendar.current.date(byAdding: dateComp, to: self)!
	}

	func startDate(calendar:Calendar = Calendar.current) -> Date {
		var dateComp = calendar.dateComponents([.year, .month,.day], from: self)
		dateComp.day = 1
		return calendar.date(from: dateComp)!
	}

	var isCurrentMonth:Bool {
		let curDateComponents = Calendar.current.dateComponents([.month, .year, .day], from: Date())
		let components = Calendar.current.dateComponents([.month, .year, .day], from: self)
		return components.year == curDateComponents.year && components.month == curDateComponents.month
	}
	
}
