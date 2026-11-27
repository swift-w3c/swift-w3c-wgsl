extension W3C.WGSL {
    /// A structure: named members of types, in order.
    public struct Structure: Sendable, Hashable {
        public var name: String
        public var members: [Member]

        public init(name: String, members: [Member]) {
            self.name = name
            self.members = members
        }
    }
}

extension W3C.WGSL.Structure {
    public struct Member: Sendable, Hashable {
        public var kind: W3C.WGSL.Kind
        public var name: String

        public init(_ kind: W3C.WGSL.Kind, _ name: String) {
            self.kind = kind
            self.name = name
        }
    }
}
