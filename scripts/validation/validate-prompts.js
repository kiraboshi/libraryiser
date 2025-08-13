/*
 Simple prompt validator:
 - Ensures required frontmatter keys exist on prompts under prompts/**.md
 - Confirms each prompt path is listed in docs/prompt-registry.md
*/

const fs = require('fs');
const path = require('path');

const repoRoot = process.cwd();
const promptsDir = path.join(repoRoot, 'prompts');
const registryPath = path.join(repoRoot, 'docs', 'prompt-registry.md');

function readFile(p) {
  return fs.readFileSync(p, 'utf8');
}

function listMarkdownFiles(dir) {
  const results = [];
  const stack = [dir];
  while (stack.length) {
    const current = stack.pop();
    if (!fs.existsSync(current)) continue;
    const entries = fs.readdirSync(current, { withFileTypes: true });
    for (const e of entries) {
      const full = path.join(current, e.name);
      if (e.isDirectory()) stack.push(full);
      else if (e.isFile() && e.name.endsWith('.md')) results.push(full);
    }
  }
  return results;
}

function parseFrontmatter(content) {
  const fmMatch = content.match(/^---[\s\S]*?---/);
  if (!fmMatch) return null;
  const fm = fmMatch[0].replace(/^---\n?|\n?---$/g, '');
  const lines = fm.split(/\r?\n/);
  const obj = {};
  for (const line of lines) {
    const m = line.match(/^([a-zA-Z0-9_]+):\s*(.*)$/);
    if (m) {
      const key = m[1].trim();
      const value = m[2].trim();
      obj[key] = value;
    }
  }
  return obj;
}

function main() {
  const requiredKeys = ['title', 'type', 'scope', 'owner', 'status'];
  const markdownFiles = listMarkdownFiles(promptsDir);
  const registry = fs.existsSync(registryPath) ? readFile(registryPath) : '';

  let ok = true;
  const problems = [];

  for (const file of markdownFiles) {
    const rel = path.relative(repoRoot, file).replace(/\\/g, '/');
    const content = readFile(file);
    const fm = parseFrontmatter(content);
    if (!fm) {
      ok = false;
      problems.push(`Missing frontmatter: ${rel}`);
      continue;
    }
    for (const k of requiredKeys) {
      if (!(k in fm)) {
        ok = false;
        problems.push(`Missing '${k}' in frontmatter: ${rel}`);
      }
    }
    if (!registry.includes(rel)) {
      ok = false;
      problems.push(`Not listed in docs/prompt-registry.md: ${rel}`);
    }
  }

  if (!ok) {
    console.error('Prompt validation failed:');
    for (const p of problems) console.error(`- ${p}`);
    process.exit(1);
  }

  console.log('Prompt validation passed.');
}

main();


