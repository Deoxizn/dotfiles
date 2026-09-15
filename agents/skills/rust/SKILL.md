---
name: rust
description: >
  Expert knowledge for Rust development, including rustup toolchain management,
  Cargo manifests/workspaces/features, ownership/borrowing/lifetimes, error
  handling, testing, clippy/rustfmt lints and idioms, async with tokio, HTTP
  with axum/reqwest, serde/sqlx/clap/tracing, FFI/build scripts/WASM,
  cross-compilation, and troubleshooting compiler errors. REQUIRED when writing,
  reviewing, debugging, or building Rust code, or when running cargo/rustc
  commands. Grounded in current stable Rust (1.98.x, edition 2024). Covers
  rustup, cargo, rustc, rustfmt, clippy, rust-analyzer, tokio, axum, serde,
  sqlx, reqwest, clap, thiserror, anyhow, semver, MSRV, and cross targets.
  Triggers: rust, rustc, cargo, rustup, clippy, rustfmt, rust-analyzer,
  tokio, axum, serde, sqlx, reqwest, clap, anyhow, thiserror, tracing,
  borrow checker, lifetime, edition 2024, Cargo.toml, crates.io, docs.rs.
---

# Rust Skill

Expert agent for **Rust** development, from toolchain setup through async
services. Grounded in stable Rust (**1.98.x**, **edition 2024**); the
**Rust Book and std docs are authoritative**. Prefer `cargo` over raw
`rustc`, fix clippy warnings before commit, keep MSRV accurate.

## 0. Primary references

Language & standard library:

- **rust-lang.org** <https://www.rust-lang.org/> - **Book** <https://doc.rust-lang.org/book/> - **std** <https://doc.rust-lang.org/std/>
- **Rust by Example** <https://doc.rust-lang.org/rust-by-example/> - **Edition Guide** <https://doc.rust-lang.org/edition-guide/>
- **rustc** <https://doc.rust-lang.org/rustc/> - **rustdoc** <https://doc.rust-lang.org/rustdoc/>
- **Error codes** <https://doc.rust-lang.org/error_codes/> - **SemVer** <https://doc.rust-lang.org/cargo/reference/semver.html>

Cargo & ecosystem:

- **Cargo book** <https://doc.rust-lang.org/cargo/> - **manifest** <https://doc.rust-lang.org/cargo/reference/manifest.html>
- **Workspaces** <https://doc.rust-lang.org/cargo/reference/workspaces.html> - **features** <https://doc.rust-lang.org/cargo/reference/features.html>
- **crates.io** <https://crates.io/> - **docs.rs** <https://docs.rs/>
- **tokio** <https://docs.rs/tokio/> - **axum** <https://docs.rs/axum/> - **serde** <https://docs.rs/serde/>
- **sqlx** <https://docs.rs/sqlx/> - **clap** <https://docs.rs/clap/> - **reqwest** <https://docs.rs/reqwest/> - **tracing** <https://docs.rs/tracing/>

Tooling & platform:

- **rustup** <https://rust-lang.github.io/rustup/> - **rust-analyzer** <https://rust-analyzer.github.io/manual.html>
- **Clippy lints** <https://rust-lang.github.io/rust-clippy/master/> - **ArchWiki Rust** <https://wiki.archlinux.org/title/Rust>

## 1. Toolchain setup

Use `rustup`. Stable is **1.98.x**; **edition 2024** (stabilized in 1.85.0)
is the default for `cargo new`. Train: stable every 6 weeks, `beta` next,
`nightly` for `-Z` flags.

```bash
sudo pacman -S rustup       # Arch build; self-update via pacman, not rustup
rustup default stable && rustup update
rustup toolchain install beta nightly
rustup component add rust-analyzer clippy rustfmt rust-src
rustup target add wasm32-unknown-unknown x86_64-pc-windows-gnu
rustup show
```

```toml
# rust-toolchain.toml (commit to git)
[toolchain]
channel = "1.98"
components = ["clippy", "rustfmt", "rust-analyzer", "rust-src"]
targets = ["wasm32-unknown-unknown"]
profile = "minimal"
```

```toml
[package]
name = "myapp"
version = "0.1.0"
edition = "2024"
rust-version = "1.85"  # MSRV: oldest supported compiler; test it in CI
```

Arch: `rust` is one system-wide stable; `rustup` ships only manager shims,
so run `rustup default stable` (`self update` disabled). rust-analyzer
needs `rust-src` (system path: `/usr/lib/rustlib/src/rust/library/`).

## 2. Cargo project layout

```bash
cargo new myapp            # binary: src/main.rs
cargo new mylib --lib      # library: src/lib.rs
cargo init --edition 2024  # existing directory
```

```text
myapp/
  Cargo.toml  Cargo.lock  rust-toolchain.toml  build.rs (optional)
  src/main.rs  src/lib.rs  tests/  benches/  examples/
```

```toml
[package]
name = "myapp"
version = "0.1.0"
edition = "2024"
rust-version = "1.85"
license = "MIT OR Apache-2.0"
[dependencies]
serde = { version = "1", features = ["derive"] }
tokio = { version = "1", features = ["full"] }
anyhow = "1"
thiserror = "2"
[features]
default = ["tls"]
tls = ["reqwest/rustls-tls"]
[profile.release]
opt-level = 3
lto = true
codegen-units = 1
strip = true
```

Workspaces (one lockfile at root, shared pins, `resolver = "2"`):

```toml
[workspace]
members = ["crates/*"]
resolver = "2"
[workspace.dependencies]
serde = { version = "1", features = ["derive"] }
tokio = { version = "1", features = ["full"] }
# crates/api/Cargo.toml: serde.workspace = true / tokio.workspace = true
```

```bash
cargo build && cargo check        # check: fast typecheck, default loop
cargo clippy --all-targets -- -D warnings
cargo fmt --check && cargo fmt && cargo test
cargo add serde --features derive && cargo remove tempfile
cargo update -p hyper && cargo tree -i serde
cargo audit                       # via cargo-audit: CVE scan
cargo doc --no-deps --open && cargo publish --dry-run
```

Commit `Cargo.lock` for binaries, not libraries; prefer `cargo add`.

## 3. Language essentials

Ownership, borrowing, lifetimes:

```rust
fn takes_ownership(s: String) { println!("{s}"); }
fn borrows(v: &[i32]) { println!("{}", v.len()); }
fn mut_borrows(w: &mut Vec<i32>) { w.push(5); }
fn main() {
    let s = String::from("hello");
    takes_ownership(s);
    // println!("{s}"); // ERROR E0382: use of moved value
    let v = vec![1, 2, 3];
    borrows(&v); // v still usable
}
fn longest<'a>(a: &'a str, b: &'a str) -> &'a str { // output tied to input
    if a.len() >= b.len() { a } else { b }
}
```

Structs, enums, traits, generics:

```rust
enum Shape { Circle(f64), Rect { w: f64, h: f64 } }
trait Area { fn area(&self) -> f64; }
impl Area for Shape {
    fn area(&self) -> f64 {
        match self { // exhaustive, no wildcard arm
            Shape::Circle(r) => std::f64::consts::PI * r * r,
            Shape::Rect { w, h } => w * h,
        }
    }
}
fn biggest<T: Area>(a: T, b: T) -> f64 { a.area().max(b.area()) }
```

`Result`/`Option` and `?`:

```rust
fn read_number(path: &str) -> Result<i32, Box<dyn std::error::Error>> {
    let text = std::fs::read_to_string(path)?; // early-return on Err
    Ok(text.trim().parse()?) // error converts via From
}
fn doubled_first_even(xs: &[i32]) -> Option<i32> {
    Some(xs.iter().copied().find(|x| x % 2 == 0)? * 2) // ? works on Option
}
```

Iterators, closures, smart pointers:

```rust
let total: i32 = (1..=100).filter(|x| x % 2 == 0).map(|x| x * x).sum();
let factor = 3;
let scaled: Vec<i32> = vec![1, 2, 3].into_iter().map(|x| x * factor).collect();
enum List { Nil, Cons(i32, Box<List>) } // Box: heap, single owner
let shared = std::rc::Rc::new(std::cell::RefCell::new(vec![])); // !Send (Cell is the Copy equivalent)
shared.borrow_mut().push(1);
let counter = std::sync::Arc::new(std::sync::Mutex::new(0u64)); // shared + Send
let w = std::sync::Arc::clone(&counter);
std::thread::spawn(move || *w.lock().unwrap() += 1).join().unwrap();
```

Threads, `Send`/`Sync`, async/await, tokio:

```rust
fn assert_send_sync<T: Send + Sync>() {}
#[tokio::main(flavor = "multi_thread", worker_threads = 4)]
async fn main() -> anyhow::Result<()> {
    assert_send_sync::<std::sync::Arc<std::sync::Mutex<u64>>>(); // Rc is neither
    let (a, b) = tokio::join!(
        tokio::spawn(fetch("https://example.com/a")),
        tokio::spawn(fetch("https://example.com/b")));
    println!("{:?} {:?}", a??, b??);
    let parsed = tokio::task::spawn_blocking(expensive_parse).await??; // never block async
    Ok(())
}
async fn fetch(url: &str) -> anyhow::Result<String> {
    Ok(reqwest::get(url).await?.text().await?)
}
```

Macros, modules, visibility:

```rust
macro_rules! say_n {
    ($msg:expr, $n:expr) => { for _ in 0..$n { println!("{}", $msg); } };
}
#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
struct Point { x: f64, y: f64 }
// `pub mod api;` + `mod internal;`: `pub` everywhere, `pub(crate)` crate-only.
```

Error handling (`thiserror` libs, `anyhow` apps):

```rust
#[derive(Debug, thiserror::Error)]
pub enum StoreError {
    #[error("io failure at {path}: {source}")]
    Io { path: String, #[source] source: std::io::Error },
    #[error("entry {0} not found")]
    NotFound(String),
}
fn load(path: &str) -> anyhow::Result<String> {
    std::fs::read_to_string(path).with_context(|| format!("reading {path}"))
}
```

Testing (unit, integration, doc):

```rust
pub fn add(a: i32, b: i32) -> i32 { a + b }
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn adds() { assert_eq!(add(2, 3), 5); }
} // tests/ use the public API only; doc tests run via `cargo test`:
/// Adds one.
///
/// ```
/// assert_eq!(mylib::add(1, 1), 2);
/// ```
```

## 4. Idioms and lints

```bash
cargo clippy --all-targets --all-features -- -D warnings && cargo fmt --all --check
```

```toml
# rustfmt.toml: 2024-style defaults are sane; add only deltas
max_width = 100
imports_granularity = "Crate"
group_imports = "StdExternalCrate"
```

```toml
# Cargo.toml lint table
[lints.rust]
unsafe_code = "forbid"
missing_docs = "warn"
[lints.clippy]
pedantic = "warn"
nursery = "warn"
cargo = "warn"
```

Checklist: `#[must_use]` pure queries; exhaustive matches; `From`/`Into`
(infallible) and `TryFrom`/`TryInto` (fallible); `Display` for users,
`Debug` for developers; newtype primitives. `Deref` only for real smart
pointers, never fake inheritance; expose inners via `as_*()` methods.

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct Cents(u64);
impl From<u64> for Cents {
    fn from(v: u64) -> Self { Self(v) }
}
impl std::fmt::Display for Cents {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "${}.{:02}", self.0 / 100, self.0 % 100)
    }
}
#[must_use]
pub fn total(prices: &[Cents]) -> Cents {
    prices.iter().map(|c| c.0).sum::<u64>().into()
}
```

## 5. Async ecosystem

Tokio: `multi_thread` (servers) vs `current_thread` (tools; never block).
Versions: tokio 1.53, axum 0.8, serde 1.0, sqlx 0.8/0.9, reqwest 0.12/0.13, clap 4.x, tracing 0.1.

```rust
use axum::{Json, Router, extract::{Path, Query, State}, http::StatusCode, routing::get};
#[derive(Clone)]
struct AppState { db: sqlx::PgPool }
#[derive(serde::Deserialize)]
struct ListParams { limit: Option<u32> }
async fn health() -> &'static str { "ok" }
async fn get_user(
    State(st): State<std::sync::Arc<AppState>>,
    Path(id): Path<i64>,
    Query(q): Query<ListParams>,
) -> Result<Json<serde_json::Value>, (StatusCode, String)> {
    let _ = (&st, q);
    Ok(Json(serde_json::json!({ "id": id })))
}
// Router::new().route("/health", get(health)).route("/users/{id}", get(get_user)) + axum::serve
```

```rust
#[derive(Debug, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
struct Config {
    listen_addr: String,
    #[serde(default = "default_workers")]
    workers: usize,
    #[serde(skip_serializing_if = "Option::is_none")]
    token: Option<String>,
    #[serde(flatten)]
    extra: std::collections::HashMap<String, serde_json::Value>,
}
fn default_workers() -> usize { 4 }
// sqlx: compile-time checked SQL, no DSL. Needs DATABASE_URL or sqlx-data.json.
let pool = sqlx::PgPool::connect(&std::env::var("DATABASE_URL")?).await?;
let row = sqlx::query!("SELECT id, name FROM users WHERE id = $1", user_id)
    .fetch_one(&pool).await?;
// reqwest: reuse one Client for connection pooling.
let client = reqwest::Client::new();
let body: serde_json::Value = client.get("https://api.example.com/v1/items")
    .send().await?.error_for_status()?.json().await?;
#[derive(Debug, clap::Parser)] // CLI from a struct
#[command(name = "myapp", version, about = "Example CLI")]
struct Cli {
    #[arg(long, default_value = "127.0.0.1:3000")]
    listen: String,
    #[arg(short, action = clap::ArgAction::Count)]
    verbose: u8,
    #[command(subcommand)]
    cmd: Cmd,
}
#[derive(Debug, clap::Subcommand)]
enum Cmd { Serve, Migrate { #[arg(long)] dry_run: bool } }
tracing_subscriber::fmt().with_env_filter("myapp=debug,tower_http=info").init(); // tracing
```

## 6. FFI, build scripts, and WASM

FFI calls are `unsafe`; prefer `cxx`/`safer-ffi` over hand-rolled C++
bindings. `build.rs` runs pre-compile: drive `cc`/`bindgen`, emit
`cargo:rerun-if-changed` and `cargo:rustc-link-lib` directives.

```rust
// Minimal C call without the libc crate.
unsafe extern "C" { fn getpid() -> i32; }
fn pid() -> i32 {
    // SAFETY: getpid takes no args and always succeeds.
    unsafe { getpid() }
}
// build.rs
fn main() {
    cc::Build::new().file("src/native/helper.c").compile("helper");
    println!("cargo:rerun-if-changed=src/native/helper.c");
}
```

WASM: `wasm32-unknown-unknown` + `wasm-pack` for browsers (keep CLI/lib versions in sync); `wasm32-wasip2` for WASI.

```bash
rustup target add wasm32-unknown-unknown wasm32-wasip2
cargo build --target wasm32-unknown-unknown && wasm-pack build --target web
```

## 7. Cross-compilation targets

```bash
rustup target list --installed
rustup target add aarch64-unknown-linux-gnu x86_64-pc-windows-gnu
cargo build --target aarch64-unknown-linux-gnu
cargo build --release --target x86_64-pc-windows-gnu
```

| Target | Use case |
| --- | --- |
| `x86_64-unknown-linux-gnu` | Native Linux (this machine) |
| `aarch64-unknown-linux-gnu` | ARM64 Linux servers / SBCs |
| `x86_64-pc-windows-gnu` | Windows via MinGW (`mingw-w64-gcc` on Arch) |
| `aarch64-apple-darwin` | Apple Silicon macOS |
| `wasm32-unknown-unknown` | Browser WASM via wasm-bindgen |
| `wasm32-wasip2` | Server-side WASI components |
| `x86_64-unknown-linux-musl` | Static musl binaries (`musl` package) |

Non-native targets need a linker (`~/.cargo/config.toml`):

```toml
[target.x86_64-pc-windows-gnu]
linker = "/usr/bin/x86_64-w64-mingw32-gcc"
ar = "/usr/bin/x86_64-w64-mingw32-ar"
[target.aarch64-unknown-linux-gnu]
linker = "aarch64-linux-gnu-gcc"
```

On Arch use `rustup` for cross (system `rust` ships host std only); linker
errors after `target add` mean the cross toolchain package is missing.

## 8. Troubleshooting

| Error / symptom | Cause | Fix |
| --- | --- | --- |
| `E0382` use of moved value | Value moved then reused | Borrow (`&v`); `clone()` only if cheap; return ownership |
| `E0499` double `&mut` borrow | Two live exclusive borrows | Narrow scopes; split disjoint field borrows |
| `E0502` `&` while `&mut` alive | Shared borrow during exclusive one | End `&mut` use first (NLL); copy out, then share |
| Lifetime `E0106` / elided mismatch | Returned ref outlives input | Explicit `<'a>` on output; never return refs to locals |
| `future cannot be sent` | `Rc`/`RefCell`/`MutexGuard` across `.await` | `Arc` + `tokio::sync::Mutex`; drop guards before await |
| `linking with cc failed` | Missing linker/system libs | `sudo pacman -S base-devel openssl pkgconf` |
| `can't find crate for std` | Target std missing | `rustup target add <triple>`; check `--installed` |
| `requires rustc 1.YY` | Dep MSRV above toolchain | `rustup update`; or pin older dep |
| `Cargo.lock` churn | Overbroad `cargo update` | `cargo update -p <crate>`; caret ranges in libs |
| `cargo publish` verify fail | Bad metadata/stray files | `cargo package --list`; fill `description`/`license` |
| Test deadlock on async mutex | Lock held across `.await` | Shrink critical section; clone out, drop, then await |
| rust-analyzer won't load | Missing sysroot sources | `rustup component add rust-src`; reload window |

Loop: read the full error (suggestions are usually right), reproduce
minimally, `cargo check` first, then clippy, then test. Look up codes at
<https://doc.rust-lang.org/error_codes/> before guessing.

## 9. Minimal complete examples

CLI with clap:

```rust
use anyhow::Context;
use clap::Parser;
#[derive(Debug, Parser)]
#[command(name = "greet", version, about = "Greet someone, quickly")]
struct Cli {
    name: String,
    #[arg(short, long)]
    loud: bool,
}
fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();
    let msg = format!("hello, {}", if cli.loud { cli.name.to_uppercase() } else { cli.name });
    println!("{msg}");
    std::fs::write("/tmp/greet-last.txt", &msg).context("recording greeting")?;
    Ok(())
}
```

```toml
[package]
name = "greet"
version = "0.1.0"
edition = "2024"
rust-version = "1.85"
[dependencies]
anyhow = "1"
clap = { version = "4", features = ["derive"] }
```

Async HTTP server with axum:

```rust
use axum::{Json, Router, routing::get};
async fn health() -> &'static str { "ok" }
async fn version() -> Json<serde_json::Value> {
    Json(serde_json::json!({ "name": "demo", "version": env!("CARGO_PKG_VERSION") }))
}
#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt().with_env_filter("demo=debug").init();
    let app = Router::new()
        .route("/health", get(health))
        .route("/version", get(version))
        .layer(tower_http::trace::TraceLayer::new_for_http());
    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000").await?;
    axum::serve(listener, app).await?;
    Ok(())
}
```

```toml
[package]
name = "demo"
version = "0.1.0"
edition = "2024"
rust-version = "1.85"
[dependencies]
anyhow = "1"
axum = "0.8"
serde_json = "1"
tokio = { version = "1", features = ["full"] }
tower-http = { version = "0.6", features = ["trace"] }
tracing-subscriber = { version = "0.3", features = ["env-filter"] }
```

Library crate with tests:

```rust
//! ```
//! assert_eq!(stats::mean(&[1.0, 2.0, 3.0]), Some(2.0));
//! ```
/// Arithmetic mean, or `None` for empty input.
#[must_use]
pub fn mean(xs: &[f64]) -> Option<f64> {
    (!xs.is_empty()).then(|| xs.iter().sum::<f64>() / xs.len() as f64)
}
/// Median of a copied, sorted sample, or `None` for empty input.
#[must_use]
pub fn median(xs: &[f64]) -> Option<f64> {
    if xs.is_empty() { return None; }
    let mut s = xs.to_vec();
    s.sort_by(|a, b| a.total_cmp(b));
    let m = s.len() / 2;
    if s.len() % 2 == 1 { Some(s[m]) } else { Some((s[m - 1] + s[m]) / 2.0) }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn mean_of_empty_is_none() { assert_eq!(mean(&[]), None); }
    #[test]
    fn median_even_count() { assert_eq!(median(&[3.0, 1.0, 2.0, 4.0]), Some(2.5)); }
}
```
