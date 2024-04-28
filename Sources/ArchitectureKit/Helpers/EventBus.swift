import Combine
import Utils

public class EventBus<T> {

    public var event: ProtectedPublisher<T> {
        _event.eraseToAnyPublisher()
    }

    private let _event = PassthroughSubject<T, Never>()

    public init() {}

    public func send(_ event: T) {
        _event.send(event)
    }
}
