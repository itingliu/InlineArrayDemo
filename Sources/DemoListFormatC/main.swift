import ListFormatDataC


@_optimize(none)
func blackhole(_ x: Int) {}

func checksumC() -> Int {
    var total = 0
    for i in 0..<patternCount {
        cPattern(i) { span in total += span.count }
    }
    for i in 0..<localeCount {
        cLocale(i) { span in total += span.count }
    }
    return total
}

let result = checksumC()
blackhole(result)
print(result)
