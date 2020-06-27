//
//  Binder.swift
//  WildfireRisk
//
//  Created by Rajender Sharma on 25/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import UIKit

class Binder<Value> {

    typealias Listener = (Value) -> Void
    
    var value: Value {
        didSet {
            self.listeners.forEach({$0(value)})
        }
    }
    private var listeners: [Listener] = []

    init(_ value: Value, listener: Listener? = nil) {
        self.value = value
        guard let listener = listener else {return}
        self.listeners.append(listener)
    }

    func bind(listener: @escaping Listener) {
        self.listeners.append(listener)
    }
    
}

