# Grounded Multiplicity Recursive Cognition Engine

[![Lean 4](https://img.shields.io/badge/Lean_4-v4.32.2-blue.svg)](https://leanprover.github.io/)
[![LexLean](https://img.shields.io/badge/LexLean-0.4.3-green.svg)](https://github.com/)
[![PrismPM](https://img.shields.io/badge/PrismPM-v0.5.0-orange.svg)](https://github.com/)
[![Verification](https://img.shields.io/badge/Verification-100%25_Passing_(9%2F9)-brightgreen.svg)]()
[![Attestation](https://img.shields.io/badge/Attestation-5c1603cd...-purple.svg)]()
[![CI/CD](https://img.shields.io/badge/CI%2FCD-Pre--Commit%20%2B%20GHA-success.svg)]()

Production-grade formal verification, empirical invariant stress-testing, automated living reporting, and continuous integration pipeline for the **Grounded Multiplicity Recursive Cognition Engine**. Authored in **LexLean** with complete **Lean 4 kernel** verification, certified discrete invariants, and automated pre-commit quality enforcement.

- **Canonical Subsystem Root**: [`/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/recursive-cognition`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/recursive-cognition)
- **Governing Architecture Records**:
  - [ADR-0015: Localized, Evidence-Gated Production Architecture](docs/ADR-0015.md)
  - [ADR-0016: Supersede Lean Pin with LexLean 0.4.3 and Lean v4.32.2](docs/ADR-0016.md)
  - [ADR-0017: Recursive Cognition Production Test Harness & Invariant Benchmarks](docs/ADR-0017.md) (Local register)
  - [ADR-0031: Mount-Wide Register: Recursive Cognition Test Harness, Benchmarking & CI/CD Gate](file:///home/multiplic/adr/03_accepted/ADR-0031-recursive-cognition-production-test-harness-benchmarking-ci.md)
- **Reference Standard Parity**: [`kuramoto-prism`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/kuramoto-prism) (ADR-0024, ADR-0025, ADR-0026)
- **Lean Toolchain Pin**: `leanprover/lean4:v4.32.2` (Security Patched)
- **Lean Kernel Attestation Hash**: `5c1603cd8b11643e6c73f43bf473100f114a0089382c76bd8fc0d77b4b5d497e`

---

## 1. Executive Summary

The **Grounded Multiplicity Recursive Cognition Engine** formalizes safe recursive reasoning and telemetry:

1. **100% Kernel Verification**: 4 modules verified through the Lean 4 kernel with **0 errors, 0 sorries, and 0 dynamic tactic axioms**.
2. **Certified Formal Theorems**:
   - `dt_cbf_forward_invariant`: Discrete-Time Control Barrier Function safe-set forward invariance ($h(x_{k+1}) \ge (1-\gamma)h(x_k) + m_{\text{inter}}$).
   - `rat_order_helper`: Exact integer cross-multiplication rational ordering ($1/3 < 1/2 \iff 1 \cdot 2 < 1 \cdot 3$).
   - `prime_bin_partition`: Exhaustive prime-boundary disjoint partition of $[1, 31)\,\text{Hz}$ into 11 bins.
3. **Empirical Invariant Stress Testing (ADR-0017 / ADR-0031)**:
   - **Spectral Partitioning & JS Divergence (`INV-RC-031a`)**: Machine-zero symmetry divergence ($< 10^{-12}$) and $D_{\text{JS}}^{\text{norm}} \in [0, 1]$ across $N = 10^1 \dots 10^6$ Monte Carlo samples.
   - **DT-CBF Forward Invariance (`INV-RC-031b`)**: 100% safe-set retention across 10,000 multi-step trajectories under near-boundary stress and disturbance drift ($m_{\text{inter}} \le 20$).
   - **Exact Rational Ordering (`INV-RC-031c`)**: 100,000 randomized pairs verified with zero transitivity errors and scaling invariance.
   - **Hybrid Stability & Dwell Time (`INV-RC-031d`)**: Strict Zeno chattering suppression ($\Delta t \ge \tau_{\min}$) and monotonic Lyapunov energy contraction.
   - **Microsecond Execution Latency (`INV-RC-031e`)**: Safety evaluation $p_{99} < 25\,\mu\text{s}$, well within the 2.5 ms watchdog budget.
4. **Living Documentation Engine**: Automatically generates dual-format Markdown and JSON reports (`reports/TEST_REPORT_LATEST.md` and `reports/STRESS_BENCHMARK_LATEST.md`).
5. **Continuous Pre-Commit & CI Enforcement**: Local `.githooks/pre-commit` runs the 9-suite verification runner, auto-stages fresh reports into git, and prevents proof debt or documentation drift.

---

## 2. Test Suites Matrix

| Suite ID | Test Name | Target / Command | Result | Pass Criteria |
| :--- | :--- | :--- | :---: | :--- |
| **TS-01** | Toolchain Pin & Localization Boundary Audit | `lean`, `lake`, `lexlean`, `prismpm` | ✅ PASS | Pinned `v4.32.2`, `0.4.3`, strict `RC_ROOT` containment |
| **TS-02** | Lean Lake Host Workspace Build & Hygiene | `lake build` | ✅ PASS | Clean host build, exit code 0 |
| **TS-03** | LexLean Lock Parity & Canonical Configuration | `lexlean lock --check` | ✅ PASS | Current lockfile, schema `project/1` & `lock/2` |
| **TS-04** | Semantic IR AST & Module Type Check | `lexlean check --all` | ✅ PASS | 4 modules checked, Source & Semantic ID parity |
| **TS-05** | Lean 4 Kernel Formal Verification & Attestation | `lexlean verify` | ✅ PASS | Kernel verification, `leanchecker`, attestation recorded |
| **TS-06** | Formal Invariants & Certified Theorems Audit | `src/Spike/*.lex.tex` | ✅ PASS | All theorems certified, 0 sorries, 0 axioms |
| **TS-07** | Build & Attestation Storage Integrity Audit | `.lexlean/verified` | ✅ PASS | Storage intact, oleans and manifests valid |
| **TS-08** | PrismPM Model Governance & Static Check | `prismpm check` | ✅ PASS | Semantic parity between model and LexLean IR |
| **TS-09** | Empirical Invariant Stress-Testing & Benchmarks | `benchmark_recursive_cognition.py` | ✅ PASS | All 5 empirical stress and scaling suites pass |

---

## 3. Quick Start & Execution

### Run Full Test Harness & Generate Living Reports

```bash
# Execute 9-suite unified verification runner
./run-tests.sh
# Or directly:
python3 run_tests.py
```

### Run Empirical Invariant Stress-Testing & Scaling Benchmarks

```bash
python3 benchmark_recursive_cognition.py
```

### Install Local Git Pre-Commit Hooks

```bash
chmod +x install-hooks.sh
./install-hooks.sh
```

Once installed, every `git commit` automatically verifies all 9 suites, updates `reports/*_LATEST.*`, and stages them into the commit.
