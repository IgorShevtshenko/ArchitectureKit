import SwiftUI
import Combine

@MainActor
public final class Presenter<R: Reducer>: ObservableObject {
    
    @Published public private(set) var state: R.State
    
    private let reducer: R
    
    private let eventSender = PassthroughSubject<R.Event, Never>()
    
    private var tasks: [Task<Void, Never>] = []
    
    public init(initialState: R.State, reducer: R) {
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
    
    public func send(_ action: R.Action) async {
        await reducer.transform(action, state: state, sendEvent: eventSender.send)
    }
}

public extension Presenter {
    
    func send(_ action: R.Action) -> Task<Void, Never> {
        Task {
            await send(action)
        }
    }
}
