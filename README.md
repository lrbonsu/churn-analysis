
# Telco Customer Churn Analysis

## Business Problem
A telecom company is losing customers at an alarming rate, directly impacting monthly revenue. 
This project identifies the key drivers of customer churn and builds a predictive model to flag 
at-risk customers before they leave — enabling the business to take proactive retention action.

---

## Tools & Technologies
- **Python** — data cleaning, exploratory analysis, machine learning
- **SQL (SQLite)** — data validation, segmentation queries, business metrics
- **Tableau Public** — interactive dashboard for business stakeholders
- **Libraries** — pandas, numpy, matplotlib, seaborn, scikit-learn

---

## Dataset
- **Source:** IBM Telco Customer Churn dataset via Kaggle
- **Size:** 7,043 customers | 21 features
- **Target variable:** Churn (Yes/No)

---

## Project Structure

    churn-analysis/
    │
    ├── data/
    │   ├── telco_churn.csv           # Raw dataset
    │   ├── telco_churn_clean.csv     # Cleaned dataset for Tableau
    │   └── churn.db                  # SQLite database
    │
    ├── notebooks/
    │   ├── 01_setup.ipynb            # Data loading & database setup
    │   ├── 02_sql_analysis.ipynb     # SQL queries & business metrics
    │   ├── 03_eda.ipynb              # Exploratory data analysis
    │   └── 04_ml_model.ipynb         # Machine learning models
    │
    ├── sql/
    │   └── churn_queries.sql         # All SQL queries
    │
    └── README.md

---

## Methodology

### 1. Data Setup
Loaded raw CSV into SQLite database using Python. Handled one known data 
quality issue — blank TotalCharges values for new customers with zero tenure, 
filled with 0. Standardised column names and converted churn to binary (1/0).

### 2. SQL Analysis
Wrote 9 queries covering overall churn rate, segmentation by contract type, 
tenure, payment method, and internet service. Used window functions (RANK, NTILE) 
and a CTE to identify high-value churned customers and quantify revenue at risk.

### 3. Exploratory Data Analysis
Analysed distributions, correlations, and churn patterns across all key features 
using Python. Generated 6 visualisations identifying the strongest drivers of churn.

### 4. Machine Learning
Built two classification models to predict churn:
- **Logistic Regression** — interpretable baseline model
- **Random Forest** — higher accuracy ensemble model

Both models were evaluated on accuracy, ROC-AUC, precision, recall, and F1-score.

---

## Key Findings

| Finding | Detail |
|---|---|
| Overall churn rate | 26.5% of customers churned |
| Strongest driver | Month-to-month contracts churn at 42.7% vs 2.8% for two-year contracts |
| Tenure risk window | Customers in their first 12 months churn at 6x the rate of long-term customers |
| Price sensitivity | Churned customers pay higher average monthly charges |
| Payment method | Electronic check users churn at nearly 2x the rate of auto-pay customers |
| Revenue at risk | ~$139K in monthly recurring revenue lost to churn |

---

## Model Results

| Model | Accuracy | ROC-AUC | Churner Recall |
|---|---|---|---|
| Logistic Regression | 80% | 0.842 | 52% |
| Random Forest | 80% | 0.842 | 52% |

**Note:** Both models achieved solid baseline performance. The 52% churner recall 
reflects class imbalance in the dataset (73.5% stayed vs 26.5% churned). 
Next iteration would apply SMOTE oversampling to improve churn detection.

---

## Business Recommendation

Target month-to-month customers in their first 12 months with proactive 
retention offers — discounted annual contracts, loyalty incentives, or 
personalised outreach. This single segment represents the highest churn 
risk and the greatest opportunity for revenue retention.

---

## Dashboard
View the interactive Tableau dashboard here: [Telco Churn Dashboard](https://public.tableau.com/app/profile/lynnetta.bonsu/viz/PortfolioProject_1/TelcoChurnAnalysis)

---

## How to Run This Project

1. Clone the repo:

    git clone https://github.com/lrbonsu/churn-analysis.git
    cd churn-analysis

2. Install dependencies:

    pip install pandas numpy matplotlib seaborn scikit-learn

3. Download the dataset from Kaggle and place it in data/telco_churn.csv

4. Run notebooks in order:
   - 01_setup.ipynb
   - 02_sql_analysis.ipynb
   - 03_eda.ipynb
   - 04_ml_model.ipynb

---

## Author
Lynnetta Bonsu — [LinkedIn](https://www.linkedin.com/in/lrbonsu/) | [Tableau Public](https://public.tableau.com/app/profile/lynnetta.bonsu/vizzes) | [GitHub](https://github.com/lrbonsu)
