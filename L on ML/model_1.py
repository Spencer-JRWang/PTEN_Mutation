#%%
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from xgboost import XGBRFClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.ensemble import ExtraTreesClassifier
from sklearn.svm import LinearSVC
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import AdaBoostClassifier
from sklearn.metrics import accuracy_score
from sklearn.model_selection import cross_val_score
from sklearn.metrics import roc_curve, auc
from sklearn.preprocessing import LabelEncoder
from tqdm import tqdm


#%%
# load data
df_all = pd.read_csv('/Users/wangjingran/Desktop/PTEN mutation/L on ML/paras.txt', sep='\t')

# 切分数据
df_ASD_AC = df_all[df_all['Disease'].isin(['ASD', 'ASD_Cancer'])]
df_Cancer_AC = df_all[df_all['Disease'].isin(['Cancer', 'ASD_Cancer'])]


#%%
####################################
###### 第一步
####################################
# 洗牌打乱    
X_select = df_Cancer_AC[['Co.evolution','Conservation','Entropy','RASA',
                      'energy','Betweenness','Closeness','Degree','Eigenvector',
                      'Clustering.coefficient','Effectiveness','Sensitivity',
                      'MSF','DFI','Stiffness']]
X_select = df_Cancer_AC[['Conservation', 'Entropy', 'RASA', 'Betweenness', 'Closeness', 'Degree', 'Eigenvector', 'Clustering.coefficient']]
y_select = df_Cancer_AC['Disease']

# 切分后的数据集重新将index排序
X_select = X_select.reset_index(drop=True)
y_select = y_select.reset_index(drop=True)
shuffle_index = np.random.permutation(X_select.index)
X_select= X_select.iloc[shuffle_index]
y_select = y_select.iloc[shuffle_index]

# 切分数据集
X_train_select = X_select[round(X_select.shape[0] * 0.8):]
X_test_select = X_select[:round(X_select.shape[0] * 0.8)]
y_train_select = y_select[round(X_select.shape[0] * 0.8):]
y_test_select = y_select[:round(X_select.shape[0] * 0.8)]

# 建立模型并训练
rf_clf_select = RandomForestClassifier(n_estimators=1000, n_jobs=-1, max_depth=5,oob_score=True)
gb_clf_select = GradientBoostingClassifier(n_estimators=1000, max_depth=5)
et_clf_select= ExtraTreesClassifier(n_estimators=1000, max_depth=5, n_jobs=-1)
rf_clf_select.fit(X_train_select, y_train_select)
gb_clf_select.fit(X_train_select, y_train_select)
et_clf_select.fit(X_train_select, y_train_select)

score_select_rf = rf_clf_select.feature_importances_
y_pred_select_rf = rf_clf_select.predict(X_test_select)
y_pred_select_gb = gb_clf_select.predict(X_test_select)
y_pred_select_et = et_clf_select.predict(X_test_select)
##### 输出结果
# 交叉验证
cv_scores_rf = cross_val_score(rf_clf_select, X_select, y_select, cv=5)
cv_scores_gb = cross_val_score(gb_clf_select, X_select, y_select, cv=5)
cv_scores_et = cross_val_score(et_clf_select, X_select, y_select, cv=5)
# print("交叉验证")
# print(cv_scores_rf)
# print(cv_scores_gb)
# print(cv_scores_et)

# AUC

print('AUC值')
label_encoder = LabelEncoder()
y_test_select_bi = label_encoder.fit_transform(y_test_select)
y_pred_select_bi_rf = label_encoder.fit_transform(y_pred_select_rf)
fpr_select, tpr_select, thresholds_select = roc_curve(y_test_select_bi, y_pred_select_bi_rf)
roc_auc_select = auc(fpr_select, tpr_select)
print(roc_auc_select)

y_pred_select_bi_gb = label_encoder.fit_transform(y_pred_select_gb)
fpr_select, tpr_select, thresholds_select = roc_curve(y_test_select_bi, y_pred_select_bi_gb)
roc_auc_select = auc(fpr_select, tpr_select)
print(roc_auc_select)

y_pred_select_bi_et = label_encoder.fit_transform(y_pred_select_et)
fpr_select, tpr_select, thresholds_select = roc_curve(y_test_select_bi, y_pred_select_bi_et)
roc_auc_select = auc(fpr_select, tpr_select)
print(roc_auc_select)
# accuracy
# print('模型准确度')
# print(accuracy_score(y_test_select_bi, y_pred_select_bi_rf))
# print(accuracy_score(y_test_select_bi, y_pred_select_bi_gb))
# print(accuracy_score(y_test_select_bi, y_pred_select_bi_et))

# 计算模型的全部概率
predicted_probabilities_rf = rf_clf_select.predict_proba(X_select)
predicted_probabilities_gb = rf_clf_select.predict_proba(X_select)
predicted_probabilities_et = rf_clf_select.predict_proba(X_select)


####################################
###### Stacking计算
####################################
print('----------------------------------STACKING----------------------------------')
#%%
# 定义三个分类器
ad_clf = AdaBoostClassifier(n_estimators=5000)
xg_clf = XGBRFClassifier(n_estimators = 5000, max_depth = 5, n_jobs = -1)
svm_clf = LinearSVC()
# 再次切分数据
X = predicted_probabilities_gb
y = y_select

X_train = X[round(X.shape[0] * 0.8):]
X_test = X[:round(X.shape[0] * 0.8)]
y_train = y[round(y.shape[0] * 0.8):]
y_test = y[:round(y.shape[0] * 0.8)]
# 训练模型
# 模型的树许依次为Adaboost Xgboost SVM
y_train_bi = label_encoder.fit_transform(y_train)
estimators = [ad_clf, xg_clf, svm_clf]
for estimator in estimators:
    print("Training The " + str(estimator)[:str(estimator).find('(')])
    estimator.fit(X_train, y_train_bi)
    y_test_bi = label_encoder.fit_transform(y_test)
    y_pred = estimator.predict(X_test)
    y_pred_bi = label_encoder.fit_transform(y_pred)
    fpr_select, tpr_select, thresholds_select = roc_curve(y_test_bi, y_pred_bi)
    roc_auc_select = auc(fpr_select, tpr_select)
    print(roc_auc_select)

X_val_predictions = np.empty((len(X), len(estimators)), dtype = np.float32)

# 生成喂给LG的数据
for index, estimator in enumerate(estimators):
    X_val_predictions[:, index] = estimator.predict(X)

#%%
# 随机森林
print("--------------------LG--------------------")
for _ in range(1,20):
    X = X_val_predictions
    lg_res = RandomForestClassifier(n_estimators=2000,max_depth=5,n_jobs=-1)
    # 创建一个随机排列的索引
    n_samples = X.shape[0]  # 假设X是一个numpy数组，n_samples是样本数量
    indices = np.random.permutation(n_samples)

    # 使用相同的索引来打乱X和y
    X = X[indices]
    y = y[indices]
    X_train = X[:round(X.shape[0] * 0.8)]
    X_test = X[round(X.shape[0] * 0.8):]
    y_train = y[:round(y.shape[0] * 0.8)]
    y_test = y[round(y.shape[0] * 0.8):]
    lg_res.fit(X_train, y_train)
    y_pred = lg_res.predict(X_test)

'''
    # 计算ROC值,查看模型的精确程度
    y_test_bi = label_encoder.fit_transform(y_test)
    y_pred = lg_res.predict_proba(X_test)
    fpr_select, tpr_select, thresholds_select = roc_curve(y_test_bi, y_pred)
    roc_auc_select = auc(fpr_select, tpr_select)
    print(roc_auc_select)
'''








