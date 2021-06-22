//
//  File.swift
//  Top100
//
//  Created by Manpreet on 28/10/2020.
//

import Foundation

protocol MAMainThreadSafe {
    func performUIUpdate(using closure: @escaping () -> Void)
}

extension MAMainThreadSafe {
    func performUIUpdate(using closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async(execute: closure)
        }
    }
}
