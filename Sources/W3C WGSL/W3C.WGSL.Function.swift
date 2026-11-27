extension W3C.WGSL {
    /// A function, or an entry point of a compute shader.
    public struct Function: Sendable, Hashable {
        /// The workgroup's size for an entry point of a compute shader, or nil for a function.
        public var compute: [Int]?
        public var result: Kind?
        public var name: String
        public var parameters: [Parameter]
        public var body: [Statement]

        public init(compute: [Int]? = nil, result: Kind? = nil, name: String, parameters: [Parameter], body: [Statement]) {
            self.compute = compute
            self.result = result
            self.name = name
            self.parameters = parameters
            self.body = body
        }
    }
}

extension W3C.WGSL.Function {
    /// A parameter, with the built-in value it is when it is one.
    public struct Parameter: Sendable, Hashable {
        public var kind: W3C.WGSL.Kind
        public var name: String
        public var builtin: Builtin?

        public init(_ kind: W3C.WGSL.Kind, _ name: String, _ builtin: Builtin? = nil) {
            self.kind = kind
            self.name = name
            self.builtin = builtin
        }
    }

    /// A built-in value an entry point is handed, by its spelling.
    public enum Builtin: String, Sendable, Hashable, CaseIterable {
        case globalInvocationID = "global_invocation_id"
        case localInvocationID = "local_invocation_id"
        case localInvocationIndex = "local_invocation_index"
        case workgroupID = "workgroup_id"
        case subgroupInvocationID = "subgroup_invocation_id"
        case subgroupSize = "subgroup_size"
    }

    /// The first line, without the body.
    var head: String {
        let list = parameters.map { parameter in
            (parameter.builtin.map { "@builtin(\($0.rawValue)) " } ?? "") + "\(parameter.name): \(parameter.kind)"
        }
        let attribute = compute.map { "@compute @workgroup_size(\($0.map(String.init).joined(separator: ", ")))\n" } ?? ""
        return attribute + "fn \(name)(\(list.joined(separator: ", ")))" + (result.map { " -> \($0)" } ?? "")
    }
}
