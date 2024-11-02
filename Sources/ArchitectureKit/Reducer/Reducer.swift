import Combine

public typealias EventSender<Event> = (Event) -> Void

@MainActor
public protocol Reducer {
    associatedtype State
    associatedtype Event
    associatedtype Action
    
    var prependActions: [Action] { get }
    func transform(_ action: Action, state: State, sendEvent: EventSender<Event>) async
    func apply(on state: State, _ event: Event) -> State
}

public extension Reducer {

    var prependActions: [Action] {
        []
    }
}
