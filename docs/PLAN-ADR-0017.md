# Implementation Plan: Production-Grade Test Harness, Empirical Invariant Benchmarking, Automated Living Reporting, and CI/CD Pipeline for the Recursive Cognition Engine

**Target Subsystem:** `/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/recursive-cognition`  
**Canonical Root:** `/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/recursive-cognition`  
**Governing ADR:** [ADR-0017](ADR-0017.md) (Local register, succeeding ADR-0015 and ADR-0016); Global ADR: [ADR-0031](file:///home/multiplic/adr/03_accepted/ADR-0031-recursive-cognition-production-test-harness-benchmarking-ci.md)  
**Parent Framework:** Multiplicity Theory & QARI Cognitive Architecture  
**Reference Parity Target:** [`kuramoto-prism`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/kuramoto-prism) (ADR-0024, ADR-0025, ADR-0026)  
**Toolchain Contract:** `leanprover/lean4:v4.32.2` (security-patched) | `lexlean 0.4.3` (Language 1.0) | `prismpm 0.5.0` | `Python 3.11+` + `NumPy`  
**Kernel Attestation:** `5c1603cd8b11643e6c73f43bf473100f114a0089382c76bd8fc0d77b4b5d497e`  
**Date:** 2026-11-23  
**Status:** In Progress — Test Harness, Benchmarking Engine, and CI/CD Alignment Execution  

---

## 1. Executive Summary & Problem Context

The Grounded Multiplicity Recursive Cognition Engine formalizes core discrete-continuous cognitive safety protocols:
1. **Pillar 1: Spectral Telemetry**: Partition of the 1–30 Hz cognitive frequency spectrum into 11 disjoint prime-boundary bins, evaluated with Normalized Jensen-Shannon divergence ($D_{\text{JS}}^{\text{norm}} \in [0, 1]$) under Dirichlet smoothing.
2. **Pillar 2: Hybrid Stability & Meta-Cognitive Audit**: Dwell-time non-Zeno bounds ($\Delta t \ge \tau_{\min} > 0$) and Lyapunov contraction across recursive cognitive transitions.
3. **Pillar 3: Discrete-Time Control Barrier Functions (DT-CBF)**: Forward invariant safe-set containment ($h(x_{k+1}) \ge (1-\gamma)h(x_k) + m_{\text{inter}}$) with passive $M_0$ intervention and exact integer cross-multiplication rational ordering.

Prior local governance (ADR-0015 and ADR-0016) established localization rules and completed toolchain migration to LexLean 0.4.3 and Lean 4.32.2. However, the subsystem lacked the **production-grade test harness, empirical scaling benchmarks, automated living documentation, and CI/CD integration** demonstrated in the reference implementation [`kuramoto-prism`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/kuramoto-prism).

This plan operationalizes industry best practices (NIST SP 800-53 controls, shift-left continuous assurance, zero-drift living documentation) to establish complete reference parity with `kuramoto-prism`.

---

## 2. Test Harness Architecture (`run_tests.py`)

A single, deterministic, authoritative Python test runner (`run_tests.py`) orchestrates 9 test suites:

| Suite ID | Suite Name | Target / Command | Pass Criteria |
| :--- | :--- | :--- | :--- |
| **TS-01** | Toolchain Pin & Localization Boundary Audit | `lean`, `lake`, `lexlean`, `prismpm`, `RC_ROOT` boundary | Pinned `v4.32.2`, `0.4.3`, zero path escapes outside `RC_ROOT` |
| **TS-02** | Lean Lake Host Workspace & Hygiene | `lake build` | Exit code 0, workspace builds cleanly |
| **TS-03** | LexLean Lock Parity & Canonical Configuration | `lexlean lock --check` | `lexlean.lock` current, schemas `project/1` and `lock/2` verified |
| **TS-04** | Semantic IR AST & Module Type Check | `lexlean check --all` | 4 modules checked, Source ID and Semantic ID matched |
| **TS-05** | Lean 4 Kernel Formal Verification & Attestation | `lexlean verify` | Lean 4 elaboration, `leanchecker`, and axiom audit complete; attestation hash recorded |
| **TS-06** | Formal Invariants & Certified Theorems Audit | `src/Spike/*.lex.tex`, `src/Governance.lex.tex` | 20 declarations ok, 3 core theorems certified, 0 sorries, 0 dynamic axioms |
| **TS-07** | Build & Attestation Storage Integrity Audit | `.lexlean/verified`, `attestation.json`, oleans | Attestation directory intact, manifest length and SHA-256 verified |
| **TS-08** | PrismPM Model Governance & Static Check | `prismpm check` | Semantic ID parity between PrismPM model and LexLean IR |
| **TS-09** | Empirical Invariant Stress-Testing & Scaling Benchmarks | `benchmark_recursive_cognition.py` | All 5 empirical stress and scaling sub-suites pass |

---

## 3. Empirical Stress-Testing & Benchmarking Suite (`benchmark_recursive_cognition.py`)

Modeled after `kuramoto-prism`'s `benchmark_kuramoto_scaling.py`, the empirical suite evaluates the physical and numerical invariants underlying the formal theorems:

### Sub-Suite S1: Prime-Boundary Spectral Binning & Jensen-Shannon Divergence Scaling (`INV-RC-031a`)
- **Mathematical Invariant**: 11 prime-boundary frequency bins:
  $$B_1=[1,2), B_2=[2,3), B_3=[3,5), B_4=[5,7), B_5=[7,11), B_6=[11,13), B_7=[13,17), B_8=[17,19), B_9=[19,23), B_{10}=[23,29), B_{11}=[29,31)$$
  Exhaustive disjoint coverage of $[1, 31)$ Hz with prime boundary set $\{2, 3, 5, 7, 11, 13, 17, 19, 23, 29\}$.
- **Empirical Stress**: Monte Carlo frequency distributions ($N=10^1$ to $10^6$ synthetic telemetry points) evaluating bin classification, Dirichlet smoothing ($\alpha_i = 1/K$), and Normalized Jensen-Shannon divergence:
  $$D_{\text{JS}}^{\text{norm}}(P \parallel Q) = \sqrt{\frac{D_{\text{KL}}(P \parallel M) + D_{\text{KL}}(Q \parallel M)}{2 \ln 2}} \in [0, 1]$$
- **Pass Criteria**: Divergence symmetry $|D_{\text{JS}}(P \parallel Q) - D_{\text{JS}}(Q \parallel P)| < 10^{-12}$, self-identity $D_{\text{JS}}(P \parallel P) = 0.0$, and valid $[0, 1]$ boundedness across all distributions.

### Sub-Suite S2: Discrete-Time Control Barrier Function (DT-CBF) Forward Invariance & Disturbance Stress (`INV-RC-031b`)
- **Mathematical Invariant**: Discrete-time barrier condition with decay parameter $\gamma \in (0, 1]$:
  $$h(x_{k+1}) \ge (1 - \gamma) h(x_k) + m_{\text{inter}}$$
  Integer scaled representation: $(h_{k+1} \cdot \gamma_{\text{den}}) \ge (\gamma_{\text{den}} - \gamma_{\text{num}}) h_k + \gamma_{\text{den}} m_{\text{inter}}$.
- **Empirical Stress**: 10,000 multi-step trajectory rollouts with initial safety margins $h_0 \in [10, 1000]$, boundary proximity stress ($h_k \to 0^+$), and worst-case inter-sampling disturbance drift $m_{\text{inter}} \in [0, 50]$.
- **Pass Criteria**: $100\%$ forward invariance preservation ($h_k \ge 0$ for all $k$), zero barrier violations, and strict verification that passive $M_0$ filtering prevents unverified control excursions.

### Sub-Suite S3: Zero-Float Exact Rational Ordering & Scaling Invariance (`INV-RC-031c`)
- **Mathematical Invariant**: Cross-multiplication ordering for $a/b, c/d$ ($b, d > 0$):
  $$a/b < c/d \iff a \cdot d < b \cdot c$$
- **Empirical Stress**: 100,000 randomized rational pairs across high dynamic range ($1 \dots 10^9$).
- **Pass Criteria**: Monotonic transitivity ($p < q \land q < r \implies p < r$), strict anti-symmetry, irreflexivity, and scaling invariance under arbitrary $\lambda \in [1, 1000]$ ($(\lambda a)/(\lambda b) \equiv a/b$).

### Sub-Suite S4: Hybrid Stability, Mode Switching & Dwell-Time Zeno Prevention (`INV-RC-031d`)
- **Mathematical Invariant**: Minimum dwell time $\tau_{\min} > 0$ across discrete meta-cognitive state transitions and discrete Lyapunov contraction ($\mu_{j, i} \ge 1, \rho < 1$).
- **Empirical Stress**: 1,000 rapid event triggers testing transition safety and chattering suppression.
- **Pass Criteria**: Zero Zeno transitions ($\Delta t \ge \tau_{\min}$ universally enforced), bounded energy dissipation, and contractive return to stable operating regimes.

### Sub-Suite S5: Microsecond Throughput & Execution Latency Benchmarking (`INV-RC-031e`)
- **Target**: Measure throughput (evaluations/sec) and latency distributions ($p_{50}, p_{95}, p_{99}$, max) for:
  1. Spectral binning and Dirichlet JS divergence computation.
  2. DT-CBF forward invariance checking and safety gating.
  3. Exact rational comparison.
- **Pass Criteria**: Execution latency $p_{99} < 100\,\mu\text{s}$, well within the 2.5 ms real-time safety watchdog budget.

---

## 4. Automated Living Documentation Engine

The test harness enforces dual-retention reporting:
1. **Living Canonical Documents**:
   - `reports/TEST_REPORT_LATEST.md`
   - `reports/test_report_latest.json`
   - `reports/STRESS_BENCHMARK_LATEST.md`
   - `reports/stress_benchmark_latest.json`
2. **Immutable Timestamped Audit Artifacts**:
   - `reports/TEST_REPORT_<YYYYMMDDTHHMMSS>.md`
   - `reports/test_report_<YYYYMMDDTHHMMSS>.json`
   - `reports/STRESS_BENCHMARK_<YYYYMMDDTHHMMSS>.md`
   - `reports/stress_benchmark_<YYYYMMDDTHHMMSS>.json`

Reports incorporate GitHub Flavored Markdown alerts, summary scorecards, test suite matrices, certified theorem tables, and performance benchmark breakdowns.

---

## 5. Continuous Integration & Pre-Commit Automation

1. **Local Pre-Commit Hook (`.githooks/pre-commit`)**:
   - Automatically triggered on every `git commit`.
   - Executes `python3 run_tests.py`.
   - Halts the commit upon any failure (fail-closed).
   - Upon success, automatically stages updated reports (`reports/*_LATEST.*`) into the commit, eliminating documentation drift.
2. **Hook Installer (`install-hooks.sh`)**:
   - Configures `git config core.hooksPath .githooks`.
3. **CI/CD Pipeline (`.github/workflows/verify-test.yml`)**:
   - Triggers on push and pull request to `main`/`master`.
   - Runs full test suite on clean runner.
   - Uploads `reports/` as workflow artifacts.
   - Appends Markdown report summaries directly to `$GITHUB_STEP_SUMMARY`.
