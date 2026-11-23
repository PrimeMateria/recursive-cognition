# Implementation Plan: Production-Grade Development of the Grounded Multiplicity Recursive Cognition Engine

**Target Subsystem:** `/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/recursive-cognition`  
**Canonical Root:** The path above is the single canonical root. Every source file, config, harness, report, attestation, release, and log produced by this plan must resolve below it.  
**Governing ADR:** [ADR-0015](ADR-0015.md) (recursive-cognition local register, succeeding baseline ADR-001…ADR-014); toolchain pin amended by [ADR-0016](ADR-0016.md); model-content gate closed by [ADR-0017](ADR-0017.md)  
**Frozen Baseline:** `Multiplicity-Recursive Cognition Engine.txt` (v3.3 planning baseline — read-only external reference, not an implementation artifact; not linked because it is not present under `RC_ROOT`)  
**Parent Framework:** Multiplicity Theory & QARI Cognitive Architecture  
**Reference Parity:** [`kuramoto-prism`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/kuramoto-prism), [`o3de-prism`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/o3de-prism), [`skip-logic`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/skip-logic)  
**Observed Toolchain:** canonical `lexlean 0.4.3` + `leanprover/lean4:v4.32.2` + `prismpm 0.5.0 check` and `verify` (ADR-0016/ADR-0017); historical spike `lexlean 0.4.0` + v4.32.1 + `prismpm 0.4.0` (ADR-001); `lexlean 0.4.5` evaluated and rejected (PrismPM `LLC0103`); `prism-code 0.11.1` installed as a supporting launcher only; `Kani 0.68.0` reserved for Phase 3  
**Date:** 2026-11-23  
**Status:** Phase 0 (governance) and Phase 1 (conformance spike) complete. Toolchain pin superseded by ADR-0016 with a reproducible v4.32.2 attestation; governed PrismPM verification closed by ADR-0017. ADR-001 accepted on historical evidence; Phases 2–5 not started.

---

## 1. Executive Summary

The v3.3 baseline established *what* to build and identified five open verification obligations. Its own review found the recurring defect: **claims were asserted but not evidenced**. This plan closes that gap by adopting the production discipline already proven in the sibling Prism subsystems: a single authoritative runner, fail-closed local and CI gates, automated dual-format reports, pinned reproducible toolchains, content-addressed releases, and an explicit traceability chain from requirement → ADR → invariant → harness → attestation → release.

The distinguishing constraint for this subsystem is **localization**: production is not merely "preferred" inside the target folder — it is mandatory. No production artifact may be written to, read as authoritative from, or linked through any path outside `/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/recursive-cognition`. This is enforced mechanically in test suite `TS-01` and is a release-blocking invariant (`INV-RC-0015-a`).

Following industry practice (ISO/IEC/IEEE 42010 architecture decisions, NIST SP 800-53 control mapping, NIST SSDF / SLSA-style provenance, shift-left fail-closed CI, and evidence-graded claims E0–E6), the plan is documentation-first: this change creates only the plan and its ADR. Source, configuration, and verification scripts are untouched and are scheduled in Phases 1–6.

---

## 2. Scope, Baseline, and Non-Goals

### 2.1 Frozen baseline (do not modify)

- `Multiplicity-Recursive Cognition Engine.txt` remains the immutable v3.3 planning baseline.
- Baseline ADR-001…ADR-014 remain locally stable. This plan adds **ADR-0015** as the governance decision for production-grade development; it does not renumber, supersede, or silently reinterpret any baseline ADR.
- The five open obligations and six RAID seeds in the baseline are carried forward unchanged in §11.

### 2.2 In scope

1. A local production directory structure rooted at the target folder (§5).
2. An invariant register with named enforcement sites and NIST control mapping (§4).
3. A requirements → ADR → evidence traceability matrix (§6).
4. A 9-suite verification runner with domain-specific stress and Kani sub-suites (§7).
5. Pinned toolchains, lockfiles, hermetic configuration, and tool digest manifest (§7.6, `TS-01`–`TS-03`).
6. Dual-retention automated reporting (timestamped artifact + canonical `LATEST` reference) (§7.5).
7. Fail-closed pre-commit and GitHub Actions gates with receipt linking (§8–§9).
8. Phased delivery with PDR / CDR / TRR-1 / TRR-2 exit criteria (§10).

### 2.3 Out of scope / deliberate non-goals

- **No verified claim** until TRR-2 passes with real attestations and harness output.
- **No replacement of Mathlib for the continuous `m_inter` proof.** ADR-005 keeps `m_inter_bounds_drift` as a named TCB hypothesis until a real-analysis proof exists.
- **No global ADR allocation.** Numbering is namespace-local; no mount-wide "ADR-00NN" is asserted because no authoritative mount-wide allocator exists.
- **No writes outside the canonical root**, including sibling subsystems, shared `/tmp` evidence, or global registries.
- **No implementation in this change.** This is the governance phase only.

---

## 3. Production Boundary and Localization Contract

### 3.1 Canonical root rule

Set `RC_ROOT` once, absolutely:

```bash
RC_ROOT=/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/recursive-cognition
test "$(realpath "$RC_ROOT")" = "$RC_ROOT" || { echo 'non-canonical root'; exit 1; }
```

All runner paths are derived from `RC_ROOT`. The runner must refuse to start if the resolved root differs from the configured root, if the root is a symlink, or if any evidence path resolves outside it.

### 3.2 Allowed production areas (all relative to `RC_ROOT`)

| Area | Purpose | Mutability | Retention |
| :--- | :--- | :--- | :--- |
| `src/`, `language/` | Single-source `.lex.tex` formal artifacts and closed lexicons | Reviewed source | Versioned |
| `runtime/`, `harnesses/` | Rust runtime modules and Kani harnesses | Reviewed source | Versioned |
| `.lexlean/verified/`, `.lexlean/build/` | Checked/verified intermediates and attestations | Tool-generated | Versioned receipts only; no secrets |
| `.lexlean/production/` | Certified exports | Tool-generated | Content-addressed |
| `production/build/<sha>/` | PrismPM immutable release packages | Tool-generated | Immutable |
| `reports/` | Machine + human-readable evidence | Runner-generated | Dual retention |
| `docs/` | This plan, its ADR, and future local governance | Reviewed source | Versioned |

`production/` is a **build-output root**, not a source home and not a dumping ground for notes. Plans and ADRs live in `docs/`; harnesses live at the subsystem root or `harnesses/`.

### 3.3 Prohibited patterns (release-blocking)

- Writing any artifact outside `RC_ROOT`, including temporary evidence that is later copied back in.
- Symlinks or hardlinks whose target resolves outside `RC_ROOT`.
- Absolute paths in `lexlean.toml`, `prismpm.toml`, runner config, or CI config that point outside `RC_ROOT`.
- Evidence imported from another subsystem, another checkout, or a pasted terminal transcript.
- Unpinned tool downloads or mutable dependencies in the verification path.
- Editing the frozen v3.3 baseline in place.

### 3.4 Enforcement

`TS-01` executes the boundary audit and fails closed on any violation:

```bash
test "$(realpath "$RC_ROOT")" = "$RC_ROOT"
find "$RC_ROOT" -type l -print0 | xargs -0 -r realpath | grep -qv "^$RC_ROOT/" && exit 1
rg -n '/run/media/|/tmp/|\.\./\.\./' "$RC_ROOT"/*.toml "$RC_ROOT"/.github "$RC_ROOT"/run_tests.py && exit 1
```

The same audit runs in pre-commit and in CI with `RC_ROOT` set to the checked-out canonical path. A failure produces no `LATEST` report update.

---

## 4. Architecture and Invariant Register

Eight invariants make the plan's decisions machine-checkable. Each has one named enforcement site; an invariant without an enforcement site is not accepted (ADR methodology refinement).

| Invariant ID | Target property | Verification strategy | Design class | NIST controls |
| :--- | :--- | :--- | :--- | :--- |
| **INV-RC-0015-a** | **Production localization** — every artifact resolves below `RC_ROOT`; no escaping links or absolute paths | `TS-01` canonical-root audit; symlink and config scan; CI replay | Safety-First | SC-7, CM-3 |
| **INV-RC-0015-b** | **Evidence-before-claim** — no `verified` label without attestation + harness output | Report generator refuses claim labels without receipt IDs; ADR-014 CI gate | Safety-First | SI-7, CA-2, AU-10 |
| **INV-RC-0015-c** | **Reproducible toolchain** — pinned Lean/lexlean/PrismPM/Kani, lockfile parity, tool digests | `TS-01`–`TS-03`; `tools.lock`; `lexlean lock --check` | Safety-First | CM-3, SI-7, SA-12 |
| **INV-RC-0015-d** | **Discrete safety** — `h(x_{k+1}) ≥ (1−γ)h(x_k) + m_inter`, `γ ∈ (0,1]`; no double-count in passive `M_0` check | `dt_cbf_forward_invariant` in LexLean; Kani `REQ-SAF-01`, `REQ-OPT-01` | Safety-First | SI-7, SA-11 |
| **INV-RC-0015-e** | **Spectral integrity** — 11 disjoint prime-boundary bins over 1–30 Hz; normalized JS distance in `[0,1]` | `prime_bin_partition`, JS definition + property tests on synthetic distributions | Base | SI-7, SA-11 |
| **INV-RC-0015-f** | **Hybrid and audit liveness** — dwell-time Zeno prevention and typed trace grammar | `zeno_prevention_dwell`, `trace_grammar_complete`; Kani `REQ-HYB-01` (N=12), `REQ-AUD-01` | Safety-First | CA-2, SI-7 |
| **INV-RC-0015-g** | **TCB containment** — `m_inter_bounds_drift` and OSQP are named TCB entries with residual checks | `#print axioms` audit; named deferred axiom; OSQP residual wrapper + 2.5 ms watchdog | Deferred | SC-6, CP-2 |
| **INV-RC-0015-h** | **Release and report parity** — content-addressed release and synchronized dual reports | `TS-07`–`TS-09`; `production/build/<sha>/`; canonical SHA-256 report fingerprint | Base | CM-3, AU-10 |

Design class semantics follow the frozen baseline: `Safety-First` = proof/harness required; `Base` = Lean proofs plus property tests sufficient; `Deferred` = explicitly trusted, residual risk recorded and signed off.

---

## 5. Target Repository Layout (all paths relative to the canonical root)

```text
recursive-cognition/
├── README.md                          # subsystem identity, boundary rule, quickstart
├── Multiplicity-Recursive Cognition Engine.txt   # FROZEN v3.3 baseline (read-only)
├── lean-toolchain                     # baseline pin: leanprover/lean4:v4.32.1
├── lexlean.toml                       # canonical config; relative source roots
├── lexlean.lock                       # semantic lock, checked in TS-03
├── prismpm.toml                       # build_root = "production"
├── tools.lock                         # tool name → version → SHA-256 digest
├── language/                          # closed lexicons (titles + prism.arch/qual/sec)
│   ├── prism.arch
│   ├── prism.qual
│   ├── prism.sec
│   └── recursive.titles
├── src/                               # single-source .lex.tex formal artifacts
│   ├── Foundation/{Arch,Qual,Sec}.lex.tex
│   ├── RecursiveCognition/{DtCbf,Spectral,Hybrid,Trace,Parameters,Verification}.lex.tex
│   └── Main.lex.tex
├── runtime/                           # Rust runtime, each module behind a checked boundary
│   ├── cbf_filter/
│   ├── mode_machine/
│   └── audit_trace/
├── harnesses/kani/                    # REQ-SAF-01, REQ-OPT-01, REQ-HYB-01, REQ-AUD-01
├── run_tests.py                       # single authoritative 9-suite runner + report generator
├── run-tests.sh                       # thin wrapper
├── benchmark_rc_scaling.py            # TS-09 domain stress suite
├── reports/                           # TEST_REPORT_LATEST.md/.json, STRESS_BENCHMARK_LATEST.md/.json,
│                                      # plus immutable TEST_REPORT_<UTC>.md snapshots
├── docs/                              # this plan and its ADR
│   ├── PLAN-ADR-0015.md
│   └── ADR-0015.md
├── .githooks/pre-commit               # fail-closed local gate
├── install-hooks.sh
├── .github/workflows/verify-test.yml  # remote fail-closed gate; $GITHUB_STEP_SUMMARY
├── production/                        # PrismPM certified release root (build output only)
│   ├── .prismpm.lock
│   └── build/<sha>/{manifest.json,model.prism.json,lexlean/snapshot.json}
├── .lexlean/{verified,build,production}/   # attestation and certified export artifacts
├── CONFORMANCE.md                     # generated: lexicon/spec conformance register
└── VERIFICATION.md                    # generated: claim → evidence-grade register (E0–E6)
```

No directory or file in this tree may be replaced by a symlink escaping the root (§3). Directories that do not yet exist are created by the relevant phase, never by a different subsystem.

---

## 6. Requirements → ADR → Evidence Traceability

| Baseline source | Requirement | ADR enforcement | Enforcement site | Required evidence |
| :--- | :--- | :--- | :--- | :--- |
| Tooling | Single-source formal artifacts | ADR-001 | `src/**/*.lex.tex`, `lexlean.toml` | `lexlean verify` attestation; spike receipt |
| Tooling | Pinned Lean, no Mathlib in Tier-1 | ADR-002 | `lean-toolchain`, CI import check | `TS-01`–`TS-03` output; `tools.lock` digests |
| Governance | Decisions are linked objects | ADR-003, ADR-0015 | `docs/ADR-0015.md`, PrismPM links | Bidirectional link check in `TS-08` |
| Pillar 3 | Discrete CBF invariance | ADR-004 | `DtCbf.lex.tex` `dt_cbf_forward_invariant` | LexLean receipt; Kani `REQ-SAF-01` |
| Pillar 3 | `m_inter` as TCB hypothesis | ADR-005 | Named deferred axiom in `DtCbf.lex.tex` | `#print axioms`; signed `RISK-MINTER` |
| Pillar 3 | Passive check, no double count | ADR-006 | `runtime/cbf_filter::passive_check` | Kani harness on passive check |
| Pillar 3 | Slack horizon bound | ADR-007 | `thm slack_horizon_bound` | LexLean receipt; `RISK-SLACK` closed/accepted |
| Pillar 1 | Prime-boundary bin partition | ADR-008 | `prime_bin_partition` | LexLean receipt; boundary property test |
| Pillar 1 | Normalized JS distance | ADR-009 | JS definition in `Spectral.lex.tex` | Range property test, base-2/Dirichlet params |
| Pillar 2 | Zeno prevention | ADR-010 | `zeno_prevention_dwell` | LexLean receipt; Kani `REQ-HYB-01` (N=12) |
| Pillar 2 | Typed audit grammar | ADR-011 | `trace_grammar_complete` | LexLean receipt; Kani `REQ-AUD-01` |
| Pillar 3 boundary | OSQP isolation | ADR-012 | `runtime/cbf_filter` wrapper + watchdog | Residual check log; signed `RISK-OSQP` |
| Readiness | Baseline freeze | ADR-013 | TRR-1 record | Hash of frozen baseline file |
| Readiness | PR receipt requirement | ADR-014 | `.github/workflows/verify-test.yml` | Receipt hash in PrismPM task front-matter |
| **This plan** | **Localization + evidence discipline** | **ADR-0015** | **`TS-01`, report generator, CI gate** | **Boundary audit + grading in `VERIFICATION.md`** |

`VERIFICATION.md` assigns an evidence grade to every public claim: **E0** asserted, **E1** reviewed, **E2** reproducible locally, **E3** CI-verified, **E4** CI-verified/formally checked, **E5** Lean/Kani mathematically verified, **E6** independently audited. A claim labeled `verified` requires E5 or better; anything less is labeled `planned`, `some-true`, or `open`.

---

## 7. Test and Evidence Strategy

### 7.1 Authoritative runner

`run_tests.py` is the only entry point. It accepts `--root "$RC_ROOT"`, refuses non-canonical roots, executes suites TS-01…TS-09 in order, writes dual reports, and exits non-zero on the first blocking failure. `run-tests.sh` is a thin wrapper with no independent logic. A failure must not update `LATEST` artifacts.

### 7.2 Suite catalog

| Suite | Name | Blocking predicate |
| :--- | :--- | :--- |
| **TS-01** | Toolchain, tool digests, and canonical-root boundary audit | Wrong pin, digest mismatch, escaping path/link, or absolute config path |
| **TS-02** | Lean host build and hygiene | `lake build` failure; `sorry`/`admit`/`axiom` outside the named deferred axiom |
| **TS-03** | LexLean lock parity and canonical config | `lexlean lock --check` drift; non-relative source roots |
| **TS-04** | Semantic IR type check | `lexlean check` failure on any `src/**/*.lex.tex` |
| **TS-05** | Lean kernel verification and attestation | `lexlean verify` failure or missing content-addressed receipt |
| **TS-06** | Invariant theorem and axiom audit | Missing named theorem; unexpected axiom; `Mathlib` import in Tier-1 |
| **TS-07** | Attestation artifact audit | Missing/inconsistent `.lexlean/verified` receipt; receipt hash mismatch in report |
| **TS-08** | PrismPM model check and release | `prismpm check`/`prismpm build` failure; release outside `production/build/<sha>/`; broken ADR links |
| **TS-09** | Domain stress, property, and Kani rollup | Any failing sub-suite below |

### 7.3 TS-09 domain sub-suites

- **SUITE-RC-1 (INV-RC-0015-d):** discrete CBF invariance over bounded state grids; `γ ∈ (0,1]` boundary values; passive-check no-double-count cases; Kani `REQ-SAF-01`, `REQ-OPT-01`.
- **SUITE-RC-2 (INV-RC-0015-e):** 11 prime-boundary bins covering 1–30 Hz with no overlap; rejection of center-frequency prime schemes; normalized JS distance in `[0,1]` with base-2 logs and `α_i = 1/K`.
- **SUITE-RC-3 (INV-RC-0015-f):** dwell-time / `μ_{j,i} > 1` transition checks; Kani `REQ-HYB-01` with unwind bound **N = 12**; typed trace grammar acceptance/rejection cases; Kani `REQ-AUD-01`.
- **SUITE-RC-4 (INV-RC-0015-g):** OSQP residual checker positive/negative oracles; 2.5 ms watchdog budget; TCB hypothesis acknowledgment check (`m_inter_bounds_drift` must be named, never silently discharged).
- **SUITE-RC-5 (INV-RC-0015-h):** release manifest ↔ report fingerprint parity; dual-report freshness; no pasted-output acceptance.

### 7.4 Formal-artifact rules

- One `.lex.tex` source generates both the canonical document and the prose-free Lean module; no hand-maintained parallel Lean file for the same theorem.
- Tier-1 modules are `Mathlib`-free; exact rational/integer encodings (`Rat`, scaled integers) are preferred over `f32`/`f64`, per the zero-float policy of the wider governance baseline.
- The deferred `m_inter_bounds_drift` axiom is declared once, annotated, and linked to `RISK-MINTER`. `#print axioms` output is captured, not pasted.

### 7.5 Report contract

Every run produces both a canonical living reference and an immutable snapshot:

```text
reports/TEST_REPORT_LATEST.md          reports/test_report_latest.json
reports/STRESS_BENCHMARK_LATEST.md     reports/stress_benchmark_latest.json
reports/TEST_REPORT_<UTC_TIMESTAMP>.md  # immutable audit artifact
```

Each report records: root path, tool versions and digests, per-suite pass/fail, attestation hashes, harness ids, evidence grade per claim, and a canonical SHA-256 fingerprint computed over stable fields only (excluding timestamps and durations). The fingerprint is what CI compares to detect real documentation drift.

### 7.6 Reproducibility and supply chain

- `lean-toolchain` holds the exact baseline pin. `lexlean.toml` and `prismpm.toml` use relative paths only. `lexlean.lock` and `.prismpm.lock` are checked in.
- `tools.lock` records name → version → SHA-256 for `lexlean`, `prismpm`, `cargo kani`, and the pinned Lean toolchain image reference. Observed versions (`0.4.3`, `0.5.0`, `0.68.0`) are inputs to the manifest, not implicit defaults.
- If the spike shows the baseline Lean pin is unavailable, ADR-002 must be explicitly superseded before any pin change; silent drift is a `TS-01` failure.

---

## 8. Local Developer Workflow

```bash
cd /run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/recursive-cognition
./install-hooks.sh                 # installs .githooks/pre-commit locally
./run-tests.sh --quick             # boundary + toolchain + lock + check
./run-tests.sh                     # full 9-suite harness, writes reports/
lexlean verify                     # explicit attestation refresh when formal source changes
prismpm check && prismpm build     # release into production/build/<sha>/
git add reports/ && git commit     # hook re-runs harness; commit aborts on any failure
```

The hook auto-stages fresh `reports/` output and blocks the commit on any non-zero suite. Developers never hand-edit `TEST_REPORT_LATEST.md` or `VERIFICATION.md`; both are generated.

---

## 9. CI/CD and Fail-Closed Gates

1. **Pre-commit:** boundary audit + full runner + auto-stage reports. Any failure aborts the commit.
2. **Pull request:** GitHub Actions executes the identical runner in a clean checkout with the canonical root. TS-01 re-verifies the path; no evidence from the developer machine is trusted.
3. **Protected main:** merge requires all nine suites green, a fresh LexLean receipt, Kani outputs for `REQ-SAF-01`, `REQ-OPT-01`, `REQ-HYB-01`, `REQ-AUD-01`, and the receipt hash recorded in the PrismPM task front-matter (ADR-014).
4. **Evidence rule:** pasted compiler output, screenshots, or claims without a receipt id are rejected by the report generator, not merely reviewed away.
5. **Release gate:** `prismpm build` publishes only to `production/build/<sha>/` under the canonical root. Release artifacts outside that tree are a hard failure.
6. **Phase gates:** TRR-1 cannot pass while any `RISK-*` is open; TRR-2 requires every Safety-First ADR to have a passing receipt and every Deferred ADR to have signed residual-risk acceptance.

CI writes a short summary to `$GITHUB_STEP_SUMMARY` and retains the dual reports as build artifacts.

---

## 10. Phased Implementation Roadmap

| Phase | Name | Work | Exit gate |
| :--- | :--- | :--- | :--- |
| **0** | Governance (this change) | Create this plan and `docs/ADR-0015.md`; leave baseline, source, and config untouched. | Plan and ADR exist, are linked, and every invariant has a named enforcement site. → **PDR** |
| **1** | Conformance spike (2–3 w) — **complete** | Created minimal tree, pins, lexicons, `tools.lock`; encoded the three required artifacts plus a governance module; ran `lexlean verify`. | **Met:** all three required artifacts verify, attestation reproduced on repeat and clean rebuild, evidence bound in PrismPM. → **CDR** |
| **2** | Formal core (4–6 w) | Move DT-CBF, spectral, hybrid-stability, and trace modules into LexLean; declare the single deferred axiom. | TS-04…TS-07 green; axiom audit clean; open obligations #1–#5 scheduled. |
| **3** | Runtime and harnesses (3–4 w) | Rust runtime modules, OSQP residual wrapper + watchdog, four Kani harnesses. | All Kani harnesses pass with recorded real output; no pasted claims. |
| **4** | Runner, reporting, and gates (2–3 w) | `run_tests.py`, stress suites, dual reports, pre-commit hook, CI workflow. | 9/9 suites green locally and in a clean CI checkout; reports fingerprinted. |
| **5** | Release and evidence assembly (2 w) | PrismPM release into `production/build/<sha>/`, `CONFORMANCE.md`, `VERIFICATION.md`, risk sign-offs. | TRR-2 bundle complete: attestations + harness output + signed risk acceptances. |

No phase may borrow artifacts, paths, or evidence from a later phase or from another subsystem.

---

## 11. RAID Log (carried forward + plan-local additions)

| Risk ID | Description | Linked ADR | Mitigation | Owner | Gate |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `RISK-LEXLEAN-IMMATURITY` | LexLean v0.4 does not claim full 1.0 conformance | ADR-001 | Conformance spike; rollback to hand-maintained Lean | Formal Core lead | CDR |
| `RISK-MINTER` | `m_inter_bounds_drift` is assumed, not proven | ADR-005 | Named TCB hypothesis; blocks TRR-2 until proven/accepted | Control theory lead | TRR-2 |
| `RISK-SLACK` | Slack horizon bound not yet proven (obligation #2) | ADR-007 | Schedule before TRR-2; theorem `slack_horizon_bound` | Control theory lead | TRR-2 |
| `RISK-OSQP` | OSQP is unverified and timing-sensitive | ADR-012 | Residual-checking wrapper + 2.5 ms watchdog; signed acceptance | Runtime lead | TRR-2 |
| `RISK-TOOLCHAIN-DRIFT` | Lean/LexLean version drift across machines | ADR-002 | Pinned `lean-toolchain`, `tools.lock`, TS-01/03 | Formal Core lead | Every commit |
| `RISK-EVIDENCE-FABRICATION` | Unbacked "verified" claims | ADR-014, ADR-0015 | Receipt-linked CI gate; E0–E6 grading; no pasted output | Verification governance lead | Every commit |
| `RISK-PATH-ESCAPE` | Production artifacts written outside canonical root | ADR-0015 | §3 contract; TS-01 audit; CI replay | Runtime lead | Every commit |
| `RISK-SCOPE-CREEP` | Governance phase expands into implementation | ADR-0015 | Phase 0 limited to two documents; baseline file read-only | Plan owner | PDR |

---

## 12. Acceptance Criteria and Definition of Done

Phase 0 (this change):

1. [x] This plan exists inside the canonical root.
2. [x] Its ADR exists inside the canonical root and is linked both ways.
3. [x] Every invariant in §4 names an enforcement site and NIST control.
4. [x] All baseline ADRs are traced in §6; the five open obligations are retained in §11.
5. [x] No file outside the canonical root was created or modified.
6. [x] No implementation, attestation, or verification claim is made.

Subsequent phases (Phase 1 now satisfied; Phases 2–5 not started):

7. [x] All `.lex.tex` modules pass `lexlean check` and `lexlean verify` with reproducible receipts — 119 checked modules and 64 verified modules under the ADR-0017 model tree. Historical ADR-001 attestation `7998182e99ca10aa0a3cff41b2ebb90c846bf0f7fb8fe6a0b2f93efeea4aa8ca` (ADR-0015 §11); historical ADR-0016 attestation `e2ea04e5e9c899c49fb341ecf555e205208d2e32489e0bf86e2fb57851069bb7` under Lean v4.32.2; current ADR-0017 attestation `7d2e6b4a9ceb7432a226d852f405a88ac07735a31897bee65f51d67ac721c8c5` (ADR-0017 §6).
8. [ ] All four Kani harnesses pass with captured real output and stated unwind bounds.
9. [ ] 9/9 suites pass locally and in clean CI; dual reports are fresh and fingerprinted.
10. [ ] PrismPM publishes an immutable release under `production/build/<sha>/`.
11. [ ] Every Safety-First ADR has a passing receipt; every Deferred ADR has signed risk acceptance.
12. [ ] TRR-2 evidence bundle is complete and contains no unsupported `verified` label.

---

## 13. Rollback and Recovery

- **Phase 0 rollback:** delete the two new governance documents; the frozen baseline and all other files are unchanged.
- **Spike failure (ADR-001):** reject ADR-001, record the failure receipt, and author a superseding ADR for the hand-maintained Lean + CI-pinned fallback. No formal module is promoted.
- **Toolchain drift:** restore `lean-toolchain`/`lexlean.lock`/`tools.lock` from the last green receipt and re-run TS-01…TS-03.
- **Boundary violation:** stop the pipeline, remove the out-of-root artifact only after recording its path and hash in the incident entry, re-run TS-01, and re-build the release from the canonical root.
- **Bad release:** do not mutate `production/build/<sha>/`; publish a new content-addressed release and supersede the manifest reference.

Rollback never deletes evidence. Evidence is appended to `reports/` with a new timestamped snapshot.

---

## 14. Governance Notes

- Local ADR sequence: baseline ADR-001…ADR-014, then ADR-0015. If a global Prism index is later arbitrated, the mapping is recorded in ADR-0015 §5 — not guessed here.
- This plan is the enforcement reference for ADR-0015. A change to an invariant, enforcement site, or release boundary requires a new or superseding ADR, not an edit to this plan alone.
- Industry references applied: ISO/IEC/IEEE 42010 (architecture decisions), NIST SP 800-53 Rev. 5 (control mapping), NIST SP 800-218 SSDF and SLSA v1.0 (provenance and hermetic, content-addressed builds), Y-statement ADR method with named enforcement sites and design classes, and the repository's E0–E6 evidence grading policy.

---

## 15. Phase 1 Evidence Index

| Evidence | Location |
| :--- | :--- |
| Required spike sources | `src/Spike/RatOrder.lex.tex`, `src/Spike/DtCbf.lex.tex`, `src/Spike/SpectralBins.lex.tex` |
| Governance/facet module | `src/Governance.lex.tex` |
| LexLean config, lock, pin | `lexlean.toml`, `lexlean.lock`, `lean-toolchain` |
| Pinned tool digests and incompatibility | `tools.lock` |
| Reproducible verify stdout | `evidence/lexlean-verify-1.stdout`, `evidence/lexlean-verify-2-clean.stdout` |
| PrismPM 0.4.0 governance check | `evidence/prismpm-040-check.stdout` |
| PrismPM 0.5.0 incompatibility | `evidence/prismpm-050-check.stderr` |
| PrismPM-linked evidence register | `production/evidence/ADR-001-lexlean-spike.json` |
| Full decision record | ADR-0015 §11 |

No artifact in this index resolves outside `RC_ROOT`. Full `prismpm verify` was historically Phase 3–5 work and is now closed for the governed path by ADR-0017; the nine-suite runner, Kani harnesses, and release publication remain Phase 2–5 work and are not claimed here.

---

## 16. Toolchain Supersession Evidence Index (ADR-0016)

| Evidence | Location |
| :--- | :--- |
| Superseding decision | `docs/ADR-0016.md` |
| Current pin and verifier identity | `lean-toolchain`, `lexlean.toml`, `tools.lock`, `lexlean.lock` |
| LexLean version / lock / check / format receipts | `evidence/lexlean-043-version.stdout`, `evidence/lexlean-043-lock.stdout`, `evidence/lexlean-043-check.stdout`, `evidence/lexlean-043-fmt.stdout` |
| Reproducible current attestation | `evidence/lexlean-043-verify-1.stdout`, `evidence/lexlean-043-verify-2-clean.stdout`, `.lexlean/verified/e2ea04e5e9c899c49fb341ecf555e205208d2e32489e0bf86e2fb57851069bb7/` |
| PrismPM governance check | `evidence/prismpm-050-check-043.stdout` |
| Remaining model-content blocker | `evidence/prismpm-050-verify-043.stderr` |
| Rejected 0.4.5 adoption study | `evidence/adoption-study/` |
| Governed migration record | `production/evidence/ADR-0016-toolchain-migration.json` |

The ADR-001 spike attestation and its raw outputs remain retained under `evidence/` and `production/evidence/ADR-001-lexlean-spike.json`; they are historical, not current. ADR-0016's attestation is also historical after the `lexlean clean` replay under ADR-0017; acceptance criterion 7 is currently satisfied by the ADR-0017 attestation in §17. No artifact in this index resolves outside `RC_ROOT`.

---

## 17. Governed PrismPM Verification Evidence Index (ADR-0017)

| Evidence | Location |
| :--- | :--- |
| Superseding decision | `docs/ADR-0017.md` |
| Canonical stack and execution environment | `lexlean.toml`, `lexlean.lock`, `prismpm.toml`, `tools.lock` |
| Adopted Prism model content | `stdlib/src/`, `stdlib/LICENSE-MIT`, `stdlib/LICENSE-APACHE` |
| Pinned exporter archive | `vendor/lean4-prod/lean.tar` |
| LexLean version / lock / check / format receipts | `evidence/adr-0017-lexlean-version.stdout`, `evidence/adr-0017-lexlean-lock.stdout`, `evidence/adr-0017-lexlean-lock-check.stdout`, `evidence/adr-0017-lexlean-check.stdout`, `evidence/adr-0017-lexlean-fmt-check.stdout` |
| Reproducible current LexLean attestation | `evidence/adr-0017-lexlean-verify-1.stdout`, `evidence/adr-0017-lexlean-verify-2-clean.stdout`, `.lexlean/verified/7d2e6b4a9ceb7432a226d852f405a88ac07735a31897bee65f51d67ac721c8c5/` |
| PrismPM governance check | `evidence/adr-0017-prismpm-check-json.stdout` |
| Real PrismPM verify pass | `evidence/adr-0017-prismpm-verify-json.stdout`, `production/verified/7963a1eb1ee4462fd5c87a7c1b2bc430dbbb2f8d0774b5dc606e43a0b2a66c71/` |
| Generated build inputs | `production/build/f64f58390af6136a9ff6b1b835422459e580ebd6728e84f0654b752b7e8dd43a/manifest.json` |
| Historical model-content blocker | `evidence/prismpm-050-verify-043-rust1971.stderr` |
| Scratch adoption and canonicalization inputs | `evidence/adoption-study/` |
| Governed verification record | `production/evidence/ADR-0017-prismpm-verification.json` |
| Upstream provenance record | `production/evidence/ADR-0017-upstream-provenance.json` |

ADR-0017 supersedes only ADR-0016 D7 and ADR-0015 D4's blocked-verify clause. It does not establish release, Kani, nine-suite, pre-commit/CI, or TRR-2 readiness. No artifact in this index resolves outside `RC_ROOT`.
