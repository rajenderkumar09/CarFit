//
//  CleanerListViewModel.swift
//  CarFit
//
//  Created by Rajender Sharma on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
import CoreLocation

class CleanerListViewModel {
	private var carFit:CarFit?
	private var visits:[HomeCellViewModel]?
	private var date:String?

	// The closure that will gets called every time the
    // view model was updated
	var updateHandler: (_ date:String) -> Void = { _ in }

	init() {
		self.carFit = Parser.parseAndLoadJSON()
	}

	func loadData(date:String) {
		//Date
		self.date = date

		let visits = self.carFit?.data.filter { (visit) -> Bool in
			if let dateString = visit.startTimeUtc, let visitDate = dateString.date(format: "yyyy-MM-dd'T'hh:mm:ss") {
				return date == visitDate.toString(format: "yyyy-MM-dd")
			}
			return false
		}

		self.visits = visits?.enumerated().map { (index, visit) -> HomeCellViewModel in
			if index == 0 {
				return HomeCellViewModel(visit: visit, previousVisit: nil)
			} else {
				return HomeCellViewModel(visit: visit, previousVisit: visits?[index-1])
			}
		}
		self.updateHandler(date)
	}

	func refresh() {
		guard let date = self.date else {
			return
		}
		self.loadData(date: date)
	}

	func navigationTitle(for date:String) -> String {
		if date == Date().toString(format: "yyyy-MM-dd") {
			return "I DAG"
		} else {
			return date
		}
	}
}

extension CleanerListViewModel {
	//MARK: HomeTableViewCell ViewModel
	var numberOfVisits: Int {
		guard let visits = visits else {
			return 0
		}
		return visits.count
    }


	func homeCellViewModel(at index: Int) -> HomeCellViewModel? {

		guard let visit = visits?[index] else {
			return nil
		}
		return visit
	}
}
