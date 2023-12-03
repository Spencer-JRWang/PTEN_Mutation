import pandas as pd
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
import itertools
import numpy as np
from sklearn.metrics import roc_auc_score,roc_curve,auc
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn import metrics
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt

# 读取数据
df_all = pd.read_csv('L on ML/paras.txt', sep='\t')
# 数据切分
df_ASD_Cancer = df_all[df_all['Disease'].isin(['ASD', 'Cancer'])]
df_ASD_AC = df_all[df_all['Disease'].isin(['ASD', 'ASD_Cancer'])]
df_Cancer_AC = df_all[df_all['Disease'].isin(['Cancer', 'ASD_Cancer'])]


def average(n):
    summ = 0
    for i in n:
        summ += i
    return summ/len(n)

def haverage_fpr(n):
    list1 = []
    for i in n:
        list1.append(i[0])
    set1 = set(list1)
    list1 = list(set1)
    list1 = sorted(list1)
    return list1
    

def haverage_tpr(n):
    list2 = []
    for i in haverage_fpr(n):
        list1 = []
        for j in n:
            if j[0] == i:
                list1.append(j[1])
        m = average(list1)
        list2.append(m)
    return list2

def multi_models_roc(names, sampling_methods, colors, X, y, save=True, dpin=100):
        """
        将多个机器模型的roc图输出到一张图上
        
        Args:
            names: list, 多个模型的名称
            sampling_methods: list, 多个模型的实例化对象
            save: 选择是否将结果保存(默认为png格式)
            
        Returns:
            返回图片对象plt
        """
        label_encoder = LabelEncoder()
        mean_fpr = np.linspace(0, 1, 100)
        plt.figure(figsize=(10, 10), dpi=dpin)
        for (name, method, colorname) in zip(names, sampling_methods, colors):
            tprs = []
            aucs = []
            for i in tqdm(range(50)):
                method_a = method
                X1 = X.reset_index(drop=True)
                y1 = y.reset_index(drop=True)
                shuffle_index = np.random.permutation(X1.index)
                X1 = X1.iloc[shuffle_index]
                y1 = y1.iloc[shuffle_index]
                X_train = X1[:round(X.shape[0] * 0.7)]
                X_test = X1[round(X.shape[0] * 0.7):]
                y_train = y1[:round(X.shape[0] * 0.7)]
                y_test = y1[round(X.shape[0] * 0.7):]
                
                method_a.fit(X_train, y_train)

                y_pred_prob = method.predict_proba(X_test)[:,1]
                y_test_bi = label_encoder.fit_transform(y_test)
                fpr, tpr, thresholds = roc_curve(y_test_bi, y_pred_prob, pos_label=1)
                aucc = auc(fpr, tpr)
                interp_tpr = np.interp(mean_fpr, fpr, tpr)
                interp_tpr[0] = 0.0
                tprs.append(interp_tpr)
                aucs.append(aucc)


                plt.plot(fpr, tpr, lw=1.5, color = "grey",alpha = 0.15)
                plt.plot([0, 1], [0, 1], '--', lw=1.5, color = 'grey')
                plt.axis('square')
                plt.xlim([0, 1])
                plt.ylim([0, 1])
                plt.xlabel('Specificity',fontsize=15)
                plt.ylabel('Sensitivity',fontsize=15)
                plt.title('ASD VS ASD_Cancer',fontsize=20)
                #plt.legend(loc='lower right',fontsize=15)
            mean_tpr = np.mean(tprs, axis=0)
            mean_tpr[-1] = 1.0
            mean_auc = auc(mean_fpr, mean_tpr)
            std_auc = np.std(aucs)

            plt.plot(
                mean_fpr,
                mean_tpr,
                color=colorname,
                label=r"Mean ROC (AUC = %0.2f $\pm$ %0.2f)" % (mean_auc, std_auc),
                lw=2
            )

            std_tpr = np.std(tprs, axis=0)
            tprs_upper = np.minimum(mean_tpr + std_tpr, 1)
            tprs_lower = np.maximum(mean_tpr - std_tpr, 0)
            plt.fill_between(
                mean_fpr,
                tprs_lower,
                tprs_upper,
                color=colorname,
                alpha=0.2,
                label=r"$\pm$ 1 std. dev.",
            )
            plt.legend(loc="lower right")

        if save:
            plt.savefig('multi_models_roc.png')
            
        return plt

list_ASD_G = [
    ['Closeness', 'Degree'],
    ['Co.evolution', 'Entropy', 'Betweenness', 'Degree', 'Clustering.coefficient', 'MSF', 'DFI'],
    ['Conservation', 'Entropy', 'RASA', 'Betweenness', 'Degree', 'Eigenvector', 'Effectiveness', 'MSF', 'DFI'],
    ['Conservation', 'energy', 'Betweenness', 'Closeness', 'Degree', 'Clustering.coefficient', 'Effectiveness', 'Sensitivity', 'DFI', 'Stiffness'],
    ['Betweenness', 'Closeness', 'Degree', 'Clustering.coefficient', 'Effectiveness', 'Sensitivity', 'Stiffness'],
    ['Conservation', 'Betweenness', 'Degree', 'Eigenvector', 'Clustering.coefficient', 'Effectiveness', 'MSF'],
    ['Co.evolution', 'Betweenness', 'Closeness', 'Degree', 'Clustering.coefficient', 'Effectiveness', 'DFI', 'Stiffness'],
    ['Conservation', 'RASA', 'Betweenness', 'Closeness', 'Degree', 'Eigenvector', 'Clustering.coefficient', 'Effectiveness', 'MSF'],
    ['Conservation', 'RASA', 'energy', 'Betweenness', 'Closeness', 'Degree', 'Clustering.coefficient', 'Effectiveness', 'Sensitivity', 'MSF', 'DFI'],
    ['Co.evolution', 'Entropy', 'RASA', 'Betweenness', 'Closeness', 'Degree', 'Effectiveness', 'Sensitivity']
]

list_ASD_R = [
    ['Degree'],
    ['Conservation', 'Betweenness', 'Closeness', 'Degree'],
    ['Betweenness', 'Closeness', 'Degree', 'Effectiveness'],
    ['Betweenness', 'Closeness', 'Degree', 'Clustering.coefficient'],
    ['Conservation', 'Betweenness', 'Closeness', 'Degree', 'Clustering.coefficient'],
    ['Betweenness', 'Closeness', 'Degree', 'DFI'],
    ['Entropy', 'Betweenness', 'Closeness', 'Degree'],
    ['Betweenness', 'Degree'],
    ['Betweenness', 'Degree', 'Sensitivity'],
    ['RASA', 'Betweenness', 'Closeness', 'Degree', 'DFI']
]

list_Cancer_R = [
    ['Co.evolution', 'Conservation', 'RASA', 'energy', 'Betweenness', 'Closeness', 'Degree', 'Eigenvector', 'Clustering.coefficient', 'MSF'],
    ['Betweenness', 'Closeness', 'Degree', 'DFI', 'Stiffness'],
    ['Betweenness', 'Degree', 'MSF', 'Stiffness'],
    ['Betweenness', 'Closeness', 'Degree', 'Sensitivity', 'MSF', 'DFI'],
    ['RASA', 'Betweenness', 'Closeness', 'Degree']
]

list_Cancer_G = [
    ['Conservation', 'RASA', 'Betweenness', 'Closeness', 'Degree', 'Sensitivity', 'Stiffness'],
    ['Entropy', 'Betweenness', 'Closeness', 'Degree', 'Effectiveness', 'DFI'],
    ['Co.evolution', 'Conservation', 'Betweenness', 'Degree', 'Eigenvector', 'Effectiveness', 'Sensitivity', 'MSF', 'DFI'],
    ['Conservation', 'RASA', 'energy', 'Betweenness', 'Closeness', 'Degree', 'Clustering.coefficient', 'Effectiveness', 'DFI', 'Stiffness'],
    ['Entropy', 'RASA', 'Betweenness', 'Closeness', 'Degree', 'Effectiveness', 'Sensitivity', 'DFI', 'Stiffness']
]

for i in list_Cancer_G:
    X = df_Cancer_AC[i]
    y = df_Cancer_AC['Disease']
    names = [#'RandomForest'#, # 这个就是模型标签
            'GradientDescent'#,
            #'AdaBoost'
            ]

    sampling_methods = [#RandomForestClassifier(n_estimators=1000, n_jobs=-1, max_depth=5)#,# 这个就是训练的模型。
                        GradientBoostingClassifier(n_estimators=1000, max_depth=5)#,
#                       AdaBoostClassifier(n_estimators=1000)
                    ]

    colors = [#'#36ab5d'#,  # 这个是曲线的颜色，几个模型就需要几个颜色哦！
            '#e88654'#,
            #'#7389dd'
            ]

    #ROC curves
    test_roc_graph = multi_models_roc(names, sampling_methods, colors, X, y, save = False)  # 这里可以改成训练集
    test_roc_graph.savefig('L on ML/figure/梯度下降/Cancer/' + str(i) + '.pdf')
