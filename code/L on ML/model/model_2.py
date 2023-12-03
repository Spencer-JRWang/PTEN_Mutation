import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from xgboost import XGBRFClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import AdaBoostClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import accuracy_score
from sklearn.metrics import roc_curve, auc
from sklearn.preprocessing import LabelEncoder
from tqdm import tqdm


# load data
df_all = pd.read_csv('L on ML/paras.txt', sep='\t')

# 切分数据
df_ASD_AC = df_all[df_all['Disease'].isin(['ASD', 'ASD_Cancer'])]
df_Cancer_AC = df_all[df_all['Disease'].isin(['Cancer', 'ASD_Cancer'])]


####################################
###### 随机森林第一步
####################################
# 洗牌打乱    
X_select = df_Cancer_AC[['Co.evolution','Conservation','Entropy','RASA',
                      'energy','Betweenness','Closeness','Degree','Eigenvector',
                      'Clustering.coefficient','Effectiveness','Sensitivity',
                      'MSF','DFI','Stiffness']]
y_select = df_Cancer_AC['Disease']

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

# 建立模型
rf_clf_select  = RandomForestClassifier()

# 定义参数网格
rf_grid = {
    'n_estimators': [500, 1000, 1500, 2000],
    'max_depth': [5, 10, 15]
}

# 超参数调优
grid_search = GridSearchCV(rf_clf_select, rf_grid, cv=5)
grid_search.fit(X_train_select, y_train_select)
rf_clf_select  = RandomForestClassifier(n_estimators = grid_search.best_params_['n_estimators'], 
                                        max_depth=grid_search.best_params_['n_estimators'],
                                        n_jobs=-1)
rf_clf_select.fit(X_train_select, y_train_select)
score_select = rf_clf_select.feature_importances_
y_pred_select = rf_clf_select.predict(X_test_select)

# 输出结果
print('AUC值')
label_encoder = LabelEncoder()
y_test_select_bi = label_encoder.fit_transform(y_test_select)
y_pred_select_bi = label_encoder.fit_transform(y_pred_select)
fpr_select, tpr_select, thresholds_select = roc_curve(y_test_select_bi, y_pred_select_bi)
roc_auc_select = auc(fpr_select, tpr_select)
print(roc_auc_select)
print('模型准确度')
print(accuracy_score(y_test_select, y_pred_select))


####################################
###### 计算打分值
####################################

# 重要程度列表化
list_importance = str(score_select).strip('[').strip(']').split()
list_importance_ziped = zip(['Co.evolution','Conservation','Entropy','RASA',
                       'energy','Betweenness','Closeness','Degree','Eigenvector','Clustering.coefficient',
                       'Effectiveness','Sensitivity','MSF','DFI','Stiffness'], list_importance)
print(list(list_importance_ziped))





####################################
###### Stacking计算
####################################









