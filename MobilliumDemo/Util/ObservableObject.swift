//
//  ObservableObject.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation

class ObservableObject<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T{
        didSet{
            listener?(value)
        }
    }
    
    init(_ value:T){
        self.value = value
    }
    
    func bind(listener: Listener?){
        self.listener = listener
        listener?(value)
    }
}
