#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np # linear algebra
import pandas as pd # data processing
import matplotlib.pyplot as plt 
import seaborn as sns
#Read dataset
data = pd.read_csv('C:/Users/User/Desktop/Project/car_ad1.csv',encoding ='latin-1')
data.shape


# In[2]:


data.info()


# In[3]:


data.price[data.price ==0].count()


# In[4]:


data=data.drop(data[data.price <= 0 ].index) #Drop records where price is zero


# In[5]:


data.price[data.price ==0].count()


# In[6]:


data.shape #Get the shape of dataframe


# In[7]:


data.engV[data.engV >9].count()


# In[9]:


data=data.drop(data[data.engV >9].index) #Drop records where engV is zero


# In[10]:


data.engV[data.engV >9].count()


# In[11]:


data.shape


# In[12]:


data.isnull().sum() #Check null values in dataframe


# In[15]:


data.head() #Display first few records of dataframe


# In[16]:


data.mean() #Calculate Mean 


# In[18]:


data=data.fillna(data.mean()) #Replace missing values with Mean


# In[20]:


data.isnull().sum()


# In[21]:


data.head()


# In[22]:


data.drive.mode() #Calculate Mode


# In[23]:


data['drive'] = data['drive'].fillna(data['drive'].mode()[0]) #Replace missing values with Mode 


# In[24]:


data.isnull().sum()


# In[25]:


data.head()


# In[27]:


data.shape


# In[28]:


data_copy=data.copy() #Copy dataframe contents to another datframe
data_copy.head()


# In[29]:


data = pd.get_dummies(data) #One hot encode


# In[30]:


data.shape


# In[31]:


data.head() 


# In[32]:


sns.regplot(x='year',y='price',data=data) #Scatterplot of two variables with Regression line


# In[33]:


sns.regplot(x='mileage',y='price',data=data)


# In[34]:


sns.regplot(x='engV',y='price',data=data)


# In[36]:


data_copy=data.copy()
data_copy.head()


# In[37]:


from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error
from sklearn.metrics import mean_squared_error
from sklearn.metrics import r2_score
X = data.drop("price",axis=1)
y = data["price"]
#Split data set into train and test data sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)


# In[41]:


model = RandomForestRegressor(n_estimators=100,random_state=42) #Create Random Forest Regression model
model.fit(X_train, y_train) #Fit the model with train & test values
pred = model.predict(X_test) #Predict values
print ("R2_Score value is",model.score(X_test, y_test)*100) #Determine model accuracy


# In[42]:


from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import KFold # Import KFold
from sklearn.model_selection import train_test_split
X = data.drop("price",axis=1)
y = data["price"]
X = X.to_numpy() #Convert dataframe to NumPy array
y = y.to_numpy() #Convert dataframe to NumPy array
kf = KFold(n_splits=10,random_state=42) #Split into 10 folds 
for train_index, test_index in kf.split(X):
 #print(train_index,test_index)
 X_train, X_test = X[train_index], X[test_index]
 y_train, y_test = y[train_index], y[test_index]

model = RandomForestRegressor(n_estimators=100,random_state=42)
model.fit(X_train, y_train)
pred = model.predict(X_test)
print ("R2_Score value is",model.score(X_test, y_test)*100)


# In[43]:


plt.figure(figsize= (6, 6))
plt.title('Visualizing the Regression using Random Forest Regression algorithm')
sns.regplot(pred, y_test, color = 'teal')
plt.xlabel("New Predicted Price (Price)")
plt.ylabel("Old Price (Price)")
plt.show()


# In[ ]:




