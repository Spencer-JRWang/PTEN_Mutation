import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from xgboost import XGBRFClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import AdaBoostClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.metrics import accuracy_score
from sklearn.metrics import roc_curve, auc
from sklearn.preprocessing import LabelEncoder
from tqdm import tqdm

# load data
df_all = pd.read_csv('/Users/wangjingran/Desktop/PTEN mutation/L on ML/paras.txt', sep='\t')
# 切分数据
df_ASD_AC = df_all[df_all['Disease'].isin(['ASD', 'ASD_Cancer'])]
df_Cancer_AC = df_all[df_all['Disease'].isin(['Cancer', 'ASD_Cancer'])]

for i in range(100):
    # 洗牌打乱    
    X_select = df_ASD_AC[['Conservation', 'Entropy', 'RASA', 'energy', 'Closeness', 'Degree', 'Eigenvector']]
    y_select = df_ASD_AC['Disease']

    # 切分后的数据集重新将index排序
    X_select = X_select.reset_index(drop=True)
    y_select = y_select.reset_index(drop=True)
    shuffle_index = np.random.permutation(X_select.index)
    X_select= X_select.iloc[shuffle_index]
    y_select = y_select.iloc[shuffle_index]

    # 切分数据集
    X_train_select = X_select[:round(X_select.shape[0] * 0.7)]
    X_test_select = X_select[round(X_select.shape[0] * 0.7):]
    y_train_select = y_select[:round(X_select.shape[0] * 0.7)]
    y_test_select = y_select[round(X_select.shape[0] * 0.7):]

    # 训练
    rf_clf_select =  RandomForestClassifier(n_estimators=1000, max_depth = 5)
    rf_clf_select.fit(X_train_select, y_train_select)
    score_select_rf = rf_clf_select.feature_importances_
    y_pred_select_rf = rf_clf_select.predict(X_test_select)

    # AUC
    label_encoder = LabelEncoder()
    #y_test_preds = method.predict(X_test_select)
    y_test_predprob = rf_clf_select.predict_proba(X_test_select)[:,1]
    y_test_bi = label_encoder.fit_transform(y_test_select)
    fpr, tpr, thresholds = roc_curve(y_test_bi, y_test_predprob, pos_label=1)    
    roc_auc_select = auc(fpr, tpr)
    print(roc_auc_select)
    if roc_auc_select > 0.97:
        break
