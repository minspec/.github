import json
import os
from pathlib import Path
import re
import subprocess
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "term-wall.sh"
PATTERN = "zz[q]orblat"
PLANT = "zzqor" + "blat"
REFUSAL = (
    "pattern: expected TERM_WALL set; found empty; needed the org variable (CI) "
    "or ops/bin/term-wall.conf (local)"
)


class TermWallTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.repo = self.root / "repo"
        self.repo.mkdir()
        self.home = self.root / "home"
        self.home.mkdir()
        self.git("init", "-q")
        self.git("config", "user.name", "Term Wall Test")
        self.git("config", "user.email", "term-wall@example.invalid")
        self.write("clean.txt", "ordinary text\n")
        self.commit("initial clean commit")

    def tearDown(self):
        self.temporary.cleanup()

    def environment(self, **values):
        env = {
            "PATH": os.environ.get("PATH", "/usr/bin:/bin"),
            "HOME": str(self.home),
            "LC_ALL": "C",
            "GIT_CONFIG_NOSYSTEM": "1",
            "GIT_TERMINAL_PROMPT": "0",
            "TERM_WALL": PATTERN,
        }
        env.update({key: str(value) for key, value in values.items()})
        return env

    def git(self, *arguments, cwd=None):
        return subprocess.run(
            ["git", *arguments],
            cwd=cwd or self.repo,
            env=self.environment(),
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
        ).stdout.strip()

    def write(self, relative, contents):
        path = self.repo / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(contents, encoding="utf-8")
        return path

    def commit(self, message):
        self.git("add", "--all")
        self.git("commit", "-q", "--allow-empty", "-m", message)
        return self.git("rev-parse", "HEAD")

    def event(self, name, payload, *, head_ref="feature", ref_name="main"):
        path = self.root / f"{name}.json"
        path.write_text(json.dumps(payload), encoding="utf-8")
        return {
            "GITHUB_EVENT_PATH": path,
            "GITHUB_EVENT_NAME": name,
            "GITHUB_REPOSITORY": "example/term-wall-test",
            "GITHUB_HEAD_REF": head_ref,
            "GITHUB_REF_NAME": ref_name,
        }

    def run_wall(self, *, cwd=None, env=None):
        return subprocess.run(
            [str(SCRIPT)],
            cwd=cwd or self.repo,
            env=env or self.environment(),
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=15,
        )

    def assert_clean(self, result):
        self.assertEqual(result.returncode, 0, result)
        self.assertEqual(result.stderr, "")
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 1, result.stdout)
        self.assertRegex(lines[0], r"^term wall: clean(?:\b|\s|$)")

    def assert_hit(self, result, surface):
        self.assertEqual(result.returncode, 1, result)
        self.assertEqual(result.stderr, "")
        self.assertNotIn(PLANT, result.stdout.lower())
        self.assertNotIn(PLANT, result.stderr.lower())
        lines = result.stdout.splitlines()
        self.assertTrue(lines, "a hit must be printed on stdout")
        matching = [line for line in lines if line.startswith(surface + ": ")]
        self.assertTrue(matching, f"missing {surface!r} hit in {result.stdout!r}")
        for line in matching:
            self.assertRegex(
                line,
                rf"^{re.escape(surface)}: [^:]+: .*\[forbidden name\].*$",
            )

    def test_clean_tree(self):
        self.assert_clean(self.run_wall())

    def test_tracked_content_hit_is_masked(self):
        self.write("planted.txt", f"before {PLANT.upper()} after\n")
        self.commit("add fixture")
        self.assert_hit(self.run_wall(), "content")

    def test_binary_tracked_content_is_skipped(self):
        (self.repo / "fixture.bin").write_bytes(b"\x00" + PLANT.encode("ascii") + b"\xff")
        self.commit("add binary fixture")
        self.assert_clean(self.run_wall())

    def test_tracked_path_hit_is_masked(self):
        self.write(f"notes-{PLANT}.txt", "ordinary text\n")
        self.commit("add fixture")
        self.assert_hit(self.run_wall(), "path")

    def pr_environment(self, *, title="Clean title", body="Clean body", head_ref="feature"):
        base = self.git("rev-parse", "HEAD^")
        head = self.git("rev-parse", "HEAD")
        payload = {
            "pull_request": {
                "base": {"sha": base},
                "head": {"sha": head},
                "title": title,
                "body": body,
            }
        }
        values = self.event("pull_request", payload, head_ref=head_ref)
        return self.environment(**values)

    def test_pull_request_title_hit(self):
        self.commit("clean feature commit")
        result = self.run_wall(env=self.pr_environment(title=f"Review {PLANT} now"))
        self.assert_hit(result, "pull request title")

    def test_pull_request_body_hit(self):
        self.commit("clean feature commit")
        result = self.run_wall(env=self.pr_environment(body=f"Body has {PLANT}."))
        self.assert_hit(result, "pull request body")

    def test_pull_request_branch_name_hit(self):
        self.commit("clean feature commit")
        result = self.run_wall(env=self.pr_environment(head_ref=f"topic-{PLANT}"))
        self.assert_hit(result, "branch name")

    def test_pull_request_range_commit_message_is_fetched_offline(self):
        base = self.git("rev-parse", "HEAD")
        self.commit(f"message contains {PLANT}")
        head = self.git("rev-parse", "HEAD")
        self.git("branch", "base-for-test", base)
        self.git("remote", "add", "origin", str(self.repo))
        payload = {
            "pull_request": {
                "base": {"sha": base},
                "head": {"sha": head},
                "title": "Clean title",
                "body": "Clean body",
            }
        }
        result = self.run_wall(env=self.environment(**self.event("pull_request", payload)))
        self.assert_hit(result, "commit messages")

    def test_push_with_zero_before_scans_head_commit_only(self):
        head = self.commit(f"new branch says {PLANT}")
        payload = {"before": "0" * 40, "after": head}
        result = self.run_wall(env=self.environment(**self.event("push", payload)))
        self.assert_hit(result, "commit messages")

    def test_push_with_range_scans_changed_commit_messages(self):
        before = self.git("rev-parse", "HEAD")
        after = self.commit(f"range says {PLANT}")
        payload = {"before": before, "after": after}
        result = self.run_wall(env=self.environment(**self.event("push", payload)))
        self.assert_hit(result, "commit messages")

    def test_push_branch_name_hit(self):
        head = self.commit("clean push commit")
        payload = {"before": "0" * 40, "after": head}
        values = self.event("push", payload, ref_name=f"release-{PLANT}")
        self.assert_hit(self.run_wall(env=self.environment(**values)), "branch name")

    def test_unreadable_event_payload_is_a_hit(self):
        payload = self.root / "malformed.json"
        payload.write_text("not valid JSON\n", encoding="utf-8")
        env = self.environment(
            GITHUB_EVENT_PATH=payload,
            GITHUB_EVENT_NAME="pull_request",
            GITHUB_REPOSITORY="example/term-wall-test",
            GITHUB_HEAD_REF="feature",
            GITHUB_REF_NAME="main",
        )
        result = self.run_wall(env=env)
        self.assertEqual(result.returncode, 1, result)
        self.assertEqual(result.stderr, "")
        self.assertNotIn(PLANT, result.stdout + result.stderr)
        self.assertRegex(result.stdout, r"(?m)^event payload: [^:]+: .+$")

    def test_term_wall_unset_refuses(self):
        env = self.environment()
        del env["TERM_WALL"]
        result = self.run_wall(env=env)
        self.assertEqual(result.returncode, 2, result)
        self.assertEqual(result.stdout, "")
        self.assertEqual(result.stderr, REFUSAL + "\n")

    def test_term_wall_empty_refuses(self):
        result = self.run_wall(env=self.environment(TERM_WALL=""))
        self.assertEqual(result.returncode, 2, result)
        self.assertEqual(result.stdout, "")
        self.assertEqual(result.stderr, REFUSAL + "\n")

    def test_not_a_git_work_tree_refuses(self):
        outside = self.root / "outside"
        outside.mkdir()
        result = self.run_wall(cwd=outside)
        self.assertEqual(result.returncode, 2, result)
        self.assertEqual(result.stdout, "")
        lines = result.stderr.splitlines()
        self.assertEqual(len(lines), 1, result.stderr)
        self.assertRegex(lines[0], r"^git work tree: expected .+; found .+; needed .+$")


if __name__ == "__main__":
    unittest.main()
