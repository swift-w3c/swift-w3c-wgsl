extension W3C.WGSL {
    /// A function, or an entry point of a compute shader or of a stage that draws.
    public struct Function: Sendable, Hashable {
        /// The workgroup's size for an entry point of a compute shader, or nil.
        public var compute: [Int]?
        /// The stage an entry point that draws is, or nil.
        public var stage: Stage?
        public var result: Kind?
        /// What an entry point's result is, when it is not a structure whose members say so.
        public var given: Attribute?
        public var name: String
        public var parameters: [Parameter]
        public var body: [Statement]

        public init(
            compute: [Int]? = nil,
            stage: Stage? = nil,
            result: Kind? = nil,
            given: Attribute? = nil,
            name: String,
            parameters: [Parameter],
            body: [Statement]
        ) {
            self.compute = compute
            self.stage = stage
            self.result = result
            self.given = given
            self.name = name
            self.parameters = parameters
            self.body = body
        }
    }
}

extension W3C.WGSL.Function {
    /// A stage of a pipeline that draws, by its spelling.
    public enum Stage: String, Sendable, Hashable, CaseIterable {
        case vertex
        case fragment
    }

    /// What an entry point is handed in a parameter, or gives in a result or a member of it.
    public enum Attribute: Sendable, Hashable {
        /// A built-in value.
        case builtin(Builtin)
        /// A value one stage hands the next at a numbered place, not interpolated where `flat`.
        case location(Int, flat: Bool = false)
    }

    /// A parameter, with what an entry point is handed in it.
    public struct Parameter: Sendable, Hashable {
        public var kind: W3C.WGSL.Kind
        public var name: String
        public var attribute: Attribute?

        public init(_ kind: W3C.WGSL.Kind, _ name: String, _ builtin: Builtin? = nil) {
            self.kind = kind
            self.name = name
            self.attribute = builtin.map(Attribute.builtin)
        }

        public init(_ kind: W3C.WGSL.Kind, _ name: String, at attribute: Attribute) {
            self.kind = kind
            self.name = name
            self.attribute = attribute
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
        case vertexIndex = "vertex_index"
        case instanceIndex = "instance_index"
        case position = "position"
    }

    /// The first line, without the body.
    var head: String {
        let list = parameters.map { parameter in
            (parameter.attribute.map { "\($0) " } ?? "") + "\(parameter.name): \(parameter.kind)"
        }
        let attribute =
            compute.map { "@compute @workgroup_size(\($0.map(String.init).joined(separator: ", ")))\n" } ?? stage.map { "@\($0.rawValue)\n" } ?? ""
        let gives = result.map { " -> " + (given.map { "\($0) " } ?? "") + "\($0)" } ?? ""
        return attribute + "fn \(name)(\(list.joined(separator: ", ")))" + gives
    }
}

extension W3C.WGSL.Function.Attribute: CustomStringConvertible {
    public var description: String {
        switch self {
        case .builtin(let builtin): "@builtin(\(builtin.rawValue))"
        case .location(let place, let flat): "@location(\(place))" + (flat ? " @interpolate(flat)" : "")
        }
    }
}
