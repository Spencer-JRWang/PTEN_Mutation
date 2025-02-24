import warnings
warnings.filterwarnings('ignore')
from xgboost import XGBClassifier
from lightgbm import LGBMClassifier
from catboost import CatBoostClassifier
from sklearn.model_selection import StratifiedKFold, GridSearchCV
from sklearn.feature_selection import RFE
from sklearn.model_selection import cross_val_predict
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import StackingClassifier
from sklearn.model_selection import cross_val_score
from itertools import combinations
from sklearn.metrics import roc_auc_score
from sklearn.metrics import roc_curve
from tqdm import tqdm



class ModelUtilities:
    def __init__(self):
        self.tuned_models = {}
        self.best_features = {}
        self.best_stacker = None
        self.final_features = []
        self.cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)

    def model_rfe(self, core, X_train, y_train):
        print("...RFE running...")
        outcome_feature = []
        outcome_score = []
        X_train.drop(columns=['Degree'], inplace=True)
        for i in range(X_train.shape[1]):
            rfe = RFE(core, n_features_to_select=i + 1)
            rfe.fit(X_train, y_train)
            selected_features = X_train.columns[rfe.support_]
            scores = cross_val_score(core, X_train[selected_features], y_train, cv=self.cv)
            outcome_feature.append(selected_features)
            outcome_score.append(scores.mean())

        max_predict_data = max(outcome_score)
        best_features = list(outcome_feature[outcome_score.index(max_predict_data)])

        if "Effectiveness" not in best_features \
        and "Sensitivity" not in best_features \
        and "Stiffness" not in best_features \
        and "MSF" not in best_features \
        and "DFI" not in  best_features:
            best_features.append("Effectiveness")

        if "ddG" not in best_features:
            best_features.append("ddG")

        # if "Degree" in best_features \
        # and "Eigenvector" not in best_features:
        #     best_features.append("Eigenvector")
        #     best_features.remove("Degree")
        # elif "Degree" in best_features \
        # and "Eigenvector" in best_features:
        #     best_features.remove("Degree")

        if "Betweenness" not in best_features \
        and "Closeness" not in best_features \
        and "Degree" not in best_features \
        and "Eigenvector" not in best_features \
        and "Clustering_coefficient" not in best_features:
            best_features.append("Betweenness")

        if "DFI" in best_features \
        and "Effectiveness" not in best_features:
            best_features.remove("DFI")
            best_features.append("Effectiveness")
        
        if "DFI" in best_features \
        and "Effectiveness" in best_features:
            best_features.remove("DFI")

        scores_adj = cross_val_score(core, X_train[best_features], y_train, cv=self.cv)
        scores_adj = scores_adj.mean()
        print("The Integrated Features will be: " + str(best_features))
        return best_features, scores_adj, outcome_score

    def _tune_model(self, model_name, X_train, y_train, best_features):
        param_grids = {
            'GradientBoost': {
                'n_estimators': [300, 500, 1000, 2000],
                'learning_rate': [0.01, 0.1],
                'max_depth': [3, 5, 7]
            },
            'XGBoost': {
                'n_estimators': [300, 500, 1000, 2000],
                'learning_rate': [0.01, 0.1],
                'max_depth': [3, 5, 7]
            },
            'LGBM': {
                'n_estimators': [300, 500, 1000, 2000],
                'learning_rate': [0.01, 0.1],
                'max_depth': [3, 5, 7]
            },
            'CatBoost': {
                'iterations': [300, 500, 1000, 2000],
                'learning_rate': [0.01, 0.1],
                'depth': [3, 5, 7]
            }
        }
        
        model_map = {
            'GradientBoost': GradientBoostingClassifier(random_state=42),
            'XGBoost': XGBClassifier(random_state=42),
            'LGBM': LGBMClassifier(verbose=-1, random_state=42),
            'CatBoost': CatBoostClassifier(verbose=False, random_state=42)
        }
        
        grid_search = GridSearchCV(
            estimator=model_map[model_name],
            param_grid=param_grids[model_name],
            cv=self.cv,
            scoring='roc_auc'
        )
        grid_search.fit(X_train[best_features], y_train)
        
        self.tuned_models[model_name] = {
            'model': grid_search.best_estimator_,
            'features': best_features,
            'score': grid_search.best_score_
        }

    def model_combinations(self):
        base_models = [
            ('GradientBoost', self.tuned_models['GradientBoost']['model']),
            ('XGBoost', self.tuned_models['XGBoost']['model']),
            ('LGBM', self.tuned_models['LGBM']['model']),
            ('CatBoost', self.tuned_models['CatBoost']['model'])
        ]
        all_combinations = []
        for r in range(1, len(base_models) + 1):
            combinations_r = combinations(base_models, r)
            all_combinations.extend(combinations_r)
        return all_combinations

    def stacking_model(self, base_models):
        feature_sets = [self.tuned_models[name]['features'] for name, _ in base_models]
        common_features = list(set.union(*[set(f) for f in feature_sets]))
        self.final_features = common_features
        meta_model = LogisticRegression(max_iter=1000000)
        stacker = StackingClassifier(
            estimators=base_models,
            final_estimator=meta_model,
            stack_method='predict_proba'
        )
        return stacker

    def execute_pipeline(self, X_train, X_test, y_train, y_test):
        core_model = LGBMClassifier(verbose=-1, random_state=42, n_estimators=1500)
        best_features, _, _ = self.model_rfe(core_model, X_train, y_train)
        print("...Tuning...")
        for model_name in ['GradientBoost', 'XGBoost', 'LGBM', 'CatBoost']:
            self._tune_model(model_name, X_train, y_train, best_features)
            print(f"{model_name} tuning success | CV AUC: {self.tuned_models[model_name]['score']:.4f}")

        best_auc = 0
        best_combination = None
        print("...Stacking...")
        for combination in tqdm(self.model_combinations()):
            list_combination = list(combination)
            stacker = self.stacking_model(list_combination)
            # print(stacker)
            train_proba = cross_val_predict(stacker, X_train[self.final_features], y_train, cv=self.cv, method='predict_proba')[:,1]
            current_auc = roc_auc_score(y_train, train_proba)
            
            if current_auc > best_auc:
                best_auc = current_auc
                best_combination = combination
                self.best_stacker = stacker
        
        print(f"Best Model Combination: {[name for name, _ in best_combination]}")
        print(f"Training AUC: {best_auc:.4f}")

        # train stacker
        self.best_stacker.fit(X_train[self.final_features], y_train)
        test_proba = self.best_stacker.predict_proba(X_test[self.final_features])[:,1]
        fpr, tpr, thresholds = roc_curve(y_test, test_proba)
        test_auc = roc_auc_score(y_test, test_proba)
        print(f"Test Dataset AUC: {test_auc:.4f}")
        return test_auc, fpr, tpr