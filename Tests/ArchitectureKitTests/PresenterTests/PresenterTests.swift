import XCTest
import ArchitectureKit
import Combine

@MainActor
final class PresenterTests: XCTestCase {
    
    private let stringsRepository = StringsRepositoryFake()
    
    private lazy var presenter = Presenter(
        initialState: TestState(),
        reducer: TestReducer(
            stringsPublisher: stringsRepository.strings,
            fetchStrings: stringsRepository.fetchStrings
        )
    )
    
    func testReduceState() async {
        let expectedStrings = ["1", "2"]
        stringsRepository.result = .success(expectedStrings)
        await presenter.send(.loadStrings)
        await waitFor(0.1)
        XCTAssertEqual(presenter.state, .init(strings: expectedStrings))
    }
}


final class StringsRepositoryFake {
    
    var strings: AnyPublisher<[String], Never> {
        stringsPublisher.eraseToAnyPublisher()
    }
    
    private let stringsPublisher = CurrentValueSubject<[String], Never>([])
    var result: Result<[String], TestError> = .success([])
    
    func fetchStrings() async throws(TestError) {
        try? await Task.sleep(nanoseconds: 1000000000)
        switch result {
        case .success(let strings):
            stringsPublisher.send(strings)
        case .failure(let failure):
            throw failure
        }
    }
}
