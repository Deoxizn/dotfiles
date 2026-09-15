---
name: github-pages
description: >
  Expert knowledge for publishing GitHub Pages sites, including branch vs
  GitHub Actions deployment paths, Jekyll setup (Gemfile, _config.yml,
  supported plugins, kramdown, themes), static alternatives (Hugo, VitePress,
  MkDocs, pure HTML), custom domains (CNAME, DNS A/AAAA/CNAME records, HTTPS),
  project vs user/org URL patterns and baseurl, local preview, and
  troubleshooting. REQUIRED when creating or debugging a Pages site, custom
  domain, or Pages Actions workflow. Triggers: github pages, pages, jekyll,
  static site, custom domain, CNAME, DNS, baseurl, deploy-pages, minima,
  just-the-docs, hugo, vitepress, mkdocs, 404 baseurl.
---

# GitHub Pages Skill

Expert agent for **GitHub Pages** static-site hosting: deployment paths,
**Jekyll**, static alternatives, **custom domains + DNS + HTTPS**, URL
patterns, Actions workflows, local preview, and troubleshooting. Current as
of September 2026; this machine uses Arch + fish and the companion
`github` skill for git/gh/Actions basics.

## 0. Primary references (GitHub docs are canonical)

- **Pages docs**: <https://docs.github.com/en/pages>
- **Quickstart**: <https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site>
- **Publishing source**: <https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site>
- **Pages + Actions**: <https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages>
- **Jekyll on Pages**: <https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll>
- **Dependency versions**: <https://pages.github.com/versions/>
- **Supported Jekyll plugins**: <https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll#plugins>
- **Custom domains**: <https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/about-custom-domains-and-github-pages>
- **Managing a custom domain**: <https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site>
- **Troubleshooting custom domains / 404**: <https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/troubleshooting-custom-domains-and-github-pages>,
  <https://docs.github.com/en/pages/getting-started-with-github-pages/troubleshooting-404-errors-for-github-pages-sites>
- **Jekyll docs (incl. Actions guide)**: <https://jekyllrb.com/docs/>,
  <https://jekyllrb.com/docs/continuous-integration/github-actions/>

## 1. Deployment paths compared

Two publishing sources (Settings > Pages > Build and deployment):

| | Branch (`/(docs)` folder) | GitHub Actions |
|---|---|---|
| Build | GitHub builds Jekyll (locked gemset) | You define the build (any tool, any version) |
| Content | Jekyll with whitelisted plugins, or plain static | Anything producing static files |
| Key actions | None (implicit) | `configure-pages` + `upload-pages-artifact` + `deploy-pages` |
| Custom-domain CNAME | Auto-committed to branch root | Stored in settings; a `CNAME` in output is ignored |
| Best for | Simple Jekyll blogs/docs | Hugo/VitePress/MkDocs, modern Jekyll, SPAs |

If you need a non-whitelisted plugin or theme, or you are not using
Jekyll at all, use the Actions path — the default choice for anything new.
Current pins (Sept 2026, node24 runtime):

```yaml
- uses: actions/configure-pages@v5
- uses: actions/upload-pages-artifact@v3
- uses: actions/deploy-pages@v5
```

Every Pages deploy job needs these permissions plus the `github-pages`
environment (where `deploy-pages` publishes the site URL):

```yaml
permissions:
  contents: read
  pages: write
  id-token: write
environment:
  name: github-pages
  url: ${{ steps.deployment.outputs.page_url }}
```

## 2. URL patterns: user/org vs project sites (and baseurl!)

| Site type | Source repo | Default URL |
|---|---|---|
| User site | `<user>.github.io` | `https://<user>.github.io/` |
| Org site | `<org>.github.io` | `https://<org>.github.io/` |
| Project site | any repo `REPO` | `https://<user>.github.io/<repo>/` |

The project-site subpath is the number-one source of broken Pages sites.
Every internal link and asset must honor `baseurl`:

```yaml
# _config.yml — project site (user/org sites use baseurl: "")
url: "https://octocat.github.io"
baseurl: "/my-repo"
```

```html
<!-- templates: ALWAYS use the filters, never hardcode /assets/... -->
<link rel="stylesheet" href="{{ '/assets/css/style.css' | relative_url }}">
<a href="{{ '/docs/guide/' | relative_url }}">Guide</a>
```

```bash
rg -n 'href="/|src="/' --glob '!_site/**' .   # hardcoded paths break project sites
```

Repo visibility: public repos get Pages on Free; private repos need a
paid plan. Source and visibility live under Settings > Pages.

## 3. Jekyll setup (branch path and Actions path)

Gemfile, classic locked mode (branch builds — exact version at
<https://pages.github.com/versions/>):

```ruby
source "https://rubygems.org"
gem "github-pages", "~> 232", group: :jekyll_plugins
```

Gemfile, modern mode (Actions builds — any Jekyll, any plugin):

```ruby
source "https://rubygems.org"
gem "jekyll", "~> 4.3"
group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
  gem "jekyll-remote-theme"
end
```

`_config.yml` example (project site):

```yaml
title: My Docs
url: "https://octocat.github.io"
baseurl: "/my-repo"
theme: minima                    # branch-safe; see remote_theme below
# remote_theme: pages-themes/minimal@v0.2.0   # Actions path, any theme
markdown: kramdown
highlighter: rouge
plugins:
  - jekyll-feed
  - jekyll-seo-tag
  - jekyll-sitemap
exclude:
  - Gemfile
  - Gemfile.lock
kramdown:
  input: GFM
  syntax_highlighter: rouge
```

Supported-plugins note: the branch builder allows only the documented
list (feed, seo-tag, sitemap, redirect-from, remote-theme, ...). Custom
`_plugins/*.rb`, extra gems, or Jekyll 4.x features require the Actions
path, which has no whitelist. Themes: `minima` (default, always safe),
`minimal`, `just-the-docs` for docs sites; on the Actions path prefer
`remote_theme: owner/repo` to version the theme yourself.

Jekyll layout essentials:

```bash
my-site/
├── _config.yml  Gemfile  index.md
├── _posts/          # YYYY-MM-DD-slug.md
├── _layouts/  _includes/  assets/css/
└── .nojekyll        # ONLY for non-Jekyll static output (Section 7)
```

## 4. Static alternatives (build, then upload the artifact)

Hugo, VitePress, MkDocs, or plain HTML all work: build to a folder, then
`upload-pages-artifact` that folder. Set each tool's base-URL option or
reproduce the Section 2 `baseurl` breakage (Hugo `--baseURL`, VitePress
`base: '/my-repo/'`, MkDocs `site_url`).

```yaml
# Hugo
- uses: peaceiris/actions-hugo@v3
  with: { hugo-version: "0.148.2", extended: true }
- run: hugo --minify --baseURL "https://octocat.github.io/my-repo/"
- uses: actions/upload-pages-artifact@v3
  with: { path: ./public }
```

```yaml
# VitePress (Node 24 on current runners)
- uses: actions/setup-node@v6
  with: { node-version: "24", cache: npm }
- run: npm ci && npm run docs:build   # outputs docs/.vitepress/dist
- uses: actions/upload-pages-artifact@v3
  with: { path: docs/.vitepress/dist }
```

```yaml
# MkDocs
- uses: actions/setup-python@v6
  with: { python-version: "3.13", cache: pip }
- run: pip install mkdocs mkdocs-material && mkdocs build --strict
- uses: actions/upload-pages-artifact@v3
  with: { path: ./site }
```

Pure HTML needs no build step — copy files into `public/` and upload it:

```bash
mkdir -p public && cp -r index.html assets/ public/
```

```yaml
- uses: actions/upload-pages-artifact@v3
  with: { path: ./public }
```

## 5. Custom domain (CNAME, DNS, HTTPS)

Order matters: add the domain in Settings > Pages first, then create DNS
records. The branch path auto-commits a `CNAME` file (content: just the
bare domain, e.g. `docs.example.com`); the Actions path stores the domain
in settings and ignores build-output `CNAME` files.

| Domain | Record | Target / value |
|---|---|---|
| `www.example.com` | `CNAME` | `<user>.github.io` (never include the repo name) |
| `blog.example.com` | `CNAME` | `<user>.github.io` or `<org>.github.io` |
| `example.com` (apex) | `ALIAS`/`ANAME`, else `A` | `<user>.github.io`, or the four A records |
| Apex `A` | `A` (all four) | `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153` |
| Apex IPv6 (optional, keep A too) | `AAAA` | `2606:50c0:8000::153`, `2606:50c0:8001::153`, `2606:50c0:8002::153`, `2606:50c0:8003::153` |

```bash
dig www.example.com +noall +answer
dig example.com +noall +answer -t A        # expect the four apex IPs
# DNS changes can take up to 24 h to propagate
```

HTTPS: after DNS resolves, tick **Enforce HTTPS** (Let's Encrypt cert,
tens of minutes to issue). HSTS gotcha: once served, browsers refuse
plain-HTTP for the whole max-age window — do not disable HTTPS or move
the domain without a plan. Verify the domain in settings to block
subdomain takeover, avoid wildcard `*` records, and serve every asset
over HTTPS (one `http://` script gets blocked — audit with
`rg -n 'http://' --glob '!_site/**' .`).

## 6. Actions workflows (full examples)

Jekyll via Actions (full plugin freedom):

```yaml
name: pages-jekyll
on:
  push: { branches: [main] }
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - uses: ruby/setup-ruby@v1
        with: { ruby-version: "3.4", bundler-cache: true }
      - uses: actions/configure-pages@v5
      - run: bundle exec jekyll build
        env: { JEKYLL_ENV: production }
      - uses: actions/upload-pages-artifact@v3
        with: { path: ./_site }
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v5
```

Generic static upload (Hugo/VitePress/MkDocs/plain HTML build first):

```yaml
name: pages-static
on:
  push: { branches: [main] }
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - run: npm ci && npm run build   # or hugo / mkdocs build
      - uses: actions/upload-pages-artifact@v3
        with: { path: ./dist }   # public / dist / site
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v5
```

After pushing either workflow, switch Settings > Pages > Source to
**GitHub Actions** once, then `gh run watch` (see the `github` skill).

Local preview:

```bash
bundle install
bundle exec jekyll serve --livereload --drafts
# open http://127.0.0.1:4000/my-repo/  (note the baseurl!)
python -m http.server 8000 --directory ./public  # static output: _site/dist/site
```

fish note: flags are identical under fish; if `bundle` is missing,
`sudo pacman -S ruby` then `gem install --user-install bundler jekyll`.

## 7. Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| 404 on project site, fine locally | Missing/wrong `baseurl` or absolute `/asset` links | Set `baseurl: "/<repo>"`, use `relative_url`, audit with `rg 'href="/\|src="/'` |
| Mixed-content warnings / blocked assets | `http://` URLs on the HTTPS site | Rewrite to `https://`; re-audit with `rg 'http://'` |
| DNS not resolving after hours | Wrong target or stale provider default record | `dig +noall +answer`; CNAME must be `<user>.github.io` (no repo) |
| Pages build-failure email (branch path) | Unsupported plugin, bad YAML, kramdown error | Reproduce with `bundle exec jekyll build`; move to Actions for plugin freedom |
| `_`-prefixed files 404 | Jekyll hides underscore paths | Actions path: add empty `.nojekyll` to output root to bypass Jekyll |
| Stray `.nojekyll` kills Jekyll processing | `.nojekyll` disables all Jekyll builds | Delete it on Jekyll sites; keep only for pure-static output |
| Large repo / slow builds | `_site`, `node_modules`, caches committed | `.gitignore` them; use built-in `cache:` / `actions/cache` |
| "Enforce HTTPS" greyed out | DNS unverified / cert still issuing | Wait for DNS + cert (up to 24 h), then tick the box |
| Custom domain shows another site | DNS set before adding domain in settings | Set domain in Settings > Pages first; verify the domain |
