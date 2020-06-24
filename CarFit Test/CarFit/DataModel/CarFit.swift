//
//  CarFit.swift
//  CarFit
//
//  Created by Rajender Sharma on 24/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

struct CarFit:Codable {
	var success:Bool
	var message:String
	var data: [CarWashVisit]
}
