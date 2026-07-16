// MARK: - C const array path

import CStringData
let arr: InlineArray<3, StaticString> = [
    "apple",
    "banana",
    "cherry",
]

// Returns a Span<UInt8> over the UTF-8 bytes of arr[index].
@_lifetime(immortal)
package func search(_ index: Int) -> Span<UInt8> {
    let v = arr[index]
    let span = unsafe Span(_unsafeStart: v.utf8Start, count: v.utf8CodeUnitCount)
    return unsafe _overrideLifetime(span, copying: ())
}

package func search2<Result>(_ index: Int, body: (Span<UInt8>) -> Result) -> Result {
    let v = arr[index]
    let span = Span(_unsafeStart: v.utf8Start, count: v.utf8CodeUnitCount)
    return body(span)
}

package func search3(_ index: Int) -> StaticString {
    return arr[index]
}

// reads from the C `const char *const cArr[3]`
package func cSearch<Result>(_ index: Int, body:(Span<UInt8>) -> (Result)) -> Result  {
    precondition(index < 3)
    let ptr = cArrayElement(Int32(index))!
    let count = cArrayElementLength(Int32(index))
    return ptr.withMemoryRebound(to: UInt8.self, capacity: count) { pointer in
        let span = Span(_unsafeStart: pointer, count: count)
        return body(span)
    }
}

