# ReduxSwift

ReduxSwift is a Redux-like library written in Swift.

## Installation

### Swift Pakcage Manager

```swift
dependencies: [
    .package(url: "https://github.com/robinplz/ReduxSwift.git", from: "1.1.0"),
]
```

Make sure to use version from **1.1.0**.

## Usage

For a basic conceptual introduction on **Redux**, read it on [redux.js.org](https://redux.js.org/).

An example of how to use ReduxSwift can be found in `ReduxSwiftTests.swift`. Basically there are 4 actions to take:

1. Declare your **State** `Struct`.
2. Instantiate your **Store** object, by passing the default **state** object to it.
3. Subscribe state change signals from your **store** object.
4. Dispatch **reducer** functions to your **store** object. Any function that conforms to `(State)->State` could be a reducer function. Note this is the key difference from the original Redux implementation (as well as some other Swift based implementation), the original concept introduced an **Action** concept which is to be dispatched to the **Store** object. And then the reducer function may need switch-case by various action types to determine what to do with the state. The **ReduxSwift** implementation tries to simplify this by allowing you to directly dispatching the **Reducer** functions to the **Store** object.
