## Chapter One

Pipeline of machine learning project, with a focus on data preprocessing, e.g., splitting the data set, missing data, how to handle numerical data and categorical data (one-hot coding).

安装jupyter notebook读取Github官方项目。





#### 1.1. 监督学习
在监督学习中，用来训练算法的训练数据中包含了答案，称为标签。

K近邻算法
线性回归
逻辑回归
支持向量机SVM
决策树和随机森林
神经网络


#### 1.2. 非/无监督学习

在无监督学习中，训练数据是没有标签的。

- 聚类
K均值
层次聚类分析
期望最大值

- 可视化和降维
主成份分析
核主成分分析
局部线性嵌入
t-分布邻域嵌入算法

- 关联性规则学习
Apriori算法
Ecalat算法





#### 1.3. 半监督学习

一些算法可以处理部分带标签的训练数据，通常是大量不带标签的数据加上少量带标签的数据。多数半监督学习算法是监督和无监督算法的结合。


#### 1.4. 强化学习

强化学习非常不同，学习系统在这里被称为智能体，可以从环境进行观察，选择和执行动作，获得奖励和惩罚。


#### 1.5. 批量和在线学习

另一个用来分类及其学习的准则是，机器学习能够从导入的数据流进行持续学习。



#### 1.6. 基于实例/基于模型学习
另一种分类及其学习的方法是判断他们是如何进行归纳推广的。





<br />
<br />

## Chapter Two

RMSE 和 MAE 都是测量预测值和目标值两个向量距离的方法。


加州湾区房价分析的一个例子。


<br />
<br />

## Chapter Three

第三节，我们的注意力转移到分类任务上。我们将会使用MNIST这个数据集，它有着70000张规格较小的手写数字图片。











<br />
<br />

## Chapter Four

GD, SGD等训练收敛模型









<br />
<br />


## 参考资料
[1. Github官方项目] https://github.com/ageron/handson-ml



## 1. Outline

Preview

Discover Data

Data Processing

MOdel TRaining

hyper tuning


#### 1.1. Preview

Problem Analysis



#### 1.2. Discover Data and Data Visualization

Data Dimension and Data TYpe

Kaggle Datasets

Quandl




## 2. Show Codes: Population and House Price

Objects: Your task is to predict median house values in Californian districts.

**Inputs**

longitude   latitude    housing_median_age  total_rooms     total_bedrooms  population  households  median_income   median_house_value  ocean_proximity

**Output predicion** 

medium house price



#### 2.1. Basic Information

Count
Data type
COunt of different categories
Mean, Std, Min, Max, etc

Further Describes on "ocean_proximity": 

INLAND        6551
NEAR OCEAN    2658
NEAR BAY      2290
ISLAND           5

One Attribute Distribution

More slices, not only one integrated data. For real world applications, we hava more data slicing, ensuring that high scalability is enabled.

Training dataset and Testing dataset: np.random.seed(42)

-->: Here we can create our own dataset

Goal: Same Distribution with test dataset and training dataset.





Two Attributes Correlations:

Correlations between multi attributes. In this case, we care about linear correlationship.





#### 2.2. Data Preprocessing

Data Preprocessing Missing Data Processing

Delete, Zero, mean data and etc.

```python
from sklearn.impute import SimpleImputer
imputer = SimpleImputer(strategy="median")
```
After filling data, the mean value of the original data is same to the mean value of the filled data.



#### 2.3. One Hot for language model

"ocean_proximity": near, medium, far

Method1: 1, 2, 3, 4, 5 dimensions


Method2: One Hot

class 1: 10000 vector
class 2: 01000 vector
class 3: 00100 vector
class 4: 00010 vector
class 5: 00001 vector

Distance between each other

Question: what is the difference between Method1 and Method2.


#### 2.4. Add New Attributes

Let's create a custom transformer to add extra attributes, static results between static attributes,

```python
from sklearn.base import BaseEstimator, TransformerMixin

# column index
rooms_ix, bedrooms_ix, population_ix, households_ix = 3, 4, 5, 6

class CombinedAttributesAdder(BaseEstimator, TransformerMixin):
    def __init__(self, add_bedrooms_per_room = True): # no *args or **kargs
        self.add_bedrooms_per_room = add_bedrooms_per_room
    def fit(self, X, y=None):
        return self  # nothing else to do
    def transform(self, X, y=None):
        rooms_per_household = X[:, rooms_ix] / X[:, households_ix]
        population_per_household = X[:, population_ix] / X[:, households_ix]
        if self.add_bedrooms_per_room:
            bedrooms_per_room = X[:, bedrooms_ix] / X[:, rooms_ix]
            return np.c_[X, rooms_per_household, population_per_household,
                         bedrooms_per_room]
        else:
            return np.c_[X, rooms_per_household, population_per_household]

attr_adder = CombinedAttributesAdder(add_bedrooms_per_room=False)
housing_extra_attribs = attr_adder.transform(housing.values)
```

#### 2.5. Pipeline the data processing process

Now let's build a pipeline for preprocessing the numerical attributes

```python
from sklearn.pipeline import Pipeline
```

Question: how to pipeline the data processing?




#### 2.6. Data Normalization

Method1: Min-Max scaling
Method2: Data Distribution -> Standard Normal Distribution: 

0 1 2 3 1 3 1 4 3 1000000 -> (Method1: Min-Max)
0 1 2 3 1 3 1 4 3 1000000 -> (Method2: Standardization)





## 3. Model Training



#### 3.1. Model Selection

LInear regression
Decision tree regression
random forest 


MOdel selection: 

A model is good or bad? MSE, mean square error, mean absolute error

RMSE = sqrt(MSE)


Zero error => Over Fitting



#### 3.2. Cross validation

Object: Mean square error

K-fold: 10 pieces, train for each piece

Eventually, choose the best parameter for the model



## 4. Tuning HYper-parameter 

MOdel training parameters for the search space

Search different model for hyper-parameters:
* Grid search
* random search

Ensemble methods:
* Gather all models to solve a problem

Question: include both model parameters and data parameters? or only model parameter? or only data parameter?

Analyze the model:
feature importance

Evaluation on Test set:
confidence interval of error distribution



## --------------------------xin---------------------------------------------

## 5. Chapter-3-Classification

Binary Classifier

Multiple Classifier



#### 5.1. Cross Validation Iterators

KFold
ShuffleSplit
Stratified

```python
from sklearn.model_selection import StratifiedKFold
from sklearn.base import clone

skfolds = StratifiedKFold(n_splits=3, random_state=42)

for train_index, test_index in skfolds.split(X_train, y_train_5):
    clone_clf = clone(sgd_clf)
    X_train_folds = X_train[train_index]
    y_train_folds = y_train_5[train_index]
    X_test_fold = X_train[test_index]
    y_test_fold = y_train_5[test_index]

    clone_clf.fit(X_train_folds, y_train_folds)
    y_pred = clone_clf.predict(X_test_fold)
    n_correct = sum(y_pred == y_test_fold)
    print(n_correct / len(y_pred))
```

#### 5.2. Terminology
TP 
FP
TN
FN

Cat & Dog recognition

Preceision = TP / (TP + FP) 
Recall = TP / (TP + FN)
Selectivity = TN / (TN + FP)

```python
Saving figure precision_recall_vs_threshold_plot
```

Precision and Recall: is a tradeoff (so therefore, there is a threshold)



#### 5.3 RoC

no need human threshold

Assume you have a score,

Question: why we do not need threshold?




#### 5.4 Multi Classification

KNN 
SVM
decision tree



## --------------------------tony---------------------------------------------

## 6. Training Models

Linear Regression MOdel

Ploynomial Regression MOdel

Regularized LInear Model

Softmax Regression MOdel

Question: Softmax regression?




## 6.1. SVD vs. eigen values 

Closed-form solution



## 6.2 gradient based

conditions:

convex
lipschitz continuity

Question: what is convex definition?

Question: lipschitz continuity, ke wei? ke dao? lian xu?



## Chapter 7 – Ensemble Learning and Random Forests

