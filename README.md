# NBA Predictive Model: Proof of Concept, Scalability, and Profitability

**Analyst:** Shawn Canty

**Date:** July 2026

🔗 **[View the Interactive Tableau Dashboard Here](https://public.tableau.com/app/profile/shawn.canty/viz/nba_predictive_model_analysis/Dashboard1)**

## 1. Business Problem & Context

I developed a prototype predictive model for 300+ NBA player props across points, rebounds, and assists. Before investing engineering resources to scale this model across all 30 teams in BigQuery (Phase 2), I conducted a retrograde Proof of Concept (PoC) during the NBA Playoffs. This analysis evaluates the PoC’s performance in a volatile environment to answer one question: Can this model generate stable profit in a controlled market, or does it need more work before scaling?

## 2. Core Hypothesis & Validation Criteria

To justify greenlighting Phase 2 (league-wide scaling), the prototype must pass two validation gates:

* **Gate 1: Profitability (The 55% Target).** The model must exceed the standard -110 odds break-even threshold (52.4%) and ideally reach a 55.0% win rate. I quantified the actual edge to confirm this is a profitable trajectory.
* **Gate 2: Predictive Stability.** Win rates can be skewed by variance. The model must show an acceptable Mean Absolute Error (MAE) and low directional bias to prove its predictions are mathematically sound and not based on small-sample luck.

## 3. Methodological Scope & Controls

* **The Sandbox:** A retrospective case study of two contrasting teams (New York Knicks & San Antonio Spurs) throughout their playoff journeys.
* **Prop Markets:** Limited to the three highest-volume player prop types: Points (PTS), Rebounds (REB), and Assists (AST).
* **Dataset:** First-party, row-level logs comparing the prototype’s projections against market consensus lines and actual game outcomes.
* **Expected Deliverable:** A data-backed recommendation on whether to deploy Phase 2 (league-wide scaling) or pause to add more metrics to the core algorithm.

---

## Executive Summary & Strategic Recommendations

**The Verdict:**
The predictive model in its current state did not meet the criteria to greenlight Phase 2 (league-wide scaling) for all player props. However, segmentation revealed a highly profitable sub-market, enabling a targeted, scaled deployment while the core algorithm is recalibrated.

### Evaluating the Validation Gates:

* **Gate 1: Profitability (Failed Globally, Passed Locally)**
  * *Global:* Across 397 active bets, the model had an overall win rate of 51.64%, below the -110 sportsbook break-even threshold (52.4%).
  * *Local (The Pivot):* Segmenting by prop type showed that the `rbs_line` (Rebounds) is highly profitable, with a 55.15% win rate surpassing the target. Conversely, Assists (47.73%) and Points (50.87%) were unprofitable.

* **Gate 2: Predictive Stability (Failed)**
  * *Directional Bias:* The model has a critical structural flaw, heavily over-indexing on “More” across all categories (64.0% to 75.1% bias). It fails to account for the inherent “Under” bias common in volatile playoff environments (e.g., blowouts, foul trouble, tightened rotations).
  * *Accuracy (MAE):* Points predictions showed high variance, missing by an average of 5.10 points (failing the ~4.50 industry benchmark). Assists stayed within a safe MAE threshold (1.67), but directional bias made it unprofitable. Rebounds offered insight: despite slightly missing the ~2.00 benchmark with a 2.10 MAE, it still drove the highest profitability. This 0.10 variance suggests the model’s rebounding edge can absorb minor errors without losing money.

### Actionable Recommendations (Next Steps):

1. **Partial Phase 2 Deployment (Rebounds Only):** Immediately scale the model to all 30 teams exclusively for the Rebounds (`rbs_line`) market. Its current design proves it can identify rebounding edges effectively despite the directional bias.
2. **Algorithm Recalibration (Points & Assists):** Pause scaling for Points and Assists. I recommend adding playoff-specific variables (e.g., pace adjustments, defensive rating matchups, and minute-reduction thresholds) to correct the ~75% “More” bias before a second PoC.

---

## Repository Structure

* **`nba_model_poc_queries.sql`**: Contains the full BigQuery SQL scripts used for data cleaning (ELT), Gate 1 Profitability aggregations, and Gate 2 Predictive Stability (MAE) calculations.
