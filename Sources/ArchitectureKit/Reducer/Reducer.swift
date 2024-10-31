@MainActor
public protocol Reducer {
    associatedtype State
    associatedtype Event
    associatedtype Action
    
    var prependActions: [Action] { get }
    func transform(_ action: Action, state: State) async -> Event
    func apply(_ event: Event, on state: inout State)
}

public extension Reducer {

    var prependActions: [Action] {
        []
    }
}
