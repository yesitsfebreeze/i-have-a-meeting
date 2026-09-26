"""Exercise the published entry point and portable Markdown installation."""

from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import re
import tempfile
import threading
import unittest
from urllib.parse import urljoin
from urllib.request import urlopen


ROOT = Path(__file__).resolve().parents[1]


class QuietHandler(SimpleHTTPRequestHandler):
    def log_message(self, *args):
        pass


class DistributionTests(unittest.TestCase):
    def test_original_markdown_entry_resolves_to_canonical_skill(self):
        self.assertEqual(
            (ROOT / "i-have-a-meeting.md").resolve(),
            ROOT / "i-have-a-meeting" / "SKILL.md",
        )
        self.assertTrue((ROOT / "i-have-a-meeting.md").read_text())

    def test_llms_links_and_installation_over_http(self):
        handler = partial(QuietHandler, directory=str(ROOT))
        with ThreadingHTTPServer(("127.0.0.1", 0), handler) as server:
            worker = threading.Thread(target=server.serve_forever, daemon=True)
            worker.start()
            try:
                index_url = f"http://127.0.0.1:{server.server_port}/llms.txt"
                with urlopen(index_url, timeout=5) as response:
                    index = response.read().decode()
                links = re.findall(r"\[[^\]]+\]\(([^)]+)\)", index)
                self.assertTrue(links, "The index must expose downloadable resources")
                resources = {}
                for link in links:
                    with urlopen(urljoin(index_url, link), timeout=5) as response:
                        resources[link] = response.read()
                skills = [body for link, body in resources.items() if link.endswith("/SKILL.md")]
                self.assertEqual(len(skills), 1)
                with tempfile.TemporaryDirectory(prefix="meeting-install-check-") as folder:
                    destination = Path(folder) / ".agents/skills/i-have-a-meeting/SKILL.md"
                    destination.parent.mkdir(parents=True)
                    destination.write_bytes(skills[0])
                    self.assertEqual(
                        destination.read_bytes(),
                        (ROOT / "i-have-a-meeting/SKILL.md").read_bytes(),
                    )
                    self.assertFalse(destination.is_symlink())
                    self.assertTrue(destination.read_text().startswith("---\nname: i-have-a-meeting\n"))
            finally:
                server.shutdown()
                worker.join(timeout=5)


if __name__ == "__main__":
    unittest.main()
