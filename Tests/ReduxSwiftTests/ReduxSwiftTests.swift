import XCTest
@testable import ReduxSwift

final class ReduxSwiftTests: XCTestCase {
    
    override func setUp() {
        sampleStore.statePublisher().subscribe(with: self) { (state) in
            print("i: \(state.i), s: \(state.s)")
        }
    }
    
    func testExample() {
        sampleStore.dispatch(action: sampleActionSetInt42)
        XCTAssertEqual(sampleStore.state.i, 42)
        
        sampleStore.dispatch(action: sampleActionSetStringHello)
        XCTAssertEqual(sampleStore.state.s, "Hello")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

// MARK: Sample State
struct SampleState {
    var i: Int = 0
    var s: String = ""
}

let sampleActionSetInt42 = { (old_state: SampleState) -> SampleState in
    var state = old_state
    state.i = 42
    return state
}

let sampleActionSetStringHello = { (old_state: SampleState) -> SampleState in
    var state = old_state
    state.s = "Hello"
    return state
}

let sampleStore = Store<SampleState>(state: SampleState())
