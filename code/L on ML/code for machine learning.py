#############################
###    机器学习部分代码
#############################

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
from sklearn.metrics import roc_curve, auc
from sklearn.preprocessing import label_binarize

# 读取数据
df_AA = pd.read_csv('itasser-AAN-feature.txt', sep='\t')
df_dyn = pd.read_csv('itasser_pos_dyn.txt', sep='\t')
##### 对氨基酸网络的特征进行ML
print("------------------------------氨基酸网络------------------------------")
# 数据集切分
# 疾病数据切分
df_AA_ASD_Cancer = df_AA[df_AA['Disease'].isin(['ASD', 'Cancer'])]
df_AA_ASD_AC = df_AA[df_AA['Disease'].isin(['ASD', 'ASD_Cancer'])]
df_AA_Cancer_AC = df_AA[df_AA['Disease'].isin(['Cancer', 'ASD_Cancer'])]

# 洗牌打乱    
X_1 = df_AA_ASD_Cancer[['Betweenness', 'Closeness', 'Degree', 'Eigenvector', 'Clustering_coefficient']]
y_1 = df_AA_ASD_Cancer['Disease']
# 切分后的数据集重新将index排序
X_1 = X_1.reset_index(drop=True)
y_1 = y_1.reset_index(drop=True)
shuffle_index = np.random.permutation(X_1.index)
X_1= X_1.iloc[shuffle_index]
y_1 = y_1.iloc[shuffle_index]

X_2 = df_AA_ASD_Cancer[['Betweenness', 'Closeness', 'Degree', 'Eigenvector', 'Clustering_coefficient']]
y_2 = df_AA_ASD_Cancer['Disease']
X_2 = X_2.reset_index(drop=True)
y_2 = y_2.reset_index(drop=True)
shuffle_index = np.random.permutation(X_2.index)
X_2 = X_2.iloc[shuffle_index]
y_2 = y_2.iloc[shuffle_index]

X_3 = df_AA_ASD_Cancer[['Betweenness', 'Closeness', 'Degree', 'Eigenvector', 'Clustering_coefficient']]
y_3 = df_AA_ASD_Cancer['Disease']
X_3 = X_3.reset_index(drop=True)
y_3 = y_3.reset_index(drop=True)
shuffle_index = np.random.permutation(X_3.index)
X_3 = X_3.iloc[shuffle_index]
y_3 = y_3.iloc[shuffle_index]

# 训练集测试集切分
# [806rows, 5cols]
X_train_1 = X_1[:650]
X_test_1 = X_1[650:]
y_train_1 = y_1[:650]
y_test_1 = y_1[650:]

X_train_2 = X_2[:650]
X_test_2 = X_2[650:]
y_train_2 = y_2[:650]
y_test_2 = y_2[650:]

X_train_3 = X_3[:650]
X_test_3 = X_3[650:]
y_train_3 = y_3[:650]
y_test_3 = y_3[650:]


# 模型构建
rf_clf_1 = RandomForestClassifier(n_estimators=500, n_jobs=-1, oob_score=True)
rf_clf_2 = RandomForestClassifier(n_estimators=500, n_jobs=-1, oob_score=True)
rf_clf_3 = RandomForestClassifier(n_estimators=500, n_jobs=-1, oob_score=True)

rf_clf_1.fit(X_train_1, y_train_1)
rf_clf_2.fit(X_train_2, y_train_2)
rf_clf_3.fit(X_train_3, y_train_3)
score_1 = rf_clf_1.feature_importances_
score_2 = rf_clf_2.feature_importances_
score_3 = rf_clf_3.feature_importances_
print("对于ASD|Cancer重要性得分: ", end = '')
print(['Betweenness', 'Closeness', 'Degree', 'Eigenvector', 'Clustering_coefficient'])
print(score_1)
print("对于ASD|ASD_Cancer重要性得分: ", end = '')
print(['Betweenness', 'Closeness', 'Degree', 'Eigenvector', 'Clustering_coefficient'])
print(score_2)
print("对于Cancer|ASD_Cancer重要性得分: ", end = '')
print(['Betweenness', 'Closeness', 'Degree', 'Eigenvector', 'Clustering_coefficient'])
print(score_3)

# 模型评估
y_pred_1 = rf_clf_1.predict(X_test_1)
y_pred_2 = rf_clf_2.predict(X_test_2)
y_pred_3 = rf_clf_3.predict(X_test_3)
print('ASD|Cancer预测准确度是: ', end='')
print(accuracy_score(y_test_1, y_pred_1))
print('ASD|ASD_Cancer预测准确度是: ', end='')
print(accuracy_score(y_test_2, y_pred_2))
print('Cancer|Control预测准确度是: ', end='')
print(accuracy_score(y_test_3, y_pred_3))


####### 对弹性网络部分进行ML
print("------------------------------弹性网络部分------------------------------")
# 数据集切分
# 疾病数据切分
df_dyn_ASD_Cancer = df_dyn[df_dyn['Disease'].isin(['ASD', 'Cancer'])]
df_dyn_ASD_AC = df_dyn[df_dyn['Disease'].isin(['ASD', 'ASD_Cancer'])]
df_dyn_Cancer_AC = df_dyn[df_dyn['Disease'].isin(['Cancer', 'ASD_Cancer'])]

# 洗牌打乱    
X_4 = df_dyn_ASD_Cancer[['Effectiveness', 'Sensitivity', 'MSF', 'DFI', 'Stiffness']]
y_4 = df_dyn_ASD_Cancer['Disease']
X_4 = X_4.reset_index(drop=True)
y_4 = y_4.reset_index(drop=True)
shuffle_index = np.random.permutation(X_4.index)
X_4 = X_4.iloc[shuffle_index]
y_4 = y_4.iloc[shuffle_index]

X_5 = df_dyn_ASD_AC[['Effectiveness', 'Sensitivity', 'MSF', 'DFI', 'Stiffness']]
y_5 = df_dyn_ASD_AC['Disease']
X_5 = X_5.reset_index(drop=True)
y_5 = y_5.reset_index(drop=True)
shuffle_index = np.random.permutation(X_5.index)
X_5 = X_5.iloc[shuffle_index]
y_5 = y_5.iloc[shuffle_index]

X_6 = df_dyn_Cancer_AC[['Effectiveness', 'Sensitivity', 'MSF', 'DFI', 'Stiffness']]
y_6 = df_dyn_Cancer_AC['Disease']
X_6 = X_6.reset_index(drop=True)
y_6 = y_6.reset_index(drop=True)
shuffle_index = np.random.permutation(X_6.index)
X_6 = X_6.iloc[shuffle_index]
y_6 = y_6.iloc[shuffle_index]
# 训练集测试集切分
# [561rows, 5cols]
X_train_4 = X_4[:round(X_4.shape[0] * 0.8)]
X_test_4 = X_4[round(X_4.shape[0] * 0.8):]
y_train_4 = y_4[:round(y_4.shape[0] * 0.8)]
y_test_4 = y_4[round(y_4.shape[0] * 0.8):]

X_train_5 = X_5[:round(X_5.shape[0] * 0.8)]
X_test_5 = X_5[round(X_5.shape[0] * 0.8):]
y_train_5 = y_5[:round(y_5.shape[0] * 0.8)]
y_test_5 = y_5[round(y_5.shape[0] * 0.8):]

X_train_6 = X_6[:round(X_6.shape[0] * 0.8)]
X_test_6 = X_6[round(X_6.shape[0] * 0.8):]
y_train_6 = y_6[:round(y_6.shape[0] * 0.8)]
y_test_6 = y_6[round(y_6.shape[0] * 0.8):]


# 模型构建
rf_clf_4 = RandomForestClassifier(n_estimators=500, n_jobs=-1, oob_score=True)
rf_clf_5 = RandomForestClassifier(n_estimators=500, n_jobs=-1, oob_score=True)
rf_clf_6 = RandomForestClassifier(n_estimators=500, n_jobs=-1, oob_score=True)

rf_clf_4.fit(X_train_4, y_train_4)
rf_clf_5.fit(X_train_5, y_train_5)
rf_clf_6.fit(X_train_6, y_train_6)
score_4 = rf_clf_4.feature_importances_
score_5 = rf_clf_5.feature_importances_
score_6 = rf_clf_6.feature_importances_
print("对于ASD|Cancer重要性得分: ", end = '')
print(['Effectiveness', 'Sensitivity', 'MSF', 'DFI', 'Stiffness'])
print(score_4)
print("对于ASD|ASD_Cancer重要性得分: ", end = '')
print(['Effectiveness', 'Sensitivity', 'MSF', 'DFI', 'Stiffness'])
print(score_5)
print("对于Cancer|ASD_Cancer重要性得分: ", end = '')
print(['Effectiveness', 'Sensitivity', 'MSF', 'DFI', 'Stiffness'])
print(score_6)

# 模型评估
y_pred_4 = rf_clf_4.predict(X_test_4)
y_pred_5 = rf_clf_5.predict(X_test_5)
y_pred_6 = rf_clf_6.predict(X_test_6)
print('ASD|Cancer预测准确度是: ', end='')
print(accuracy_score(y_test_4, y_pred_4))
print('ASD|ASD_Cancer预测准确度是: ', end='')
print(accuracy_score(y_test_5, y_pred_5))
print('Cancer|ASD_Cancer预测准确度是: ', end='')
print(accuracy_score(y_test_6, y_pred_6))
