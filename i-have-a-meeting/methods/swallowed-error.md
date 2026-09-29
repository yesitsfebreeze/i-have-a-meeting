# Swallowed error

**Use when:** journey fails with no error shown, returns wrong default, or aborts far from any real fault.

**Move:** On failing path, find error handlers: empty `catch` or `except: pass`, catch that only logs, broad catch that aborts or returns default, `TODO` or `FIXME` in handler. Surface swallowed error in loop first.

**Done when:** swallowed error named; handler propagates it or handles that case.

**Trap:** fixing downstream effect of default value handler returned.

**Source:** Ding Yuan et al., "Simple Testing Can Prevent Most Critical Failures", OSDI 2014 (https://www.usenix.org/conference/osdi14/technical-sessions/presentation/yuan): 92% of catastrophic failures came from mishandled non-fatal errors; 35% from trivial handler mistakes. Study covers distributed data systems.
