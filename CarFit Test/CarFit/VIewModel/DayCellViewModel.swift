//
//  DayCellViewModel.swift
//  CarFit
//
//  Created by Rajender Sharma on 23/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
struct DayCellViewModel {
	private let date:Date

	init(date:Date) {
		self.date = date
	}

	var weekDay:String? {
		return self.date.toString(format: "EEE")
	}

	var day:String? {
		return self.date.toString(format: "dd")
	}

	var cellDate:Date {
		return self.date
	}
	
}
