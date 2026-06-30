---
title: "How I Built This Blog with Quartz"
date: 2026-07-01
tags:
  - meta
  - quartz
  - tutorial
---

A short guide to standing up a fast, Markdown-native blog with
[Quartz](https://quartz.jzhao.xyz) — the setup powering this site.

## Why Quartz

- Plain Markdown in, static HTML out — your notes *are* the site.
- First-class Obsidian flavor: wikilinks, callouts, LaTeX, graph view, search.
- No database; host the `public/` folder anywhere.

## Prerequisites

Node.js 20+ and Git.

## 1. Scaffold

```bash
git clone --depth 1 https://github.com/jackyzha0/quartz.git
cd quartz
npm install
npx quartz create     # choose a template, then "Empty" content
```

## 2. Write content

Everything lives under `content/`:

- `content/index.md` — the home page.
- `content/contact/index.md`, `content/publications/index.md`, … — pages.
- `content/posts/*.md` — posts, each with frontmatter:

```yaml
---
title: My first post
date: 2026-07-01
tags: [systems]
---
```

## 3. Configure

`quartz.config.yaml` is the single source of truth: `pageTitle`, `baseUrl`,
the footer `links` (socials, ICP filing, …), and the plugin list (LaTeX via
KaTeX, syntax highlighting, search, graph, RSS, …).

## 4. Preview & build

```bash
npx quartz build --serve    # live preview at http://localhost:8080
npx quartz build            # emit static site to public/
```

## 5. Deploy

Serve `public/` with any static host. With [Caddy](https://caddyserver.com):

```
fanst.cc {
    encode zstd gzip
    root * /home/you/quartz/public
    file_server
}
```