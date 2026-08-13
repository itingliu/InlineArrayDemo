import ListFormatData

@_optimize(none)
func blackhole(_ x: Int) {}

func checksumInline() -> Int {
    var total = 0
    for i in 0..<344 {
        total += searchPattern(i).count
    }

    for i in 0..<329 {
        total += searchLocale(i).count
    }

    return total
}


let result = checksumInline()
blackhole(result)
print(result)
