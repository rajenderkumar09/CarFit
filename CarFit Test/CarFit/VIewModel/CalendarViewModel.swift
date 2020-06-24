//
//  CalendarViewModel.swift
//  CarFit
//
//  Created by Rajender Sharma on 23/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

class CalendarViewModel {
	private var date = Date().datePart()
	private var selectedDate: Date

	init() {
		self.selectedDate = date
	}

	private var year:Int {
		return Calendar.current.component(.year, from: date)
	}
	private var month:Int {
		return Calendar.current.component(.month, from:  date)
	}
	private var day:Int {
		return Calendar.current.component(.day, from:  date)
	}

	var numberOfDays:Int {
		return date.daysInMonth()
	}

	var monthAndYear:String? {
		let date = "\(month)-\(year)".date(format: "MM-yyyy")
		return date?.toString(format: "MMM yyyy")
	}

	var selectedIndexPath:IndexPath {
		return IndexPath(item: self.day-1, section: 0)
	}

	func date(for day:Int) -> Date {
		let date = "\(day)-\(month)-\(year)".date(format: "dd-MM-yyyy")
		return date!
	}

	func changeMonth(adjustment:Int) {
		let newDate = self.date.adjustMonth(offset: adjustment)
		if newDate.isCurrentMonth  {
			self.date = Date()
		} else {
			self.date = newDate.startDateOfMonth()
		}
	}

	var dateSelected:Date {
		self.selectedDate
	}

	//Intent(s)
	func updateSelectedDate(date:Date, didChangedSelectedDate:(_ date:String) -> Void) {
		self.selectedDate = date
		didChangedSelectedDate(date.toString(format: "yyyy-MM-dd"))
	}
}
