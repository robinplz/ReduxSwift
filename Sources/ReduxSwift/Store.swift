//
//  Store.swift
//  redux-test
//
//  Created by Robin on 2019/11/26.
//  Copyright © 2019 Robin & Viviun Studio. All rights reserved.
//

import Foundation
import Signals

public class Store<State> {
    
    public var state: State {
        return self._state
    }
    
    public init(state: State) {
        self._state = state
    }
    
    public func dispatch(action: Reducer<State>) {
        let new_state = action(self._state)
        updateState(new_state)
    }
    
    public func statePublisher() -> Signal<State> {
        return self._publisher
    }
    
    public func subStatePublisher<SubState: Equatable>(keyPath: KeyPath<State, SubState>) -> Signal<SubState> {
        if let obj = self._sub_state_publishers[keyPath] {
            guard let sub_state_publisher = obj as? SubStatePublisher<State, SubState> else {
                fatalError()
            }
            return sub_state_publisher.signal
        }
        
        cleanUpSubStatePublishers()
        
        let sub_state_publisher = SubStatePublisher<State, SubState>(keyPath: keyPath)
        self._sub_state_publishers[keyPath] = sub_state_publisher
        return sub_state_publisher.signal
    }
   
    // MARK: Private
    private var _state: State
    private lazy var _publisher = Signal<State>()
    private func updateState(_ state: State) {
        let old_state = self._state
        self._state = state
        self._publisher.fire(state)
        emitSubStateSignals(old: old_state, new: state)
    }
    
    private func emitSubStateSignals(old old_state: State, new new_state: State) {
        self._sub_state_publishers.forEach { $0.value.emit(old: old_state, new: new_state) }
    }
    
    private lazy var _sub_state_publishers = Dictionary<PartialKeyPath<State>, StatePublisher<State>>()
    func cleanUpSubStatePublishers() {
        self._sub_state_publishers = self._sub_state_publishers.filter { !$0.value.disposable }
    }
}

class StatePublisher<State> {
    func emit(old old_state: State, new new_state: State) {}
    var disposable: Bool { return false }
}

class SubStatePublisher<State, SubState: Equatable>: StatePublisher<State> {
    init(keyPath: KeyPath<State, SubState>) {
        self._key_path = keyPath
    }
    
    var signal: Signal<SubState> {
        return self._signal
    }
    
    override func emit(old old_state: State, new new_state: State) {
        let old_sub_state = old_state[keyPath: self._key_path]
        let new_sub_state = new_state[keyPath: self._key_path]
        if (old_sub_state != new_sub_state) {
            self._signal.fire(new_sub_state)
        }
    }
    
    override var disposable: Bool {
        return self._signal.observers.count == 0
    }
    
    private var _key_path: KeyPath<State, SubState>
    private lazy var _signal = Signal<SubState>()
}
