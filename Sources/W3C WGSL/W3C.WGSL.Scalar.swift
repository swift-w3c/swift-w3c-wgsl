extension W3C.WGSL {
    /// A scalar type, by its name in the language.
    public enum Scalar: String, Sendable, Hashable, CaseIterable {
        case bool
        case i32
        case u32
        case f32
        case f16
    }
}
