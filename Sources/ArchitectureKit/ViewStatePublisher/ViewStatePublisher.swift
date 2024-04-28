import Combine
import SwiftUI


open class ViewStatePublisher<State, Action>: ObservableObject {
    
    public typealias State = State
    public typealias Action = Action
    
    @Published public private(set) var state: State
    
    private var cancellables = Set<AnyCancellable>()
    
    public init<Event, EventPublisher: Publisher>(
        initial: State,
        dataEvents: EventPublisher,
        reducer: @escaping (State, Event) -> State
    ) where EventPublisher.Output == Event, EventPublisher.Failure == Never {
        state = initial
        dataEvents
            .scan(initial, reducer)
            .prepend(initial)
            .assign(to: &$state)
    }
    
    public init(constantState: State) {
        state = constantState
    }
    
    open func send(_ action: Action) {}
}
