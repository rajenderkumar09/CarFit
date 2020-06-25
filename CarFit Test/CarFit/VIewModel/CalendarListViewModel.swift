//
//  CalendarListViewModel.swift
//  CarFit
//
//  Created by Rajender Sharma on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
import CoreLocation

class CalendarListViewModel {
	private var carFit:CarFit
	private var visits:[HomeCellViewModel]?

	init() {
		if let path = Bundle.main.path(forResource: "carfit", ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
				let decoder = JSONDecoder()
				let carFit = try decoder.decode(CarFit.self, from: data)
				self.carFit = carFit
			  } catch {
				   // handle error
				fatalError("Load json data error")
			  }
		} else {
			fatalError("Error: Can not load data ")
		}
	}

	func loadData(date:String) {
		let visits = self.carFit.data.filter { (visit) -> Bool in
			if let dateString = visit.startTimeUtc, let visitDate = dateString.date(format: "yyyy-MM-dd'T'hh:mm:ss") {
				return date == visitDate.toString(format: "yyyy-MM-dd")
			}
			return false
		}
		self.visits = visits.map({return HomeCellViewModel(visit: $0)})
	}

	var data:[HomeCellViewModel] {
		self.visits ?? []
	}
}