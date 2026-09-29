# Edge input

**You see:** tested path works; unusual input breaks it: presentation script data, live audience question, empty list, exactly one item, max value, odd characters.

**Underneath:** code gets value tests never used: empty or missing fields, zero or one items, very long text, non-ASCII names, zero, negative, or huge amounts, other currencies or locales, dates near midnight or across timezones, new account with no history, double submit.

**Red check:** walk actual presentation script with actual data; write down every value entered. Put failing value into loop at lowest seam that reaches it. Red on that value, green on tested one.

**Fix at:** where value first enters model: validate or normalize there. Guard at one crashed screen leaves every other reader exposed.

**Trap:** changing presentation script to avoid value. Only as stated fallback in report's paths to avoid, never as fix.
