# AI Revit CAD — Experimental

AI Revit CAD is a standalone public Rust and Makepad BIM/CAD repository. Its root is the Cargo workspace for the application; the project no longer depends on a neighboring Rust Makepad Toolkit checkout.

The application source is MIT licensed. Third-party components retain their own licenses; see [LICENSE](LICENSE) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). This is an experimental source distribution, not a certified engineering product.

## Modules and status

| Module | Available source surface | Status |
|---|---|---|
| BIM / Document | Levels, grids, walls, openings, slabs, project history, typed IDs, versioned Save/Open | Prototype; tests cover supported contracts |
| 2D CAD / Drafting | Drawing entities, selection/editing, dimensions/annotations, supported ASCII DXF subset | Experimental; no native DWG backend claim |
| Viewer / Geometry | Scene/camera, picking, mesh quantities, supported collision and section geometry | Experimental; private project assets excluded |
| GEO | Boreholes, intervals, IGE/material provenance, bounded TIN, geological sections and spatial queries | Partial; synthetic fixtures and limited interpolation, not site approval |
| GEO-SLOPE | Existing planar/circular dry-ground methods, Fellenius/Bishop and bounded critical search | Experimental / Partial; method-specific physical limits remain |
| STRUCTURAL | Bounded linear-elastic truss/frame core, typed loads, reactions, parameterized multi-section steel geometry | Partial; dense limits remain 64 nodes / 128 members; no full material-specific code compliance |
| FOUNDATION | Existing rigid raft / compression-only contact, explicit assumed bedding stiffness, source-bound reactions and ground context | Partial; spring displacements are preliminary estimates |
| Native UI / automation | Makepad 2D/3D source; manual app input | Experimental; source/build checks do not establish native acceptance |

Normative ULS bearing capacity, code-verified layered settlement, reinforcement, punching, groundwater/pore pressure, piles and a complete building safety check are **not** declared implemented. A positive numerical result is not engineering approval. Synthetic geology is explicitly marked and does not represent a real site. Mesh colors and visual triangles are not the source of calculation data.

## Native UI and GPU limits

The public distribution does not provide the private Windows UI Automation action hooks used by local development tooling. UIA fixture modes are rejected; manual Makepad input remains available. Native, Remote and Linux GUI acceptance must be established separately.

Raw D3D11 device/texture access, GPU selection policy, viewport GPU export and native GPU profiling depend on hooks absent from the pinned public SDK. Those operations report **UNSUPPORTED_PUBLIC_SDK**; adapter identity and VRAM remain unknown. A required-GPU request is not satisfied by a CPU fallback. The ordinary Makepad draw path is unchanged, and GPU/native qualification remains **NOT_TESTED**.

The nine proposed GEO/Foundation desktop agent routes are not registered in this source snapshot. The ordinary app API is loopback-only; publication does not start an application, service or API listener.

## Build

Requirements: Git, a stable Rust toolchain with edition 2024 support, and Makepad platform build tools. Windows builds require MSVC C++ Build Tools and the Windows SDK. Python 3.11+ is optional for source-bound engineering examples.

From PowerShell:

    git clone https://github.com/paulgreenbox-beep/ai-revit-cad.git
    cd ai-revit-cad
    ./tools/bootstrap-makepad.ps1
    cargo check --locked -p ai_revit_desktop -j1
    cargo build --locked -p ai_revit_desktop --bin ai_revit_desktop -j1
    cargo test --locked --workspace --all-targets -j1 -- --test-threads=1
    cargo test --locked --manifest-path deps/viewer_core/Cargo.toml -j1 -- --test-threads=1

The bootstrap fetches the public Makepad revision 105158e08c89d47f57af4621420ed68eb3a147ce into the ignored repository-root .deps/makepad directory and verifies that checkout. It does not need a neighboring Toolkit tree, private SDK, submodule credential or project dataset. The Makepad SDK remains a separately licensed dependency; see [third-party notices](THIRD_PARTY_NOTICES.md).

## Source-bound GEO/Foundation example

The CLI takes exactly one bounded JSON request file as its command-line argument. The demo_state operation constructs synthetic source data. Analyses are explicit operations; Open, Undo and Redo do not run a solver.

From the repository root, after bootstrapping the SDK:

    $env:AI_REVIT_GF_COMPILED_SOURCE_MANIFEST_SHA256 = python tools/source_fingerprint.py
    cargo build --locked -p ai_revit_core --example geo_foundation_cli -j1
    cargo build --locked -p ai_revit_desktop --bin ai_revit_desktop -j1
    $env:AI_REVIT_GF_SOURCE_MANIFEST_SHA256 = $env:AI_REVIT_GF_COMPILED_SOURCE_MANIFEST_SHA256
    $env:AI_REVIT_GF_EXECUTABLE_SHA256 = (Get-FileHash target/debug/ai_revit_desktop.exe -Algorithm SHA256).Hash
    ./target/debug/ai_revit_desktop.exe

The fingerprint binds the application source, lock and pinned clean SDK revision; it is not a full compiler/OS input trace. Source changes require rebuilding and a new fingerprint. The current standalone fingerprint and verification details belong in [validation.json](validation.json).

For a synthetic CLI request:

    [IO.File]::WriteAllText('demo-request.local.json', '{"operation":"demo_state"}')
    ./target/debug/examples/geo_foundation_cli.exe demo-request.local.json

See [the typed Core contract](crates/core/src/geo_foundation.rs) and [the CLI request interface](crates/core/examples/geo_foundation_cli.rs).

## Tests and distribution boundary

Small first-party synthetic inputs and independent high-precision numerical references are included as test source. Large generated report archives are not committed. Archive/persistence tests explicitly initialize fresh synthetic fixtures in a new process-owned temporary directory, using the current solver source identity. Their generated numbers are setup data, not independent goldens. The separate historical-identity control verifies Stale behavior; it is not proof from a historical solver run. Numerical golden tests remain separate.

Hardware CUDA tests require an explicitly selected supported NVIDIA adapter and remain ignored without that opt-in. A Rust test or successful compile does not prove native GUI, GPU, engineering or release acceptance.

Excluded: credentials/tokens, private configurations, user-profile paths, customer and site materials, SAD RASTSVET materials, FH-87 project meshes/BREP/identity maps, captures, old validation bundles, local persistence-driver profiles, SDK/vendor assets/fonts, executables, target/, caches and generated reports. The generic mesh decoder and procedural synthetic viewer scenes remain available. There is no DWG/STEP import/export promise without a real licensed backend.

The current standalone verification record is [validation.json](validation.json). Historical Toolkit-package results are preserved separately in [docs/validation-toolkit-snapshot.json](docs/validation-toolkit-snapshot.json); they are not a rerun or acceptance record for this standalone repository. See [PUBLICATION.md](PUBLICATION.md) for publication origin, repository boundaries and validation limits.
