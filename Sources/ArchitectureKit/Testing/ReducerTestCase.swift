import Combine
import XCTest

@MainActor
public protocol ReducerTestCase: XCTestCase where Event: Equatable {

    associatedtype State
    associatedtype Event
    associatedtype Action
    
    var cancellables: Set<AnyCancellable> { get set }
}

public extension ReducerTestCase {
    
    @MainActor
    func testTransform(
        transform: @MainActor (Action, State, (Event) -> Void) async -> Void,
        action: Action,
        state: State,
        expectedEvents: [Event]
    ) async {
        var events = [Event]()
        let eventsPublisher = PassthroughSubject<Event, Never>()
        eventsPublisher
            .sink { event in
                events.append(event)
            }
            .store(in: &cancellables)
        await transform(action, state, eventsPublisher.send)
        await waitFor(0.5)
        XCTAssertEqual(expectedEvents, events)
    }
}

public extension XCTestCase {
    
    @MainActor
    func waitFor(_ seconds: Double) async {
        try? await Task.sleep(nanoseconds: 1_000_000_000 * UInt64(seconds))
    }
}
