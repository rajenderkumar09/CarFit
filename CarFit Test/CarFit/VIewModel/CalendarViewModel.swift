//
//  CalendarViewModel.swift
//  CarFit
//
//  Created by Rajender Sharma on 23/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

//MARK: CalendarView ViewModel
class CalendarViewModel {

	private var date = Date().datePart()
	private var selectedDate = Date().datePart()

	private var year:Int {
		return Calendar.current.component(.year, from: date)
	}
	private var month:Int {
		return Calendar.current.component(.month, from:  date)
	}

	private var day:Int {
		//Return day from selectedDate or date based on current month
		if date.isCurrentMonth {
			return Calendar.current.component(.day, from:  selectedDate)
		} else {
			return Calendar.current.component(.day, from:  date)
		}
	}

	//Update Handler to notify CalendarView about date selection change
	var didChange: (_ date:String) -> Void = { _ in }

	var numberOfDays:Int {
		return date.daysInMonth()
	}

	var monthAndYear:String? {
		let date = "\(month)-\(year)".date(format: "MM-yyyy")
		return date?.toString(format: "MMM yyyy")
	}

	var selectedIndexPath:IndexPath? {
		return IndexPath(item: self.day-1, section: 0)
	}

	func date(for day:Int) -> Date {
		let date = "\(day)-\(month)-\(year)".date(format: "dd-MM-yyyy")
		return date!
	}

	var dateSelected:Date {
		self.selectedDate
	}

	//Intent(s)
	func changeMonth(adjustment:Int) {
		var newDate = self.date.adjustMonth(offset: adjustment)
		if newDate.isCurrentMonth  {
			newDate = Date().datePart()
		} else {
			newDate = newDate.startDateOfMonth()
		}
		self.date = newDate

		//Pass selected date to didChange method as we want work order list for the selected date until any other is date is tapped by user
		self.didChange(selectedDate.toString(format: "yyyy-MM-dd"))
	}

	//Change selected date
	func updateSelectedDate(date:Date) {
		self.selectedDate = date
		self.didChange(date.toString(format: "yyyy-MM-dd"))
	}
}
