# swift-w3c-wgsl

Use this package to build source text in WGSL, the WebGPU Shading Language of the W3C, from values, as a code generator does. Start from `W3C.WGSL.Source` and its `text`. It neither reads WGSL nor compiles it, and it has nothing of WebGPU itself: no adapter, device, queue or buffer.

## Laws

- Equal values give equal text, on every platform.
- A compound expression is put in parentheses wherever it is an operand, so the text means what the tree says without precedence.
- Integer literals are written with their type's suffix (`7i`, `7u`), and an `f32` literal as its bit pattern, so a constant survives exactly, NaN included.
- A name is written as it is given; the package does not check that names are declared, distinct or not reserved, nor that types agree.
