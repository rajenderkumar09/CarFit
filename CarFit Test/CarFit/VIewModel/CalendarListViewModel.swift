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
	private var visits:[CarWashVisit]?

	// The closure that will gets called every time the
    // view model was updated
	var updateHandler: (_ date:String) -> Void = { _ in }

	//CalendarView stored properties
	private var date = Date().datePart()
	private var selectedDate = Date().datePart()

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
		self.visits = visits
		//self.visits = visits.map({return HomeCellViewModel(visit: $0)})
		self.updateHandler(date)
	}

	func navigationTitle(for date:String) -> String {
		if date == Date().toString(format: "yyyy-MM-dd") {
			return "I DAG"
		} else {
			return date
		}
	}
}

extension CalendarListViewModel {
	//MARK: HomeTableViewCell ViewModel
	var numberOfVisits: Int {
		guard let visits = visits else {
			return 0
		}
		return visits.count
    }

	func houseOwnerName(at index: Int) -> String? {

		guard let visit = visits?[index] else {
			return nil
		}
		if let firstName = visit.houseOwnerFirstName {
			if let lastName = visit.houseOwnerLastName {
				return "\(firstName) \(lastName)"
			}
			return "\(firstName)"
		}
		return nil
	}

	func visitStatus(at index: Int) -> String? {
		guard let visit = visits?[index] else {
			return nil
		}
		return visit.visitState
	}

	func startTime(at index: Int) -> String? {
		guard let visit = visits?[index] else {
			return nil
		}

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
		guard let published = visit.startTimeUtc, let date = dateFormatter.date(from: published) else {
			return nil
		}
		dateFormatter.dateFormat = "HH:mm"
		return dateFormatter.string(from: date)
	}

	func houseAddress(at index: Int) -> String? {
		guard let visit = visits?[index] else {
			return nil
		}
		if let address = visit.houseOwnerAddress {
			if let zip = visit.houseOwnerZip {
				if let city = visit.houseOwnerCity {
					return "\(address) \(zip) \(city)"
				}
				return "\(address) \(zip)"
			}
			return "\(address)"
		}
		return nil
	}

	func distance(at index: Int) -> String? {
		guard index > 0 else {
			return "0.0 km"
		}
		guard let previousVisit = visits?[index-1], let fromLat = previousVisit.houseOwnerLatitude, let fromLong = previousVisit.houseOwnerLongitude else {
			return "0.0 km"
		}

		guard let visit = visits?[index], let toLat = visit.houseOwnerLatitude, let toLong = visit.houseOwnerLongitude else {
			return "0.0 km"
		}
		//From location
		let fromLocation = CLLocation(latitude: fromLat, longitude: fromLong)
		//Next Visit location
		let nextLocation = CLLocation(latitude: toLat, longitude: toLong)
		//Measuring my distance to next visit location (in km)
		let distance = fromLocation.distance(from: nextLocation) / 1000
		//Display the result in km
		return String(format: "%.01f km", distance)
	}

	func title(at index: Int) -> String? {
		guard let visit = visits?[index] else {
			return nil
		}
		let allTaskTitle = visit.tasks?.map({return $0.title ?? ""}) ?? []
		return allTaskTitle.joined(separator: ", ")
	}

	func timeInMinutes(at index: Int) -> String? {
		guard let visit = visits?[index] else {
			return nil
		}
		let allTaskTime = visit.tasks?.map({return $0.timesInMinutes ?? 0 }) ?? []
		return "\(allTaskTime.reduce(0) {$0 + $1})"
	}
}
