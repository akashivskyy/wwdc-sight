//
//  Observable.swift
//  Perception
//
//  Created by Adrian Kashivskyy on 20/03/2019.
//  Copyright © 2019 Adrian Kashivskyy. All rights reserved.
//

import Foundation

internal final class Observable<Value> {

    internal typealias Observer = (Value) -> Void

    private let registry = ObservableRegistry<Value>()

    private init() {

    }

    internal static func create(_ value: Value? = nil) -> (Observable<Value>, ObservableSetter<Value>) {

    }

    internal func observe(_ onValue: @escaping (Value) -> Void) -> ObservationToken {

    }





//    internal static func make(value: Value) ->

}

fileprivate final class ObservableRegistry<Value> {





    /// A private queue on which storage is mutated.
    private let accessQueue = DispatchQueue(label: "queue.com.anonyome.SudoWebKit.SubscriptionRegistry.accessQueue", qos: .default)

    /// A private queue on which subscriptions are dispatched.
    private let dispatchQueue = DispatchQueue(label: "queue.com.anonyome.SudoWebKit.SubscriptionRegistry.dispatchQueue", qos: .default)

}

internal struct ObservationBag {

    

}

internal final class ObservableSetter<Value> {

    // MARK: Initializers

    internal init(_ onSet: @escaping (Value) -> Void) {
        self.onSet = onSet
    }

    // MARK: Properties

    /// Closure to execute when `self` is deallocated.
    private let onSet: (Value) -> Void

    // MARK: Behavior

    internal func set(_ value: Value) {
        onSet(value)
    }

}



internal final class ObservationToken: Equatable {

    // MARK: Initializers

    /// Initialize an instance.
    ///
    /// - Parameters:
    ///     - onDeinit: Closure to execute when token is deinitialized.
    internal init(_ onDeinit: @escaping (ObservationToken) -> Void) {
        self.onDeinit = onDeinit
    }

    /// Deallocate the instance.
    deinit {
        onDeinit(self)
    }

    // MARK: Properties

    /// Closure to execute when `self` is deallocated.
    private let onDeinit: (ObservationToken) -> Void

    // MARK: Equatable

    /// - SeeAlso: Equatable.==
    internal static func == (_ lhs: ObservationToken, _ rhs: ObservationToken) -> Bool {
        return lhs === rhs
    }

}
