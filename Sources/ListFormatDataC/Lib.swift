import CListFormatData

public let patternCount = 344
public let localeCount = 329

package func cPattern<Result>(_ index: Int, body: (Span<UInt8>) -> Result) -> Result {
    let ptr = listFormatPattern(Int32(index))!
    let count = listFormatPatternLength(Int32(index))
    return ptr.withMemoryRebound(to: UInt8.self, capacity: count) { pointer in
        let span = Span(_unsafeStart: pointer, count: count)
        return body(span)
    }
}

package func cLocale<Result>(_ index: Int, body: (Span<UInt8>) -> Result) -> Result {
    let ptr = listFormatLocale(Int32(index))!
    let count = listFormatLocaleLength(Int32(index))
    return ptr.withMemoryRebound(to: UInt8.self, capacity: count) { pointer in
        let span = Span(_unsafeStart: pointer, count: count)
        return body(span)
    }
}
