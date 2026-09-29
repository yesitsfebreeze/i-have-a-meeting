# Prove done

**Use when:** any agent, including you, reports fix done or working, before integrating or counting it.

**Move:** Accept done only with observable evidence attached: check command, its output, revision, environment. Rerun that check yourself on presentation version. Treat confident completion wording ("works", "all passing", "ready") as trigger to check harder, not as evidence. Never let a second model reading the claim stand in for running the check.

**Done when:** check reran and passed at recorded revision; claim marked done only then.

**Trap:** trusting status report. Agents often report success their own state contradicts, and LLM judges barely catch it.

**Source:** Tang et al., "How Coding Agents Fail Their Users", 2026 (https://arxiv.org/abs/2605.29442): in 20,574 real sessions, 22.58% of misalignment episodes were inaccurate self-reporting, where agents "misreport the status (e.g., success) of its own work". Laksh Advani, "From Confident Closing to Silent Failure", 2026 (https://arxiv.org/abs/2606.09863): 45–48% of single-control failures were false success; "no configuration across 5 judges … exceeds AUROC 0.65".
