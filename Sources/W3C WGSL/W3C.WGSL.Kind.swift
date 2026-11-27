extension W3C.WGSL {
    /// A type.
    public indirect enum Kind: Sendable, Hashable {
        case scalar(Scalar)
        /// A vector of two to four scalars.
        case vector(Scalar, Int)
        /// An array of a number of elements, or of as many as its buffer holds.
        case array(Kind, Int?)
        case structure(String)
        /// A texture of two dimensions that is only written, in a texel format such as `rgba8unorm`.
        case storageTexture(String)
        /// A scalar that atomic operations read and write.
        case atomic(Scalar)
    }
}

extension W3C.WGSL.Kind {
    public static let bool = Self.scalar(.bool)
    public static let i32 = Self.scalar(.i32)
    public static let u32 = Self.scalar(.u32)
    public static let f32 = Self.scalar(.f32)
}

extension W3C.WGSL.Kind: CustomStringConvertible {
    public var description: String {
        switch self {
        case .scalar(let scalar): scalar.rawValue
        case .vector(let scalar, let count): "vec\(count)<\(scalar.rawValue)>"
        case .array(let kind, let count): count.map { "array<\(kind), \($0)>" } ?? "array<\(kind)>"
        case .structure(let name): name
        case .storageTexture(let format): "texture_storage_2d<\(format), write>"
        case .atomic(let scalar): "atomic<\(scalar.rawValue)>"
        }
    }
}
