@RTK.md

When writing final response status indicators, use the /quick-recap skill always.

## Bash: one command per call, no shell constructs

Permission prefix rules can only match a single simple command. Any chained or
dynamic shell construct forces a permission prompt even when every individual
command is allowlisted, because the engine cannot statically prove what will
run. So keep every Bash call trivially parseable:

- **One command per Bash tool call.** No `&&`, `||`, `;`, or newline-separated
  sequences. Issue independent calls in parallel in one message instead.
- **No `echo` headers or separators.** Do not print labels to delimit output for
  your own benefit — the tool result already tells you which call produced it.
- **No command substitution.** Never `$(...)` or backticks. Run the inner
  command as its own call, read the result, then use the literal value.
- **No variable expansion.** No `$VAR`, `${VAR}`, `$f`. Write literal paths.
- **No loops.** No `for`/`while`. Iterate by issuing one call per item, or use a
  single command that takes multiple arguments (`wc -l a.md b.md c.md`).
- **No glob-into-substitution.** Pass globs directly to the command
  (`grep -rn foo src/`), or use the Glob/Grep tools.
- **Pipes are acceptable** only when every stage is a simple allowlisted command
  with literal arguments — `rg foo src/ | head -20` is fine.
- Prefer the dedicated Read/Glob/Grep/Edit tools over shell equivalents; they
  never prompt.

Do not route around these rules by writing shell logic to a script file and
executing that. The approval dialog shows the command, not the file's contents,
so that hides from review exactly what the prompt exists to surface. If a task
genuinely needs a loop or substitution, write it inline and take the prompt.
