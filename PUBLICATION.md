# Publication record

## Origin and repository history

AI Revit CAD was previously published as the apps/ai-revit-cad subtree of [Rust Makepad Toolkit](https://github.com/paulgreenbox-beep/rust-makepad-toolkit). The source publication commit was 2dd70fc0497d5b3065197cffb3943eab9a261103.

This repository is the standalone publication at [paulgreenbox-beep/ai-revit-cad](https://github.com/paulgreenbox-beep/ai-revit-cad). Its extracted Git subtree history begins at bb0bb25e6111d98cab5caaa88ce961b79a462a83, derived from that source publication. The move gives the project its own repository root and Cargo workspace; it does not claim new engineering behavior or alter the mathematical methods and numerical goldens.

## Standalone dependency boundary

Clone this repository and run [the bootstrap script](tools/bootstrap-makepad.ps1) from its root. The script fetches and verifies the public Makepad SDK at 105158e08c89d47f57af4621420ed68eb3a147ce under the ignored root .deps/makepad. Application manifests use that root-local SDK path. A neighboring Toolkit checkout, private SDK, or Toolkit-only helper crate is not required.

The Viewer source is included under deps/viewer_core with its own workspace boundary. The public source distribution preserves the MIT project license and third-party notices. The minimal vendored CADCraft DXF crate retains its MIT/Apache notices. No DWG backend, private site model, font bundle or SDK/vendor tree is redistributed. See [LICENSE](LICENSE), [third-party notices](THIRD_PARTY_NOTICES.md) and [exclusion rules](excluded-files.json).

The repository contains the unified BIM Document/history/persistence, geometry, 2D drafting and supported DXF subset, Viewer core, GEO data/queries, existing GEO-SLOPE mathematics/reporting/jobs/host, structural math and multi-section steel configuration, and rigid foundation contact integration. GEO, FOUNDATION and STRUCTURAL remain **Experimental / Partial**.

## Validation records

The standalone checkout's current local verification, source fingerprint and build hashes are recorded in [validation.json](validation.json). Read that file for evidence tied to this repository; a source fingerprint or local executable hash is not a reproducible-build guarantee.

On 2026-10-27 the standalone checkout passed 106 pure-module tests, 14 focused
Document GEO/Foundation tests and 26 Viewer tests (146 passed, no failures).
The desktop executable and GEO/Foundation CLI built against its own clean SDK.
Four fresh CLI processes passed 11 checks covering synthetic creation,
structural-to-foundation reactions, saving and reopening with preserved project
IDs, loads and archives. The earlier full workspace suite was not repeated for
this layout-only move; all 266 implementation files and numerical goldens were
preserved. Compiler warnings remain. No GUI was launched.

The previous Toolkit package had the following historical results:

| Historical check in the Toolkit package | Recorded result |
|---|---|
| Workspace tests | 953 passed, 0 failed, 1 hardware CUDA test ignored |
| Standalone Viewer tests | 26 passed, 0 failed |
| Synthetic headless lifecycle | 20 fresh processes, 82 assertions, 0 failures |

These figures belong to the earlier package validation and were not rerun by extracting the standalone repository. The complete historical record is preserved in [docs/validation-toolkit-snapshot.json](docs/validation-toolkit-snapshot.json). It does not establish that a fresh standalone clone builds or passes the same checks.

## Limits and acceptance

The public Makepad pin does not include the private checked Windows UIA action hooks or raw D3D11 device/texture, GPU selection, viewport export and profiling hooks used in local development. The public boundary rejects UIA fixture modes and reports **UNSUPPORTED_PUBLIC_SDK** for unsupported GPU operations; it does not invent adapter identity or VRAM, weaken required-GPU admission, or treat CPU fallback as satisfying a GPU request.

Native UI workflows, GPU hardware qualification and normative engineering methods are not accepted by a successful source check, compilation, headless test or historical Toolkit result. The application remains an experimental source distribution. This publication makes no native GUI, hardware GPU, engineering or release acceptance claim.

Generated calculation archives, process receipts, local logs and executable files remain outside Git.
