extension W3C.WGSL {
    /// Source text: declarations in order.
    public struct Source: Sendable, Hashable {
        public var items: [Item]

        public init(_ items: [Item]) {
            self.items = items
        }
    }
}

extension W3C.WGSL.Source {
    /// A declaration.
    public enum Item: Sendable, Hashable {
        /// An extension the text needs, such as `f16`.
        case enable(String)
        /// A variable in an address space, bound to a group and binding where it comes from outside.
        case variable(W3C.WGSL.Space?, W3C.WGSL.Kind, String, binding: Binding? = nil)
        /// A constant of a type, such as an array of words.
        case constant(W3C.WGSL.Kind, String, W3C.WGSL.Expression)
        case structure(W3C.WGSL.Structure)
        case function(W3C.WGSL.Function)
    }

    /// Where a variable from outside is bound: its group and its binding in it.
    public struct Binding: Sendable, Hashable {
        public var group: Int
        public var binding: Int

        public init(group: Int, binding: Int) {
            self.group = group
            self.binding = binding
        }
    }

    /// The text.
    public var text: String {
        items.map { item in
            switch item {
            case .enable(let name): "enable \(name);"
            case .variable(let space, let kind, let name, let binding):
                (binding.map { "@group(\($0.group)) @binding(\($0.binding)) " } ?? "") + "var" + (space.map { "<\($0)>" } ?? "") + " \(name): \(kind);"
            case .constant(let kind, let name, let value): "const \(name): \(kind) = \(value);"
            case .structure(let structure):
                (["struct \(structure.name) {"] + structure.members.map { "    " + ($0.attribute.map { "\($0) " } ?? "") + "\($0.name): \($0.kind)," } + ["}"]).joined(separator: "\n")
            case .function(let function):
                ([function.head + " {"] + function.body.flatMap { $0.lines(1) } + ["}"]).joined(separator: "\n")
            }
        }
        .joined(separator: "\n\n") + "\n"
    }
}
