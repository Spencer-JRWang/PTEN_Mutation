import pandas as pd
import numpy as np
from sklearn.ensemble import AdaBoostClassifier
from sklearn.metrics import roc_curve, auc
from sklearn.preprocessing import LabelEncoder
from tqdm import tqdm

# 读取数据
df_all = pd.read_csv('../paras.txt', sep='\t')
# 数据切分
df_ASD_Cancer = df_all[df_all['Disease'].isin(['ASD', 'Cancer'])]
df_ASD_AC = df_all[df_all['Disease'].isin(['ASD', 'ASD_Cancer'])]
df_Cancer_AC = df_all[df_all['Disease'].isin(['Cancer', 'ASD_Cancer'])]
def average(lst):
    if len(lst) == 0:
        return 0
    else:
        return sum(lst) / len(lst)
    

# 生成全部的组合
import itertools
variables = ['Co.evolution','Conservation','Entropy','RASA','energy',
             'Betweenness','Closeness','Degree','Eigenvector',
             'Clustering.coefficient','Effectiveness','Sensitivity',
             'MSF','DFI','Stiffness']
all_combinations = []
# 组合
for r in range(1, len(variables)+1):
    combinations = list(itertools.combinations(variables, r))
    combinations = [list(combination) for combination in combinations]  # 转换为列表
    all_combinations.extend(combinations)

list_ASD_AC = []
df_ASD_Cancer = df_all[df_all['Disease'].isin(['ASD', 'Cancer'])]
df_ASD_AC = df_all[df_all['Disease'].isin(['ASD', 'ASD_Cancer'])]
df_Cancer_AC = df_all[df_all['Disease'].isin(['Cancer', 'ASD_Cancer'])]


for combination in tqdm(all_combinations):
    # 选取数据 
    X_select = df_Cancer_AC[combination]
    y_select = df_Cancer_AC['Disease']
    # 切分后的数据集重新将index排序
    roc_select_list = []
    for i in range(10):
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
        # 训练模型————随机森林
        rf_clf_select = AdaBoostClassifier(n_estimators=1000)
        rf_clf_select.fit(X_train_select, y_train_select)
        score_select = rf_clf_select.feature_importances_
        #y_pred_select = rf_clf_select.predict(X_test_select)
        y_pred_select_prob = rf_clf_select.predict_proba(X_test_select)[:,1]
    
        # 计算ROC值
        label_encoder = LabelEncoder()
        y_test_select_bi = label_encoder.fit_transform(y_test_select)
        # y_pred_select_bi = label_encoder.fit_transform(y_pred_select)
        fpr_select, tpr_select, thresholds_select = roc_curve(y_test_select_bi, y_pred_select_prob)
        roc_auc_select = auc(fpr_select, tpr_select)
        roc_select_list.append(roc_auc_select)

    f = open("../outcome/Ada_Cancer_ASD_Cancer.txt", "a")
    f.write(str(combination) + '\t')
    f.write(str(average(roc_select_list)) + '\t')
    f.write(str(roc_select_list))
    f.write('\n')
    f.close()