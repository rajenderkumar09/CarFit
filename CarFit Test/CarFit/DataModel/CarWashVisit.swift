//
//  CarWashVisit.swift
//  CarFit
//
//  Created by Rajender Sharma on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

//Map visit state to enum of type string
enum VisitState: String, Codable {
	case Done
	case ToDo
	case InProgress
	case Rejected
}

struct CarWashVisit: Codable {
	var visitId: String?
	var homeBobEmployeeId: String?
	var houseOwnerId:  String?
	var isBlocked:  Bool?
	var startTimeUtc: String?
	var endTimeUtc: String?
	var title:  String?
	var isReviewed:  Bool?
	var isFirstVisit:  Bool?
	var isManual:  Bool?
	var visitTimeUsed:  Int?
	var rememberToday:  String?
	var houseOwnerFirstName:String?
	var houseOwnerLastName:  String?
	var houseOwnerMobilePhone:  String?
	var houseOwnerAddress:  String?
	var houseOwnerZip:  String?
	var houseOwnerCity:  String?
	var houseOwnerLatitude:  Double?
	var houseOwnerLongitude:  Double?
	var isSubscriber:  Bool?
	var rememberAlways:  String?
	var professional:  String?
	var visitState:  VisitState?
	var stateOrder:  Int?
	var expectedTime:  String?
	var tasks:  [Task]?
	var houseOwnerAssets:  [HouseOwnerAsset]?
	var visitAssets:  [VisitAsset]?
	var visitMessages:  [VisitMessage]?
}
