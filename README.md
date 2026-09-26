# I Have a Meeting

Give your coding agent a deadline and a focus. It finds the most important available issue, fixes it, verifies the result, and repeats while time remains.

## Install

For Codex:

```sh
git clone https://github.com/yesitsfebreeze/i-have-a-meeting.git
cd i-have-a-meeting
mkdir -p "$HOME/.agents/skills"
cp -R -i i-have-a-meeting "$HOME/.agents/skills/"
```

Other agents can read and follow [SKILL.md](i-have-a-meeting/SKILL.md) directly. Agents can also install through [llms.txt](llms.txt).

## Use

In your project, tell your agent:

```text
$i-have-a-meeting Focus on checkout. My meeting is in 30 minutes.
```

The focus is optional. The default deadline is 30 minutes. You can specify a different deadline and describe what needs to work.

Works with one or multiple agents. Give workers the same focus, deadline, and shared coordination location; they claim separate issues and verify changes before marking them done. Start workers through your usual agent tool.
