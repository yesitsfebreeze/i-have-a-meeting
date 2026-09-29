# Hidden step

**You see:** works for one person only, or broke after reinstall, new laptop, fresh deploy.

**Underneath:** manual step lives only in someone's memory: dashboard toggle, DNS or webhook entry, OAuth app setting, local certificate, one-off script, login done once long ago.

**Red check:** clean checkout or fresh environment; follow only written setup. First failure is missing step. Ask person it works for what they did once; compare with written setup.

**Fix at:** setup path. Script or document step where setup already lives (README, setup script, `.env.example`).

**Trap:** redoing step by hand in silence. Works today; same failure returns at next reset.
