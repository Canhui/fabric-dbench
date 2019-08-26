## Chapter 10

Page 221

人工神经网络的介绍和计算。



## Chapter 12

设备和服务器上的分布式Tensorflow

Page 278



## Chapter 14

RNN 循环神经网络

Page 307




## Chapter 15

自编码器是能够在无监督的情况下学习输入数据的有效表示的人工神经网络。

Page 332



## Chapter 16

强化学习

Page 352



## 1. Keras (self-define tensorflow) Outline
Sequential 


```python
model.compile(loss="sparse_categorical_crossentropy",
              optimizer="sgd",
              metrics=["accuracy"])
```

TF.fit is like train in pytorch


#### 1.1.   Call() is like forward()

call() is like forward(): propagation forward



What is the meaning of the Model: "sequential"?



#### 1.2. TF.keras eager

what is TF.keras eager()?




#### 1.3. Tensorboard (Use tensorboard to see the whole progress)

show the progress of the whole tensorboard

show the distribution of results?

show the feature mappes?

what is the tensorboard()?

Callbacks.Tensorboard v.s. Customized Tensorboard



#### 1.4. Keras example

Use Keras to train a model, see Chapter 4.

what is model.fit()?

what is the subclassing() API?




#### 1.5. keras.models.Sequential

what is keras.models.sequential?






## 2. Preview: Customizing Models and Training Algorithms

Similar to NumPy, with GPU support

AutoDiff and optimizer

Usage like NumPy




#### 2.1. Loss Function

Huber Loss (see blog)

Keras.models.load_model(custom_objects=create_huber)

Keras.loss() function

Chapter 12


#### 2.2. Metrics

Customize our own metric class



#### 2.3. Bias

why we need bias?

what is tensor?


#### 2.4. Residual Block

Here we need to know what is the residual block? in python


#### 2.5. Keras.Model

implement the Keras.Model

losses and metrics based on MOdel internals

Keras.model

Keras.build functions to implement the Keras.Model



#### 2.6. AutoDiff(), Autograph, and Tracing

Here we need AutoDiff(), Autograph(), and Tracing


What is the epoch?

WHat is the iteration?

what is the iterations per epoch?



#### 2.7. Callback()

Question: Personal implementation of Java Callback()

Java Callback() Blog 1: https://www.cnblogs.com/dong-liu/p/7476955.html

Java Callback() Blog 2: https://www.cnblogs.com/sunfie/p/5259340.html

Blog 3: https://blog.csdn.net/fjseryi/article/details/50473756


Observer Design Mode and Callback()








## Juan Ji

Juan ji sum -> parameters


https://blog.csdn.net/crazyeden/article/details/79156020


## Pooling

Motivation of pooling



## Python partial()

http://www.imooc.com/article/255115


## Batch vs. shuffle

batch shuffle


## mean Average Precision

More about precision


why transport converlution will become bigger?

see more https://blog.csdn.net/kekong0713/article/details/68941498




## RNN

encoder decoder

https://www.sohu.com/a/155746637_505915

Elman network

lian si fa ze


#### Clip gradient


#### LSTM

About language model: LSTM



#### Soft max

https://www.cnblogs.com/zongfa/p/8971213.html



#### RNN 

Bitcoin Price: based on time sequence

shi jian xu lie!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

https://blog.csdn.net/zhxchstc/article/details/79261617

duo ge RNN


#### Prediction (application)

Use RNN to predict ten timestamps of a time point

https://blog.csdn.net/omnispace/article/details/78151102


#### GRU

predict new word given a string of words

Char-RNN
















