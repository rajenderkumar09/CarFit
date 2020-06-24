//
//  Task.swift
//  CarFit
//
//  Created by Rajender Sharma on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

struct Task: Codable {

	var taskId: String?
	var title: String?
	var isTemplate:Bool?
	var timesInMinutes: Int?
	var price: Float?
	var paymentTypeId:String?
	var createDateUtc: String?
	var lastUpdateDateUtc:String?
	var paymentTypes: String?

}
