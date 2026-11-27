extension W3C.WGSL {
    /// An address space a variable declared outside functions lives in, by its spelling.
    public enum Space: Sendable, Hashable {
        /// One copy for each invocation, which only it reads and writes.
        case `private`
        /// Shared by the invocations of a workgroup.
        case workgroup
        /// Constants bound from a buffer.
        case uniform
        /// A buffer bound for reading, or for reading and writing.
        case storage(written: Bool)
    }
}

extension W3C.WGSL.Space: CustomStringConvertible {
    public var description: String {
        switch self {
        case .private: "private"
        case .workgroup: "workgroup"
        case .uniform: "uniform"
        case .storage(let written): written ? "storage, read_write" : "storage, read"
        }
    }
}
