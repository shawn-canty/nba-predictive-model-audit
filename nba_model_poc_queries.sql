-- ==============================================================================
-- PHASE 1: DATA CLEANING & VALIDATION (ELT)
-- ==============================================================================

-- 1. Duplicate Check: Ensure no player has multiple entries for the same prop type on the same date
SELECT 
    date,
    player_id,
    prop_type,
    COUNT(*) AS row_count
FROM 
    `nba-predictive-model.nba_model_poc.raw_projection_logs`
GROUP BY 
    date,
    player_id,
    prop_type
HAVING 
    COUNT(*) > 1;

-- 2. The Inconsistency Audit: Check for spelling/capitalization variations in categorical columns
SELECT 
    DISTINCT proj_tally 
FROM 
    `nba-predictive-model.nba_model_poc.raw_projection_logs`;

-- 3. The NULL (Missing Data) Check: Identify records missing actual outcomes or grades
SELECT 
    COUNT(*) AS total_missing_records
FROM 
    `nba-predictive-model.nba_model_poc.raw_projection_logs`
WHERE 
    actual_outcome IS NULL 
    OR proj_tally IS NULL;

-- 4. Create Cleaned Table: Remove NULLs and push to a clean production table
CREATE TABLE `nba-predictive-model.nba_model_poc.cleaned_projection_logs` AS
SELECT 
    * 
FROM 
    `nba-predictive-model.nba_model_poc.raw_projection_logs`
WHERE 
    actual_outcome IS NOT NULL 
    AND proj_tally IS NOT NULL;


-- ==============================================================================
-- PHASE 2: GATE 1 - PROFITABILITY ANALYSIS
-- ==============================================================================

-- 5. Global Win Rate: Testing against the -110 odds break-even threshold (52.4%)
SELECT
   COUNTIF(proj_tally = 'win') AS total_wins,
   COUNTIF(proj_tally = 'loss') AS total_losses,
   COUNTIF(proj_tally IN ('win','loss')) AS total_active_bets,
   ROUND(
       SAFE_DIVIDE(
           COUNTIF(proj_tally = 'win'),
           COUNTIF(proj_tally IN ('win', 'loss'))
       ) * 100, 2
   ) AS win_rate_percentage
FROM 
    `nba-predictive-model.nba_model_poc.cleaned_projection_logs`
WHERE
   proj_tally IN ('win', 'loss');

-- 6. Segmentation Analysis: Finding the bleed by breaking down win rate by prop type
SELECT
   prop_type,
   COUNTIF(proj_tally = 'win') AS total_wins,
   COUNTIF(proj_tally = 'loss') AS total_losses,
   COUNTIF(proj_tally IN ('win','loss')) AS total_active_bets,
   ROUND(
       SAFE_DIVIDE(
           COUNTIF(proj_tally = 'win'),
           COUNTIF(proj_tally IN ('win','loss'))
       ) * 100, 2
   ) AS win_rate_percentage
FROM 
    `nba-predictive-model.nba_model_poc.cleaned_projection_logs`
WHERE
   proj_tally IN ('win', 'loss')
GROUP BY
   prop_type
ORDER BY
   win_rate_percentage DESC;


-- ==============================================================================
-- PHASE 3: GATE 2 - PREDICTIVE STABILITY
-- ==============================================================================

-- 7. MAE & Directional Bias: Evaluating variance and projection lean bias 
SELECT
   prop_type,
   COUNT(*) AS total_active_bets,
   COUNTIF(LOWER(proj_lean) = 'more') AS more_predictions,
   COUNTIF(LOWER(proj_lean) = 'less') AS less_predictions,
   ROUND(
       SAFE_DIVIDE(
           COUNTIF(LOWER(proj_lean) = 'more'),
           COUNT(*)
       ) * 100, 2
   ) AS more_bias_percentage,
   ROUND(
       SAFE_DIVIDE(
           COUNTIF(LOWER(proj_lean) = 'less'),
           COUNT(*)
       ) * 100, 2
   ) AS less_bias_percentage,
   ROUND(AVG(ABS(proj_outcome - actual_outcome)), 2) AS mean_absolute_error
FROM
   `nba-predictive-model.nba_model_poc.cleaned_projection_logs`
WHERE
   proj_tally IN ('win', 'loss')
GROUP BY
   prop_type
ORDER BY
   mean_absolute_error ASC;
