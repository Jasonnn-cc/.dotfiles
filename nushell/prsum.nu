# prsum.nu
#
# Summarize the "lines changed" of a pull request as a table: one row per
# language, split into `source` and `test` files, with raw added/removed line
# counts and each language's share of the total churn.

# Turn a path into a language name, mostly from its extension.
def lang-of [path: string]: nothing -> string {
    let name = ($path | path basename | str lowercase)

    # Extension-less files that still have a well-known language.
    let by_name = {
        makefile: "make"
        dockerfile: "docker"
        justfile: "just"
    }
    if ($name in ($by_name | columns)) {
        return ($by_name | get $name)
    }

    let ext = ($name | path parse | get extension)
    if ($ext | is-empty) {
        return "other"
    }

    let by_ext = {
        nu: "nushell"
        rs: "rust"
        go: "go"
        py: "python"
        pyi: "python"
        rb: "ruby"
        js: "javascript"
        mjs: "javascript"
        cjs: "javascript"
        jsx: "javascript"
        ts: "typescript"
        tsx: "typescript"
        c: "c"
        h: "c"
        cc: "c++"
        cpp: "c++"
        cxx: "c++"
        hpp: "c++"
        cs: "c#"
        java: "java"
        kt: "kotlin"
        kts: "kotlin"
        swift: "swift"
        sh: "shell"
        bash: "shell"
        zsh: "shell"
        fish: "fish"
        lua: "lua"
        vim: "vim script"
        qml: "qml"
        css: "css"
        scss: "scss"
        html: "html"
        md: "markdown"
        json: "json"
        jsonc: "json"
        yaml: "yaml"
        yml: "yaml"
        toml: "toml"
        xml: "xml"
        sql: "sql"
        php: "php"
        ex: "elixir"
        exs: "elixir"
        erl: "erlang"
        hs: "haskell"
        scala: "scala"
        clj: "clojure"
        dart: "dart"
        r: "r"
        zig: "zig"
        ron: "ron"
        nix: "nix"
    }

    if ($ext in ($by_ext | columns)) {
        return ($by_ext | get $ext)
    }
    $ext
}

# True when a file looks like a test: any path component contains a `test`
# token, matched across both `_`/`-`/`.` separators and camelCase boundaries
# (so `foo_test.go`, `Foo.test.ts` and `FooTest.java` match, `latest.nu` does not).
def is-test [path: string]: nothing -> bool {
    $path
    | path split
    | any {|part|
        let tokens = (
            $part
            | str replace --all --regex '([a-z0-9])([A-Z])' '$1 $2'
            | str replace --all --regex '[^A-Za-z0-9]+' ' '
            | split row ' '
            | where {|t| $t | is-not-empty }
            | each {|t| $t | str lowercase }
        )
        $tokens | any {|t| $t | str starts-with 'test' }
    }
}

# The repo's default branch, used when no base ref is given.
def default-branch [] {
    # NOTE: capture git via `complete` rather than `do -i { ... }` — capturing a
    # failed external command from `do -i` silently aborts the whole pipeline.
    let origin_head = (git symbolic-ref --quiet --short refs/remotes/origin/HEAD | complete)
    if $origin_head.exit_code == 0 {
        let branch = ($origin_head.stdout | str trim)
        if ($branch | is-not-empty) {
            return ($branch | str replace --regex '^origin/' '')
        }
    }

    for cand in [main master trunk develop] {
        let found = (git rev-parse --verify --quiet $"refs/heads/($cand)" | complete)
        if $found.exit_code == 0 and (($found.stdout | str trim) | is-not-empty) {
            return $cand
        }
    }

    error make {msg: "prsum: cannot determine the default branch, pass a base ref explicitly"}
}

# Aggregate a set of changed-file rows into one row per language.
def summarize [rows: list, group: string, --total: int]: nothing -> table {
    if ($rows | is-empty) {
        return []
    }

    $rows
    | group-by lang
    | transpose lang agg
    | each {|g|
        let added = ($g.agg | get added | math sum)
        let deleted = ($g.agg | get deleted | math sum)
        let lines = ($added + $deleted)
        {
            group: $group
            language: $g.lang
            files: ($g.agg | length)
            added: $added
            deleted: $deleted
            lines: $lines
            percent: (
                if $total == 0 {
                    0.0
                } else {
                    (($lines | into float) / ($total | into float)) * 100
                    | math round --precision 1
                }
            )
        }
    }
    | sort-by lines --reverse
}

# Run `git diff --numstat` with extra args, returning its lines and surfacing
# git's stderr as an error instead of silently yielding nothing.
def diff-lines [args: list]: nothing -> list {
    let res = (git diff --numstat --no-renames ...$args | complete)
    if $res.exit_code != 0 {
        error make {msg: $"prsum: git diff failed: ($res.stderr | str trim)"}
    }
    $res.stdout | lines
}

# Summarize the lines changed by a branch against a base ref (default: the
# repo's default branch), one row per language split into source and test files.
@example "Summarize the current branch against the default branch" {prsum}
@example "Summarize against an explicit base" {prsum origin/develop}
@example "Summarize all uncommitted changes" {prsum --uncommitted}
export def main [
    base?: string  # Base ref to diff against (default: the repo's default branch)
    --uncommitted(-u)  # Summarize all uncommitted changes (staged, unstaged and untracked) instead of a branch diff
]: nothing -> table {
    let in_repo = (git rev-parse --is-inside-work-tree | complete)
    if $in_repo.exit_code != 0 or ($in_repo.stdout | str trim) != "true" {
        error make {msg: "prsum: not inside a git repository"}
    }

    # Uncommitted mode diffs the worktree against HEAD, which rolls staged and
    # unstaged edits into one line per file. An unborn HEAD has nothing to diff
    # against, so combine the index and worktree diffs instead.
    let tracked = if $uncommitted {
        if ($base | is-not-empty) {
            error make {msg: "prsum: a base ref cannot be combined with --uncommitted"}
        }
        let has_head = (git rev-parse --verify --quiet HEAD | complete | get exit_code) == 0
        if $has_head {
            diff-lines ["HEAD"]
        } else {
            diff-lines [] | append (diff-lines ["--cached"])
        }
    } else {
        let base = (if ($base | is-not-empty) { $base } else { default-branch })
        diff-lines [$"($base)...HEAD"]
    }

    # In uncommitted mode also count untracked files (all lines count as added).
    # Diffing against /dev/null reuses git's line-counting and binary detection.
    let untracked = if $uncommitted {
        git ls-files --others --exclude-standard
        | lines
        | where {|f| $f | is-not-empty }
        | each {|f|
            let added = (
                git diff --numstat --no-index -- /dev/null $f
                | complete
                | get stdout
                | str trim
                | split row "\t"
                | first
            )
            $"($added)\t0\t($f)"
        }
    } else {
        []
    }

    # Parse to one row per path, summing across the (possible) two diffs so a
    # file with both staged and unstaged edits still counts as one file.
    let parsed = (
        $tracked | append $untracked
        | parse --regex '^(?<added>\d+|-)\t(?<deleted>\d+|-)\t(?<path>.+)$'
        | where added != '-'
        | each {|r|
            {
                path: $r.path
                added: ($r.added | into int)
                deleted: ($r.deleted | into int)
            }
        }
    )

    let rows = if ($parsed | is-empty) {
        []
    } else {
        $parsed
        | group-by path
        | transpose path edits
        | each {|g|
            {
                path: $g.path
                lang: (lang-of $g.path)
                test: (is-test $g.path)
                added: ($g.edits | get added | math sum)
                deleted: ($g.edits | get deleted | math sum)
            }
        }
    }

    let total = (
        if ($rows | is-empty) {
            0
        } else {
            $rows | each {|r| $r.added + $r.deleted } | math sum
        }
    )

    let source = (summarize ($rows | where test == false) "source" --total $total)
    let test = (summarize ($rows | where test == true) "test" --total $total)

    $source | append $test
}
