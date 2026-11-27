extension W3C.WGSL {
    /// An expression.
    public indirect enum Expression: Sendable, Hashable {
        case name(String)
        case bool(Bool)
        case i32(Int32)
        case u32(UInt32)
        /// An `f32` by its bit pattern.
        case f32(UInt32)
        case call(String, [Self])
        /// A value constructed as a type: a conversion, or a vector or array of its components.
        case construct(Kind, [Self])
        /// The same bits as another type.
        case bitcast(Kind, Self)
        case member(Self, String)
        case element(Self, Self)
        case unary(Unary, Self)
        case binary(Self, Binary, Self)
    }
}

extension W3C.WGSL.Expression {
    /// A prefix operator, by its spelling.
    public enum Unary: String, Sendable, Hashable, CaseIterable {
        case minus = "-"
        case complement = "~"
        case not = "!"
    }

    /// An infix operator, by its spelling.
    public enum Binary: String, Sendable, Hashable, CaseIterable {
        case plus = "+"
        case minus = "-"
        case times = "*"
        case over = "/"
        case remainder = "%"
        case and = "&"
        case or = "|"
        case xor = "^"
        case left = "<<"
        case right = ">>"
        case equal = "=="
        case unequal = "!="
        case less = "<"
        case greater = ">"
        case atMost = "<="
        case atLeast = ">="
        case both = "&&"
        case either = "||"
    }
}

extension W3C.WGSL.Expression: CustomStringConvertible {
    public var description: String {
        switch self {
        case .name(let name): name
        case .bool(let value): value ? "true" : "false"
        case .i32(let value): value == .min ? "i32(-2147483648)" : "\(value)i"
        case .u32(let value): "\(value)u"
        case .f32(let bits): "bitcast<f32>(\(bits)u)"
        case .call(let name, let arguments): "\(name)(\(Self.list(arguments)))"
        case .construct(let kind, let arguments): "\(kind)(\(Self.list(arguments)))"
        case .bitcast(let kind, let value): "bitcast<\(kind)>(\(value))"
        case .member(let value, let name): "\(value.operand).\(name)"
        case .element(let value, let place): "\(value.operand)[\(place)]"
        case .unary(let sign, let value): "\(sign.rawValue)\(value.operand)"
        case .binary(let first, let sign, let second): "\(first.operand) \(sign.rawValue) \(second.operand)"
        }
    }

    private static func list(_ expressions: [Self]) -> String {
        expressions.map { $0.description }.joined(separator: ", ")
    }

    /// The text as an operand: in parentheses when it is compound, or a negative literal.
    private var operand: String {
        switch self {
        case .unary, .binary: "(\(self))"
        case .i32(let value) where value < 0: "(\(self))"
        default: description
        }
    }
}
