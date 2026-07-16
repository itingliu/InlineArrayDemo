import StringData


@_optimize(none)
func blackhole(_ str: String) {

}

let runs = 0...1000_000

print("\n==Demo==")
// InlineArray of StaticStrings
for _ in runs {
    let ab = format(search(0), search(1))
    blackhole(ab)
}

try await Task.sleep(nanoseconds: 300_000_000)

// Naive implementation using string
for _ in runs {
    let ab_slow = slow(0, 1)
    blackhole(ab_slow)
}

try await Task.sleep(nanoseconds: 300_000_000)

// C const arrays
for _ in runs {
    cSearch(0) { s1 in
        cSearch(1) { s2 in
            let ab_c = format(s1, s2)
            blackhole(ab_c)
        }
    }
}

