import XCTest
import ArchitectureKit
import Combine

@MainActor
final class ReducerTests: XCTestCase, ReducerTestCase {
    
    typealias State = TestState
    typealias Event = TestEvent
    typealias Action = TestAction
    
    private let stringsRepository = StringsRepositoryFake()
    
    private lazy var reducer = TestReducer(
        stringsPublisher: stringsRepository.strings,
        fetchStrings: stringsRepository.fetchStrings
    )
    
    var cancellables = Set<AnyCancellable>()
    
    func testApplyFunc() {
        let expectedStates: [TestState] = [
            .init(strings: ["1", "2"], isLoading: false, error: nil),
            .init(strings: [], isLoading: true, error: nil),
            .init(strings: [], isLoading: false, error: nil),
            .init(strings: [], isLoading: false, error: .error),
        ]
        var states: [TestState] = []
        states.append(reducer.apply(on: .init(), .didLoadStrings(["1", "2"])))
        states.append(reducer.apply(on: .init(), .didStartLoading))
        states.append(reducer.apply(on: .init(), .didFinishLoading))
        states.append(reducer.apply(on: .init(), .didFailLoadingStrings(.error)))
        XCTAssertEqual(states, expectedStates)
    }
    
    func testTransformFunc() async {
        await testTransform(
            transform: reducer.transform,
            action: .loadStrings,
            state: .init(),
            expectedEvents: [.didStartLoading, .didFinishLoading]
        )
    }
}
