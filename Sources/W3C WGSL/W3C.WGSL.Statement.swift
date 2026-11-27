extension W3C.WGSL {
    /// A statement.
    public indirect enum Statement: Sendable, Hashable {
        /// A name for a value that does not change.
        case `let`(String, Expression)
        /// A variable of a type, with its first value or the type's zero.
        case `var`(Kind, String, Expression?)
        case assign(Expression, Expression)
        /// A call whose result, if any, is not used.
        case call(String, [Expression])
        case `if`(Expression, [Self], else: [Self] = [])
        /// A loop left only by `break` or `return`.
        case loop([Self])
        case `break`
        case `continue`
        case `return`(Expression?)
    }
}

extension W3C.WGSL.Statement {
    /// The statement's lines, each indented by `depth` steps.
    func lines(_ depth: Int) -> [String] {
        let indent = String(repeating: "    ", count: depth)
        func inner(_ statements: [Self]) -> [String] { statements.flatMap { $0.lines(depth + 1) } }
        switch self {
        case .let(let name, let value): return [indent + "let \(name) = \(value);"]
        case .var(let kind, let name, let value): return [indent + "var \(name): \(kind)" + (value.map { " = \($0)" } ?? "") + ";"]
        case .assign(let place, let value): return [indent + "\(place) = \(value);"]
        case .call(let name, let arguments): return [indent + "\(W3C.WGSL.Expression.call(name, arguments));"]
        case .if(let condition, let then, let otherwise):
            let tail = otherwise.isEmpty ? [indent + "}"] : [indent + "} else {"] + inner(otherwise) + [indent + "}"]
            return [indent + "if (\(condition)) {"] + inner(then) + tail
        case .loop(let body): return [indent + "loop {"] + inner(body) + [indent + "}"]
        case .break: return [indent + "break;"]
        case .continue: return [indent + "continue;"]
        case .return(let value): return [indent + "return" + (value.map { " \($0)" } ?? "") + ";"]
        }
    }
}
