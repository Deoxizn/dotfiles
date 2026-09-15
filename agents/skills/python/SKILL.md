---
name: python
description: >
  Expert knowledge for Python development, including Arch Linux environment
  setup, uv virtualenvs and packaging, pyproject.toml project layout,
  modern type hints, ruff/mypy/pyright, pytest, asyncio, and debugging.
  REQUIRED when creating venvs, managing dependencies, packaging projects,
  writing typed code, linting, testing, or troubleshooting imports.
  Grounded in Python 3.14, uv, ruff, and current packaging PEPs.
  Covers venv, uv pip/run/tool, pyproject.toml PEP 517/518/621/660,
  src layout, PEP 484/585/604/695 typing, dataclasses, match, asyncio,
  ruff, mypy/pyright strict, pytest fixtures/parametrize, cProfile,
  and troubleshooting. Triggers: python, python3, venv, uv, uv run,
  pip, pyproject, packaging, ruff, mypy, pyright, pytest, asyncio,
  dataclass, type hint, match statement, cProfile, ModuleNotFoundError.
---

# Python Skill

Expert agent for **Python development** on Arch Linux.
This machine runs **Python 3.14.7** (stable August 2026; 3.15.0rc2
pre-release, final planned October 2026) with **fish 4.9.3**.
Prefer **uv 0.12.x** for venvs and deps, **ruff 0.16.x** for lint+format,
**mypy / pyright** strict for types, **pytest 9.1.x** for tests.

## 0. Primary references

Language and stdlib (canonical):

- **Tutorial**: <https://docs.python.org/3/tutorial/>
- **Library reference**: <https://docs.python.org/3/library/>
- **Language reference**: <https://docs.python.org/3/reference/>
- **What is new in 3.14 / downloads**: <https://docs.python.org/3.14/whatsnew/3.14.html>, <https://www.python.org/downloads/>
- **ArchWiki Python**: <https://wiki.archlinux.org/title/Python>

Packaging and PEPs (authoritative for layout and types):

- **Packaging User Guide**: <https://packaging.python.org/>
- **PEPs**: <https://peps.python.org/> — PEP 8 (style), PEP 484 (hints),
  PEP 517 (backends), PEP 518 (build reqs), PEP 585 (builtin generics),
  PEP 604 (`X | Y`), PEP 621 (`[project]`), PEP 660 (editable),
  PEP 695 (`type` statement, `def f[T]`)
- **uv docs**: <https://docs.astral.sh/uv/>
- **ruff docs**: <https://docs.astral.sh/ruff/>
- **mypy docs**: <https://mypy.readthedocs.io/>
- **pyright docs**: <https://microsoft.github.io/pyright/>
- **pytest docs**: <https://docs.pytest.org/>

## 1. Environment setup on Arch

Never touch system Python (`/usr/bin/python`, package `python`).
Never `sudo pip install`. Always use a venv, `uv run`, or `uv tool`.

```bash
python --version   # expect Python 3.14.7 on this machine
which python
sudo pacman -S --needed python python-pip uv ruff
```

### 1.1 `python -m venv` vs `uv venv`

`uv venv` is faster and the default for new work. `python -m venv`
is the stdlib fallback.

```bash
python -m venv .venv
source .venv/bin/activate.fish   # fish 4.9.3 (this machine)
uv venv                          # preferred: faster, respects .python-version
uv venv --python 3.14            # pin minor version
deactivate                       # leave any venv
```

Deactivate with `deactivate`. Delete and recreate a polluted venv.

### 1.2 `uv pip` / `uv run` / `uv tool`

```bash
uv pip install requests
uv pip install -r requirements.txt
uv run script.py                   # project env or ephemeral env
uv run --with requests script.py   # one-off dep, no venv edit
uv run pytest                      # suite inside project env
uv tool install ruff               # global CLI, no project pollution
uv tool install mypy
uv tool run ruff check .           # run without installing (like uvx)
```

### 1.3 pyenv notes

Rarely needed on Arch. Use pyenv only for exact patch versions.

```bash
uv python install 3.13
echo "3.14" > .python-version   # respected by both uv and pyenv
```

### 1.4 PYTHONPATH

Prefer editable installs over `PYTHONPATH` (throwaway scripts only).

```bash
set -x PYTHONPATH /home/devi/Work/mylib/src $PYTHONPATH   # fish
python -c "import sys; print(sys.path)"
uv pip install -e .   # real fix for real code
```

Run packages as `python -m pkg.mod` from the project root.
Always `python -m pip`, never bare `pip` or `sudo pip`.

## 2. Project layout

`pyproject.toml` is the single source of truth (PEP 517/518/621).
Do not create `setup.py` / `setup.cfg` in new projects.

```toml
[project]
name = "myapp"
version = "0.1.0"
description = "Example typed Python project"
readme = "README.md"
requires-python = ">=3.13"
license = { text = "MIT" }
authors = [{ name = "Devi" }]
dependencies = ["httpx>=0.27", "click>=8.1"]
[project.optional-dependencies]
dev = ["pytest>=9", "mypy>=1.11", "ruff>=0.16"]
[project.urls]
Homepage = "https://example.com/myapp"
[project.scripts]
myapp = "myapp.cli:main"
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
[tool.hatch.build.targets.wheel]
packages = ["src/myapp"]
[dependency-groups]
dev = ["pytest>=9.1", "mypy>=1.18", "ruff>=0.16"]
[tool.ruff]
target-version = "py314"
line-length = 88
[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B", "SIM", "RUF"]
[tool.mypy]
python_version = "3.14"
strict = true
[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-ra -q"
```

### 2.1 `src/` layout vs flat layout

Prefer `src/` for anything installable: tests exercise the installed
package, not the working tree.

```bash
myapp/                       # src layout (preferred)
  pyproject.toml  uv.lock  README.md
  src/myapp/__init__.py  src/myapp/cli.py  src/myapp/core.py
  tests/test_core.py
```

```python
# src/myapp/__init__.py — public surface
from myapp.core import greet
__all__ = ["greet"]
# src/myapp/__main__.py — enables python -m myapp
from myapp.cli import main
if __name__ == "__main__":
    main()
```

### 2.2 Lockfiles and entry points

Commit `uv.lock` for apps; keep `pyproject.toml` ranges loose for libs.
`[project.scripts]` creates console commands on install.

## 3. Language essentials

All idioms below are valid on Python 3.13+ / 3.14.

Data model: everything is an object (mutable `list`/`dict`/`set` vs
immutable `tuple`/`str`). Falsy empties, `None`, `0`; compare with `is`.

```python
a = [1, 2]; b = a; c = list(a)   # b is a; c == a but c is not a
x: int | None = None
if x is None:
    print("missing")
```

Functions: positional-only `/`, defaults, `*args`, keyword-only args.
Prefer `def` over lambdas except for single expressions.

```python
def greet(name: str, /, greeting: str = "hello", *tags: str, shout: bool = False) -> str:
    msg = f"{greeting}, {name}"
    if tags:
        msg += f" [{', '.join(tags)}]"
    return msg.upper() if shout else msg
```

Classes: prefer frozen/slotted dataclasses for value objects.

```python
from dataclasses import dataclass, field
@dataclass(frozen=True, slots=True)
class User:
    name: str
    uid: int
    groups: list[str] = field(default_factory=list)
    @property
    def label(self) -> str:
        return f"{self.name}#{self.uid}"
```

Type hints: PEP 585 builtins (`list[int]`), PEP 604 unions
(`str | None`), PEP 695 aliases and type params (3.12+).

```python
def first(items: list[str]) -> str | None:
    return items[0] if items else None
type UserId = int
type Json = dict[str, str | int | None]
def head[T](items: list[T]) -> T | None:
    return items[0] if items else None
from collections.abc import Callable
from typing import ParamSpec, TypeVar
T = TypeVar("T"); P = ParamSpec("P")
def traced(func: Callable[P, T]) -> Callable[P, T]:
    def wrapper(*args: P.args, **kwargs: P.kwargs) -> T:
        print(f"calling {func.__name__}")
        return func(*args, **kwargs)
    return wrapper
```

Exceptions: catch specific types, chain with `from`, keep `try` narrow.

```python
class AppError(Exception): ...
def load_config(path: str) -> str:
    try:
        with open(path, encoding="utf-8") as fh:
            return fh.read()
    except FileNotFoundError as exc:
        raise AppError(f"missing config: {path}") from exc
from contextlib import contextmanager
from collections.abc import Iterator
@contextmanager
def timer(name: str) -> Iterator[None]:
    import time
    start = time.perf_counter()
    try:
        yield
    finally:
        print(f"{name}: {time.perf_counter() - start:.3f}s")
```

Iterators/generators/decorators: yield lazily; wrap with `functools.wraps`.

```python
from collections.abc import Iterator
def countdown(n: int) -> Iterator[int]:
    while n > 0:
        yield n; n -= 1
total = sum(x for x in range(1_000_000))   # never materialize
import functools
def retry(times: int = 3):
    def deco(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for i in range(times):
                try:
                    return func(*args, **kwargs)
                except OSError:
                    if i == times - 1:
                        raise
            raise AssertionError("unreachable")
        return wrapper
    return deco
```

Asyncio: one loop via `asyncio.run()`; `TaskGroup` fan-out; `to_thread` for blocking calls.

```python
import asyncio
async def fetch(url: str) -> int:
    await asyncio.sleep(0.01)
    return len(url)
async def main(urls: list[str]) -> list[int]:
    async with asyncio.TaskGroup() as tg:
        tasks = [tg.create_task(fetch(u)) for u in urls]
    return [t.result() for t in tasks]
if __name__ == "__main__":
    asyncio.run(main(["https://a.example", "https://b.example"]))
```

Pattern matching (3.10+): specific cases first, `_` last.

```python
def describe(cmd: object) -> str:
    match cmd:
        case {"action": "quit"}:
            return "bye"
        case {"action": "move", "x": int(x), "y": int(y)}:
            return f"move to {x},{y}"
        case [0, 0]:
            return "origin"
        case _:
            return "unknown"
```

## 4. Tooling

Ruff replaces flake8/isort/black. Check before formatting.

```bash
ruff check . && ruff format --check .
ruff check --fix . && ruff format .
```

```toml
[tool.ruff]
target-version = "py314"
line-length = 88
[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B", "A", "SIM", "RUF", "W"]
ignore = ["E501"]
[tool.ruff.lint.isort]
known-first-party = ["myapp"]
```

mypy/pyright strict on new code; narrow instead of ignoring.

```bash
mypy src tests
pyright
uvx ty check src   # Astral ty preview
```

```toml
[tool.mypy]
python_version = "3.14"
strict = true
warn_return_any = true
[tool.pyright]
typeCheckingMode = "strict"
pythonVersion = "3.14"
```

pytest: fixtures for setup, parametrize for tables, markers for slow.

```bash
pytest
pytest tests/test_core.py::test_greet -v
pytest -m "not slow and not network"
pytest --cov=myapp --cov-report=term-missing
```

```python
import pytest
from myapp.core import divide, greet
@pytest.fixture
def name() -> str:
    return "ada"
@pytest.mark.parametrize(("n", "want"), [("ada", "hello, ada"), ("root", "hello, root")])
def test_greet(n: str, want: str) -> None:
    assert greet(n) == want
def test_divide_by_zero() -> None:
    with pytest.raises(ZeroDivisionError):
        divide(1, 0)
```

Debugging: `breakpoint()` respects `PYTHONBREAKPOINT=0` in CI.

```python
result = compute(x)
breakpoint()
```

```bash
python -m pdb script.py arg1
pytest --pdb -x
PYTHONBREAKPOINT=0 pytest
```

## 5. Dependency management

```bash
uv init myapp --lib        # or --app for applications
uv venv && source .venv/bin/activate.fish
uv add httpx               # runtime dep, updates uv.lock
uv add --dev pytest coverage
uv remove httpx
uv lock --upgrade          # bump all pins
uv sync --frozen           # CI: exact install, no re-resolve
uv pip list && uv cache clean
```

pip fallback (only when uv is unavailable):

```bash
python -m venv .venv && source .venv/bin/activate.fish
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python -m pip freeze | tee requirements.txt
```

## 6. Code style

PEP 8 via ruff: 4-space indents, `snake_case` funcs/modules,
`PascalCase` classes, `UPPER_CASE` constants, sorted imports
(stdlib / third-party / first-party). Google-style docstrings on
public APIs; `logging` everywhere except CLI stdout (configured once
in `main()` via `logging.basicConfig()`).

```python
"""Module docstring: what this module provides."""
import logging
from dataclasses import dataclass
log = logging.getLogger(__name__)
@dataclass
class Config:
    """Runtime configuration.

    Args:
        host: Hostname to bind.
        port: TCP port to listen on.
    """
    host: str = "127.0.0.1"
    port: int = 8000
def start(cfg: Config) -> None:
    """Start the service described by cfg."""
    log.info("listening on %s:%d", cfg.host, cfg.port)
```

## 7. Performance notes

Measure first: `cProfile` for hot spots, `timeit` for snippets,
threads for I/O-bound, processes for CPU-bound (GIL).

```bash
python -m cProfile -s cumulative script.py | head -30
python -m timeit -s "import m" "m.func()"
```

```python
from pathlib import Path
import concurrent.futures
root = Path("src")
pyfiles = list(root.rglob("*.py"))
text = (root / "myapp" / "__init__.py").read_text(encoding="utf-8")
def work(path: Path) -> int:
    return len(path.read_bytes())
with concurrent.futures.ThreadPoolExecutor() as pool:   # I/O-bound
    sizes = list(pool.map(work, pyfiles))
with concurrent.futures.ProcessPoolExecutor() as pool:  # CPU-bound
    totals = list(pool.map(pow, range(1000), [2] * 1000))
```

## 8. Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `ModuleNotFoundError: No module named 'x'` | Wrong venv / not installed | `source .venv/bin/activate.fish`; `uv pip install -e .` |
| `activate` fails in fish | Wrong script | `source .venv/bin/activate.fish` (bash uses `activate`) |
| Import fails only under pytest | Tests see working tree | src layout; `uv pip install -e .`; run from root |
| `requires-python` conflict on `uv add` | Dep needs other Python | Read solver error; `uv python install 3.13` |
| pip installs but import fails | `pip`/`python` mismatch | Always `python -m pip`; check `sys.executable` |
| uv vs pip drift | Mixed managers | Standardize on `uv.lock`; export txt via `uv pip freeze` |
| `command not found: myapp` | venv inactive | Activate venv; `uv pip install -e .` |
| mypy `incompatible type` / `no attribute` | Missing narrowing | Annotate sigs; `assert x is not None`; `isinstance` guards |
| pyright `reportMissingImports` | Wrong interpreter | Point pyright venv at `.venv`; reinstall deps |
| ruff `UP` suggests too-new syntax | `target-version` too high | Set floor, e.g. `target-version = "py313"` |
| Blocking call hangs async test | Sync I/O in loop | `await asyncio.sleep`; wrap sync in `asyncio.to_thread` |

## 9. Minimal complete examples

CLI with argparse:

```python
# cli_argparse.py — python cli_argparse.py --name ada --count 2
import argparse, logging
log = logging.getLogger(__name__)
def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="Greet someone repeatedly.")
    p.add_argument("--name", default="world")
    p.add_argument("--count", type=int, default=1)
    p.add_argument("--debug", action="store_true")
    return p
def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    logging.basicConfig(level=logging.DEBUG if args.debug else logging.INFO)
    for _ in range(max(args.count, 0)):
        print(f"hello, {args.name}")
    return 0
if __name__ == "__main__":
    raise SystemExit(main())
```

Typed library + pytest test:

```python
# src/myapp/core.py
def greet(name: str) -> str:
    """Return a greeting for name."""
    return f"hello, {name}"
def divide(a: float, b: float) -> float:
    """Divide a by b; raises ZeroDivisionError on b == 0."""
    if b == 0:
        raise ZeroDivisionError("b must be nonzero")
    return a / b
# tests/test_core.py
import pytest
from myapp.core import divide, greet
def test_greet() -> None:
    assert greet("ada") == "hello, ada"
def test_divide() -> None:
    assert divide(3, 2) == pytest.approx(1.5)
    with pytest.raises(ZeroDivisionError):
        divide(1, 0)
```

```bash
uv pip install -e ".[dev]"
pytest -q && mypy src tests && ruff check . && ruff format --check .
```

Async fetch script:

```python
# async_fetch.py — uv run --with httpx async_fetch.py
import asyncio
import httpx
URLS = ["https://example.com", "https://example.org"]
async def fetch(client: httpx.AsyncClient, url: str) -> tuple[str, int]:
    resp = await client.get(url, timeout=10)
    return url, resp.status_code
async def main(urls: list[str]) -> None:
    async with httpx.AsyncClient(follow_redirects=True) as client:
        async with asyncio.TaskGroup() as tg:
            tasks = [tg.create_task(fetch(client, u)) for u in urls]
    for t in tasks:
        print(f"{t.result()[0]}: {t.result()[1]}")
if __name__ == "__main__":
    asyncio.run(main(URLS))
```
