import ArchitectureKit
import Combine
import Utils

enum TestError: Error {
    case error
}

struct TestState: Equatable {
    var strings = [String]()
    var isLoading = false
    var error: TestError?
}

enum TestAction {
    case start
    case loadStrings
}

enum TestEvent: Equatable {
    case didLoadStrings([String])
    case didStartLoading
    case didFinishLoading
    case didFailLoadingStrings(TestError)
}

struct TestReducer: Reducer {
    
    let prependActions = [TestAction.start]
    
    let stringsPublisher: ProtectedPublisher<[String]>
    let fetchStrings: () async throws(TestError) -> Void

    func transform(
        _ action: TestAction,
        state: TestState,
        sendEvent: EventSender<TestEvent>
    ) async {
        switch action {
        case .start:
            for await strings in stringsPublisher.values {
                sendEvent(.didLoadStrings(strings))
            }
        case .loadStrings:
            do {
                sendEvent(.didStartLoading)
                try await fetchStrings()
                sendEvent(.didFinishLoading)
            } catch {
                sendEvent(.didFailLoadingStrings(error))
            }
        }
    }
    
    func apply(on state: TestState, _ event: TestEvent) -> TestState {
        var state = state
        switch event {
        case .didLoadStrings(let strings):
            state.strings = strings
        case .didStartLoading:
            state.isLoading = true
        case .didFinishLoading:
            state.isLoading = false
        case .didFailLoadingStrings(let testError):
            state.error = testError
        }
        return state
    }
}
