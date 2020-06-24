//
//  CalendarListViewModel.swift
//  CarFit
//
//  Created by Rajender Sharma on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
import CoreLocation

struct CalendarListViewModel {
	private let carWashVisit:CarWashVisit

	init(visit:CarWashVisit) {
		self.carWashVisit = visit
	}

	var houseOwnerName:String? {
		if let firstName = carWashVisit.houseOwnerFirstName {
			if let lastName = carWashVisit.houseOwnerLastName {
				return "\(firstName) \(lastName)"
			}
			return "\(firstName)"
		}
		return nil
	}

	var visitState:String? {
		return carWashVisit.visitState
	}

	var startTime:String? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
		guard let published = carWashVisit.startTimeUtc, let date = dateFormatter.date(from: published) else {
			return nil
		}
		dateFormatter.dateFormat = "HH:mm"
		return dateFormatter.string(from: date)
	}

	var houseAddress:String? {
		if let address = carWashVisit.houseOwnerAddress {
			if let zip = carWashVisit.houseOwnerZip {
				if let city = carWashVisit.houseOwnerCity {
					return "\(address) \(zip) \(city)"
				}
				return "\(address) \(zip)"
			}
			return "\(address)"
		}
		return nil
	}

	var distance:String? {

		guard let fromLat = carWashVisit.houseOwnerLatitude, let fromLong = carWashVisit.houseOwnerLongitude else {
			return "0"
		}

		guard let toLat = carWashVisit.houseOwnerLatitude, let toLong = carWashVisit.houseOwnerLongitude else {
			return "0"
		}
		//From location
		let fromLocation = CLLocation(latitude: fromLat, longitude: fromLong)
		//Next Visit location
		let nextLocation = CLLocation(latitude: toLat, longitude: toLong)
		//Measuring my distance to next visit location (in km)
		let distance = fromLocation.distance(from: nextLocation) / 1000
		//Display the result in km
		return String(format: "%.01f", distance)
	}

	var title:String? {
		let allTaskTitle = carWashVisit.tasks?.map({return $0.title ?? ""}) ?? []
		return allTaskTitle.joined(separator: ", ")
	}

	var timeInMinutes:String? {
		let allTaskTime = carWashVisit.tasks?.map({return $0.timesInMinutes ?? 0 }) ?? []
		return "\(allTaskTime.reduce(0) {$0 + $1})"
	}
}
