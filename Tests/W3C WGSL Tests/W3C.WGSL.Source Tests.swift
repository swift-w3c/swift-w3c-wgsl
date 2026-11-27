import Testing
import W3C_WGSL

enum `WGSL Tests` {}

extension `WGSL Tests` {
    @Suite
    struct Source {
        @Test
        func `An entry point is written with its bindings, built-ins and operands in parentheses`() {
            let sum = W3C.WGSL.Expression.binary(.binary(.name("a"), .plus, .u32(1)), .times, .u32(2))
            let entry = W3C.WGSL.Function(
                compute: [16, 16, 1],
                name: "run",
                parameters: [.init(.vector(.u32, 3), "id", .globalInvocationID)],
                body: [
                    .let("a", .element(.name("heap"), .member(.name("id"), "x"))),
                    .if(.binary(.name("a"), .equal, .u32(0)), [.return(nil)], else: [.assign(.element(.name("heap"), .u32(0)), sum)]),
                    .loop([.break]),
                ]
            )
            let source = W3C.WGSL.Source([
                .variable(.storage(written: true), .array(.u32, nil), "heap", binding: .init(group: 0, binding: 0)),
                .variable(.private, .array(.u32, 4), "stack"),
                .constant(.f32, "one", .f32(0x3F80_0000)),
                .function(entry),
            ])
            #expect(
                source.text == """
                    @group(0) @binding(0) var<storage, read_write> heap: array<u32>;

                    var<private> stack: array<u32, 4>;

                    const one: f32 = 0x1.0p0f;

                    @compute @workgroup_size(16, 16, 1)
                    fn run(@builtin(global_invocation_id) id: vec3<u32>) {
                        let a = heap[id.x];
                        if (a == 0u) {
                            return;
                        } else {
                            heap[0u] = (a + 1u) * 2u;
                        }
                        loop {
                            break;
                        }
                    }

                    """
            )
        }

        @Test
        func `A negative integer is an operand in parentheses, and the least one is written by conversion`() {
            #expect(W3C.WGSL.Expression.unary(.minus, .i32(-3)).description == "-(-3i)")
            #expect(W3C.WGSL.Expression.i32(.min).description == "i32(-2147483648)")
        }

        @Test
        func `An f32 is written exactly in hexadecimal, and one without a literal as a bit cast`() {
            func text(_ value: Float) -> String { W3C.WGSL.Expression.f32(value.bitPattern).description }
            #expect(text(12) == "0x1.8p3f")
            #expect(text(-0.1) == "-0x1.99999ap-4f")
            #expect(text(.leastNonzeroMagnitude) == "0x0.000002p-126f")
            #expect(text(-Float.zero) == "-0.0f")
            #expect(text(.infinity) == "bitcast<f32>(2139095040u)")
        }
    }
}
