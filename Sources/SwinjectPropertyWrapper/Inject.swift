import Swinject

@propertyWrapper
public enum Inject<Value> {

    case uninitialized(name: String?, resolver: Resolver?)
    case initialized(Value)

    public init(name: String? = nil, resolver: Resolver? = nil) {
        self = .uninitialized(name: name, resolver: resolver)
    }

    @MainActor public var wrappedValue: Value {
        mutating get {
            switch self {
            case .uninitialized(let name, let resolver):
                guard let resolver = resolver ?? InjectSettings.resolver else {
                    preconditionFailure("Make sure InjectSettings.resolver is set!")
                }
                guard let value = resolver.resolve(Value.self, name: name) else {
                    preconditionFailure("Could not resolve non-optional \(Value.self)")
                }
                self = .initialized(value)
                return value
            case .initialized(let value):
                return value
            }
        }
        set {
            self = .initialized(newValue)
        }
    }
}
