# CISA KEV Prediction using Machine Learning

This repository contains the implementation of a predictive modeling pipeline to identify CVEs (Common Vulnerabilities and Exposures) that are likely to become CISA Known Exploited Vulnerabilities (KEVs).

## 🔍 Problem Statement

Organizations face overwhelming numbers of reported software vulnerabilities. Only a few are actively exploited. The goal of this project is to predict which CVEs will be labeled as KEVs using machine learning models and multi-source feature integration (CVSS, EPSS, CPE).

## 🧠 Methodology

- **Data Source**: Aggregated datasets from Kaggle combining CVE, KEV, CVSS, EPSS, and CPE data.
- **Preprocessing**:
  - Missing value imputation
  - Feature encoding (one-hot, factor conversion)
  - SMOTE (oversampling) and undersampling with PCA
- **Modeling Techniques**:
  - Logistic Regression
  - Random Forest
  - XGBoost (baseline, threshold-tuned, and cost-sensitive)

## 📊 Evaluation Metrics

- Accuracy
- AUC (Area Under Curve)
- Precision
- Recall
- F1 Score

Cost-sensitive XGBoost achieved the best performance:
- AUC: 0.9957
- Recall: 1.00
- Precision: 0.907
- F1 Score: ~0.95

## 📁 Repository Contents

| File Name                    | Description                                      |
|-----------------------------|--------------------------------------------------|
| `CISA_KEV_Report.docx`      | Final report with detailed explanation and results |
| `CISA_KEV_Presentation.pptx`| Final presentation slides                        |
| `Cleaned_Dataset.csv`       | Preprocessed dataset used for training           |
| `Final Combined Dataset...` | Aggregated dataset for modeling                  |
| `KEV_Model_Training.R`      | Main script for training models                  |
| `KEV_Model_Evaluation.R`    | Evaluation scripts and analysis                  |
| `CISA_KEV_Project.Rproj`    | R project configuration                          |

## 🏁 Conclusion

Cost-sensitive XGBoost demonstrated superior performance and practical usability in prioritizing vulnerability patching by predicting potential KEVs. This model can aid security teams in focusing efforts on the most pressing threats.

---

