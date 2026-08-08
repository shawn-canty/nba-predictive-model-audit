The following table defines the schema for the NBA Model attributes used in this analysis.

# Data Dictionary: NBA Predictive Model

| Column Name | BigQuery Data Type | Description |
| :--- | :--- | :--- |
| `date` | DATE | The date the NBA playoff game was played. |
| `player_id` | STRING | The identifier (last name) of the NBA player. |
| `prop_type` | STRING | The specific stat market being predicted (pts_line, rbs_line, ast_line). |
| `chalkboard` -> `fanduel` | FLOAT | The individual sportsbook lines available at the time of the prediction. |
| `market_consensus` | FLOAT | The derived consensus line across all sportsbooks (our baseline). |
| `proj_outcome` | FLOAT | Our model's exact statistical prediction for the player. |
| `proj_lean` | STRING | The model's active betting direction (more, less, or fade if no edge). |
| `actual_outcome` | INTEGER | The actual stat recorded by the player in the real game. |
| `proj_tally` | STRING | The graded outcome of the prediction (win, loss, PUSH, fade). |
| `model_margin` | FLOAT | The mathematical delta between our model's projection and the market consensus. |
