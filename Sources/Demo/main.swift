import StringData


@_optimize(none)
func blackhole(_ str: String) {

}



print("\n==Demo==")
for _ in 0...1000 {
    let ab = format(search(0), search(1))
    blackhole(ab)
}


for _ in 0...1000 {
    let ab_slow = slow(0, 1)
    blackhole(ab_slow)
}

