import Essentials

@_optimize(none)
func blackhole(_ str: String) {
//    print(str)
}

let runs = 0...1000_000

print("\n==InlineArray of StaticStrings==")
// InlineArray of StaticStrings
for _ in runs {
    let ab = format(0, 1)
    blackhole(ab)
}

try await Task.sleep(nanoseconds: 300_000_000)

// InlineArray of StaticStrings, non escape
print("\n==InlineArray of StaticStrings, loaded with closure==")
for _ in runs {
    let ab = format2(0, 1)
    blackhole(ab)
}

try await Task.sleep(nanoseconds: 300_000_000)

// Naive implementation using string
print("\n==Naive==")
for _ in runs {
    let ab_slow = formatNaive(0, 1)
    blackhole(ab_slow)
}

try await Task.sleep(nanoseconds: 300_000_000)

print("\n==C string==")
// C const arrays
for _ in runs {
    let ab_slow = formatC(0, 1)
    blackhole(ab_slow)
}

