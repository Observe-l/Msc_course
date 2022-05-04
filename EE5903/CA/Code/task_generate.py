import numpy as np
import pandas as pd

# Excution time, uniform distribution between 10~100
C_i = np.random.uniform(10,100,50)
# Release time, uniform distribution between 0~5500
R_i = np.random.uniform(0,5500,50)
# Dead line, uniform distribution between 2*C_i ~ 3*C_i
D_i = np.random.uniform(2*C_i,3*C_i,50)
# Inter-arrival time, task deadlines are equal to their periods
T_i=D_i
# Task list
task_list=pd.DataFrame({  'C_i':C_i,
                          'D_i':D_i,
                          'T_i':T_i,
                          'R_i':R_i})
task_list.to_csv("./Task.csv",index=False)

print(task_list.shape[0])
