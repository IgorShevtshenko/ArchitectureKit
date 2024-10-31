import SwiftUI

@MainActor
public final class Presenter<
    State,
    Action,
    Event: Sendable,
    R
>: ObservableObject where R: Reducer, R.Event == Event, R.State == State, R.Action == Action {
    
    public typealias State = State
    public typealias Action = Action
    
    @Published public private(set) var state: State
    
    private let reducer: R
    
    private var tasks: [Task<Void, Never>] = []
    
    public init(initialState: State, reducer: R) {
        self.state = initialState
        self.reducer = reducer
        
        reducer.prependActions.forEach { action in
            tasks.append(send(action))
        }
    }
    
    public func send(_ action: Action) async {
        let event = await reducer.transform(action, state: state)
        reducer.apply(event, on: &state)
    }
}

public extension Presenter {
    
    func send(_ action: Action) -> Task<Void, Never> {
        Task {
            await send(action)
        }
    }
}
