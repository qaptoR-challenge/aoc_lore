extends SceneTree

const REPS: int = 50
const WARMUP_MS: int = 200

func load_corpus() -> String:
    var paths = ["tests/respeedtest/corpus.txt", "corpus.txt"]
    for path in paths:
        if FileAccess.file_exists(path):
            var f = FileAccess.open(path, FileAccess.READ)
            if f != null:
                return f.get_as_text()
    push_error("Could not find corpus.txt in expected locations")
    return ""

func bench(callable: Callable, reps: int, warmup_ms: int) -> Dictionary:
    if warmup_ms > 0:
        var start_warmup = Time.get_ticks_msec()
        while Time.get_ticks_msec() - start_warmup < warmup_ms:
            pass
    callable.call()
    var times: Array[int] = []
    var sum_us: int = 0
    for i in range(reps):
        var t0 = Time.get_ticks_usec()
        callable.call()
        var t1 = Time.get_ticks_usec()
        var dt = t1 - t0
        times.append(dt)
        sum_us += dt
    times.sort()
    var min_val = times[0]
    var max_val = times[-1]
    var median_val: float
    var mid = times.size() / 2
    if times.size() % 2 == 1:
        median_val = float(times[mid])
    else:
        median_val = float(times[mid - 1] + times[mid]) / 2.0
    var mean_val = float(sum_us) / float(reps)
    return {
        "min": min_val,
        "median": int(round(median_val)),
        "mean": mean_val,
        "max": max_val
    }

func print_row(name: String, matches: int, stats: Dictionary) -> void:
    print("%-30s %10d %12d %12d %12.1f %12d" % [
        name, matches, stats["min"], stats["median"], stats["mean"], stats["max"]
    ])

func _init() -> void:
    var corpus = load_corpus()
    if corpus == "":
        quit(1)
        return

    print("=========================================================================================")
    print("                           REGEX SPEED BENCHMARK (GDScript)                              ")
    print("=========================================================================================")
    print("Corpus size: %d bytes | Reps: %d | Warmup: %d ms" % [corpus.length(), REPS, WARMUP_MS])
    print("-----------------------------------------------------------------------------------------")
    print("%-30s %10s %12s %12s %12s %12s" % [
        "Benchmark", "Matches", "Min(us)", "Median(us)", "Mean(us)", "Max(us)"
    ])
    print("-----------------------------------------------------------------------------------------")

    # [1] Search (First Email)
    var r1 = RegEx.create_from_string("[\\w.+-]+@[\\w-]+\\.[\\w.-]+")
    var m1 = 1 if r1.search(corpus) != null else 0
    var s1 = bench(func(): return r1.search(corpus), REPS, WARMUP_MS)
    print_row("[1] Search (First Email)", m1, s1)

    # [2] Find All (Dates)
    var r2 = RegEx.create_from_string("\\b\\d{4}-\\d{2}-\\d{2}\\b")
    var m2 = r2.search_all(corpus).size()
    var s2 = bench(func(): return r2.search_all(corpus), REPS, WARMUP_MS)
    print_row("[2] Find All (Dates)", m2, s2)

    # [3] Find All (URLs)
    var r3 = RegEx.create_from_string("https?://[^\\s/$.?#].[^\\s]*")
    var m3 = r3.search_all(corpus).size()
    var s3 = bench(func(): return r3.search_all(corpus), REPS, WARMUP_MS)
    print_row("[3] Find All (URLs)", m3, s3)

    # [4] Captures (Key-Values)
    var r4 = RegEx.create_from_string("(\\w+)\\s*=\\s*\"([^\"]*)\"")
    var m4 = r4.search_all(corpus).size()
    var s4 = bench(func():
        var matches = r4.search_all(corpus)
        var count: int = 0
        for m in matches:
            var k = m.get_string(1)
            var v = m.get_string(2)
            if k != "" and v != "":
                count += 1
        return count
    , REPS, WARMUP_MS)
    print_row("[4] Captures (Key-Values)", m4, s4)

    # [5] Replace All (Emails)
    var r5 = RegEx.create_from_string("[\\w.+-]+@[\\w-]+\\.[\\w.-]+")
    var m5 = r5.search_all(corpus).size()
    var s5 = bench(func(): return r5.sub(corpus, "user@domain.com", true), REPS, WARMUP_MS)
    print_row("[5] Replace All (Emails)", m5, s5)

    # [6] Alternation (Log Levels)
    var r6 = RegEx.create_from_string("\\b(?:error|warn|info|debug|trace|fatal)\\b")
    var m6 = r6.search_all(corpus).size()
    var s6 = bench(func(): return r6.search_all(corpus), REPS, WARMUP_MS)
    print_row("[6] Alternation (Log Levels)", m6, s6)

    # [7] Quoted Strings (Escapes)
    var r7 = RegEx.create_from_string("\"[^\"\\\\]*(?:\\\\.[^\"\\\\]*)*\"")
    var m7 = r7.search_all(corpus).size()
    var s7 = bench(func(): return r7.search_all(corpus), REPS, WARMUP_MS)
    print_row("[7] Quoted Strings (Escapes)", m7, s7)

    # [8] Backreference (Dup Words)
    var r8 = RegEx.create_from_string("\\b(\\w+)\\s+\\1\\b")
    var m8 = r8.search_all(corpus).size()
    var s8 = bench(func(): return r8.search_all(corpus), REPS, WARMUP_MS)
    print_row("[8] Backreference (Dup Words)", m8, s8)

    print("=========================================================================================")
    quit(0)
