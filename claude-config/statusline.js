let raw = "";
process.stdin.on("data", (chunk) => (raw += chunk));
process.stdin.on("end", () => {
  const input = JSON.parse(raw);
  const dir = input.workspace.current_dir;
  let branch = "";
  try {
    branch = require("child_process")
      .execSync("git branch --show-current", { cwd: dir, stdio: ["ignore", "pipe", "ignore"] })
      .toString()
      .trim();
  } catch {}
  process.stdout.write(dir + (branch ? ` (${branch})` : ""));
});
