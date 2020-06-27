//
//  Parser.swift
//  CarFit
//
//  Created by Rajender Sharma on 27/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

struct Parser {
	static func parseAndLoadJSON() -> CarFit? {
		if let path = Bundle.main.path(forResource: "carfit", ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
				let decoder = JSONDecoder()
				let carFit = try decoder.decode(CarFit.self, from: data)
				return carFit
			  } catch {
				   // handle error
					fatalError("Load json data error")
			  }
		} else {
			fatalError("Error: Can not load data ")
		}
		return nil
	}
}
