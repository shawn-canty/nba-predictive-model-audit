# NBA Predictive Model: Proof of Concept, Scalability, and Profitability

**Analyst:** Shawn Canty

**Date:** July 2026

🔗 **[View the Tableau Dashboard Here](https://public.tableau.com/app/profile/shawn.canty/viz/nba_predictive_model_analysis/Dashboard1)**

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


## 4. Executive Summary & Strategic Recommendations

**The Verdict:** The predictive model in its current state did not meet the criteria for immediate Phase 2 (league-wide) deployment. While the aggregate model failed to beat the break-even threshold, segmentation revealed a promising sub-market in Rebounds with a 55.15% win rate. Due to a structural directional bias affecting the entire algorithm, a global pause and recalibration are required. This will be followed by an expanded 1,000-play backtest to validate the Rebounds edge before committing capital.

### Evaluating the Validation Gates:

**Gate 1: Profitability (Failed Globally, Promising Locally)**
* **Global:** Across 397 active bets, the model had an overall win rate of 51.64%, below the -110 sportsbook break-even threshold (52.4%).
* **Local (The Pivot):** Segmenting by prop type showed that the `rbs_line` (Rebounds) holds massive potential, with a 55.15% win rate surpassing the target. Conversely, Assists (47.73%) and Points (50.87%) were unprofitable.

**Gate 2: Predictive Stability (Failed)**
* **Directional Bias:** The model has a critical structural flaw, heavily over-indexing on “More” across all categories with a 64.0% to 75.1% bias. It fails to account for the inherent “Under” bias common in volatile playoff environments such as blowouts, foul trouble, and tightened rotations.
* **Accuracy (MAE):** Points predictions showed high variance, missing by an average of 5.10 points and failing the ~4.50 industry benchmark. Assists stayed within a safe MAE threshold of 1.67 but were unprofitable due to directional bias. Rebounds offered critical insight: despite slightly missing the ~2.00 benchmark with a 2.10 MAE, it still drove the highest profitability. This 0.10 variance suggests the model’s rebounding edge is resilient, but the underlying algorithmic bias must be addressed.

### Actionable Recommendations (Next Steps):
* **Global Pause & Recalibration:** Halt live deployment. The directional bias toward “More” fundamentally affects the core algorithm. We must integrate playoff-specific variables such as pace adjustments, defensive rating matchups, and minute-reduction thresholds to recalibrate all three categories before scaling.
* **Phase 1.5 Validation (Expanded Backtest):** Subject the recalibrated algorithm to a 1,000-play retrograde backtest. We must mathematically validate that the initial 55.15% edge in Rebounds is a structural advantage, not a byproduct of small-sample playoff variance.
* **Post-Validation Analysis:** Upon completion of the 1,000-play backtest, evaluate the updated MAE and win rates to extract further strategic insights. This analysis will dictate the final, data-driven deployment strategy for each individual category.

---

## Repository Structure
* **`nba_model_poc_queries.sql`**: Contains the full BigQuery SQL scripts used for data cleaning (ELT), Gate 1 Profitability aggregations, and Gate 2 Predictive Stability (MAE) calculations.
