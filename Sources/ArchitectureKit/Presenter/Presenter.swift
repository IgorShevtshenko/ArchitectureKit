import SwiftUI
import Combine

@MainActor
public final class Presenter<
    State,
    Action,
    Event: Sendable,
    R
>: ObservableObject where
    R: Reducer,
    R.Event == Event,
    R.State == State,
    R.Action == Action
{
    
    @Published public private(set) var state: State
    
    private let reducer: R
    
    private let eventSender = PassthroughSubject<Event, Never>()
    
    private var tasks: [Task<Void, Never>] = []
    
    public init(initialState: State, reducer: R) {
        self.state = initialState
        self.reducer = reducer
        
        eventSender
            .scan(initialState, reducer.apply)
            .prepend(initialState)
            .assign(to: &$state)
        
        reducer.prependActions.forEach { action in
            tasks.append(send(action))
        }
    }
    
    public func send(_ action: Action) async {
        await reducer.transform(action, state: state, sendEvent: eventSender.send)
    }
}

public extension Presenter {
    
    func send(_ action: Action) -> Task<Void, Never> {
        Task {
            await send(action)
        }
    }
}
