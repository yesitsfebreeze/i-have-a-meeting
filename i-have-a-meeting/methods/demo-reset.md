# Demo reset

**Use when:** last 10 minutes, or presentation path verified and nothing larger fits.

**Move:** Write one reset command that returns presentation copy to known-good start state (data, files, logins), in dedicated demo checkout only. Pre-start servers and VMs, pre-download large assets, cut network dependencies. Record one successful run as fallback. Run reset, then walk whole path on presentation machine or host, not yours.

**Done when:** reset then full path passes on presentation machine; fallback recording exists; each known failure point has a recovery line in report.

**Trap:** rehearsing on dev machine. Presentation machine lacks codecs, first-run setup, network, logins yours has.

**Source:** Matthew Gilliard, "Live coding tips", 2018 (http://blog.gilliard.lol/2018/10/25/live-coding-tips.html): reset with `git reset --hard && git clean -fdx`; keep "a video of you successfully doing the thing"; "do all the big downloads in advance". Scott Hanselman, "Technical Presentations: Be prepared for absolute chaos", 2009 (https://www.hanselman.com/blog/technical-presentations-be-prepared-for-absolute-chaos): rehearsal on real hardware hours early found missing codec, moved file, dead network. Practitioner reports, not studies.
