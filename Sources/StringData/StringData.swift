public let arr: InlineArray<3, StaticString> = [
    "apple",
    "banana",
    "cherry"
]

// Returns a Span<UInt8> over the UTF-8 bytes of arr[index].
@_lifetime(immortal)
public func search(_ index: Int) -> Span<UInt8> {
    let v = arr[index]
    let span = unsafe Span(_unsafeStart: v.utf8Start, count: v.utf8CodeUnitCount)
    return unsafe _overrideLifetime(span, copying: ())
}

/// Write s0 + sep + s1 into a freshly allocated String.
public func format(
    _ s0: borrowing Span<UInt8>,
    _ s1: borrowing Span<UInt8>
) -> String {
    let capacity = s0.count + s1.count + 1
    return String(unsafeUninitializedCapacity: capacity) { buf in
        var output = OutputSpan(buffer: buf, initializedCount: 0)
        output.append(copying:s0)
        output.append(UInt8(ascii: " "))
        output.append(copying:s1)
        return capacity
    }
}

extension OutputSpan where Element == UInt8 {
    @inline(__always)
    mutating func append(copying source: Span<UInt8>) {
        guard !source.isEmpty else { return }
        self.withUnsafeMutableBufferPointer { dst, dstCount in
            source.withUnsafeBufferPointer { src in
                let dstEnd = dstCount + src.count
                precondition(dstEnd <= dst.count, "OutputSpan capacity overflow")
                _ = dst[dstCount..<dstEnd].initialize(fromContentsOf: src)
                dstCount = dstEnd
            }
        }
    }
}

public func slow(_ s0: Int, _ s1: Int) -> String {
    let str0 = arr[s0]
    let str1 = arr[s1]
    return "\(str0) \(str1)"
}

// MARK: - C const array path

import CStringData

// reads from the C `const char *const cArr[3]`
public func cSearch(_ index: Int, body:(Span<UInt8>) -> ())  {
    precondition(index < 3)
    let ptr = cArrayElement(Int32(index))!
    let count = cArrayElementLength(Int32(index))
    ptr.withMemoryRebound(to: UInt8.self, capacity: count) { pointer in
        let span = Span(_unsafeStart: pointer, count: count)
        body(span)
    }
}
