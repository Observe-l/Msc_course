import simpy
import random
import math
import numpy as np
import pandas as pd

# Checkpointing optimization
phi = 0.05
mu = 0.05

# Fault arrival rate
lamda = 0.01
# k-fault-tolerant
k_fault=3

# Read task list from csv file
task_list = pd.read_csv("./Task.csv")

# Complete task, initial the metrix
task_complete = pd.DataFrame({'Status':[]},index=[])

# waitting time
task_waitting = pd.DataFrame({'delay':[]},index=[])

# Initial the ready list
Ready_L=pd.DataFrame({ 'C_i':[],
                       'D_i':[],
                       'AR_i':[],
                       'AD_i':[],
                       'U_i':[],
                       'exec_count':[],
                       'feasibility':[]},
                       index=[])
task_ID = 1
def Task_list(env, C, T, D, R):
    global Ready_L
    global task_ID
    task_num = 0
    while task_num<10:
        task_num += 1
        # Only first time shold add release time.
        if env.now == 0:
            yield env.timeout(R)
        
        # Absolute deadline, sum of R_i and D_i
        AD_i=D + env.now

        # Absolute release time
        AR_i=env.now

        # Utilization
        U_i=C/D

        # Add this task into list
        Ready_L.loc[task_ID,['C_i','D_i','AR_i','AD_i','U_i','exec_count','feasibility']]=[C,D,AR_i,AD_i,U_i,1,1]
        task_ID += 1
        
        yield env.timeout(T)

# CPU core replication
def CPU_core(env,res,busy_time,AD,task_ID,temp):
    global Ready_L
    global lamda
    global task_complete
    # Probability of no fault happened, possion count process, Pr{N(t)=0}
    prb=math.exp(-lamda*busy_time)
    # A random number between 0~1
    success_random = random.random()
    # TAG the CPU core is busy
    with res.request() as req:
        yield req
        # Busy within busy_time
        yield env.timeout(busy_time)
        # Detect whether other core have completed this task
        try:
            other_status = task_complete.loc[task_ID]['Status']
        except:
            other_status = False
        
        # If the random number smaller than Pr{N(t)=0}, there's no fault
        if success_random > prb and other_status == False:
            task_complete.loc[task_ID,['Status']]=False
        else:
            task_complete.loc[task_ID,['Status']]=True


# CPU core optimal checkpoint
def CPU_core_checkpoint(env,res,C,m,AD,task_ID):
    global lamda
    global task_complete
    global phi
    global mu
    global lamda
    # Getting/Saving a checkpoint
    Cs = phi * C
    # Recovering from a checkpoint
    Cr = mu * C
    # Task split to m+1 sub task
    time_slot = C/(m+1)
    # sub task number
    sub_task = 0
    # Probability of no fault happened in a time slot, possion count process, Pr{N(t)=0} or Pr{X>t}
    prb=math.exp(-lamda*time_slot)

    # Saving m checkpoints
    yield env.timeout(m*Cs)
    # TAG the CPU core is busy
    with res.request() as req:
        yield req
        while sub_task < m+1:
            # Busy within busy_time
            yield env.timeout(time_slot)
            # A random number between 0~1
            success_random = random.random()
            # If the random number smaller than Pr{N(t)=0}, there's no fault, go to next time slot
            if success_random < prb:
                sub_task += 1
            elif sub_task != 0:
                # Recover from last checkpoint, re-rxecute this time slot
                yield env.timeout(Cs+Cr)

    # Current time < AD_i, the task successful
    if env.now < AD:
        task_complete.loc[task_ID,['Status']]=True
    else:
        task_complete.loc[task_ID,['Status']]=False


# Calculate the worst-case response time of a task using
# checkpointing with rollback recovery (Cc)
# This function will return the time Cc and the number of the task
def get_checkpoint(C):
    global phi
    global mu
    global k_fault
    global lamda
    # Calculate k, upper bound
    k = math.ceil(k_fault*lamda*C)
    # Getting/Saving a checkpoint
    Cs = phi * C
    # Recovering from a checkpoint
    Cr = mu * C
    # Optimal number of checkpoint, upper bound
    m = math.ceil(( (k*C)/Cs ) ** 0.5 - 1)
    # Worst-case response time of a task
    Cc = (C+m*Cs) + k*(Cs+Cr) + (k*C)/(m+1)
    return Cc, m

# Calculate the threshold theta
def get_theta(delay,C,D):
    global phi
    global mu
    global k_fault
    global lamda
    # Calculate k
    k = k_fault*lamda*C
    # Getting/Saving a checkpoint
    Cs = phi * C
    # Recovering from a checkpoint
    Cr = mu * C
    # Optimal number of checkpoint
    m = round(( (k*C)/Cs ) ** 0.5 - 1)
    # numerator of theata
    num = 1 - delay/D
    # denominator of theta
    den = 1 + m*phi + k*(phi+mu) + k/(m+1)
    # Get the threshold
    theta = num/den
    return theta

def CH(env,res):
    global Ready_L
    global task_complete
    global task_waitting
    while True:
        # If ready list is not empty
        if Ready_L.shape[0] != 0:
            # Sort the task list accroading to the AD_i
            Ready_L=Ready_L.sort_values('AD_i')
            # If exists any idle core, res.count is the busy cpu count
            if res.count != 4:
                # This time
                RA_i=env.now
                # Schedule delay
                Delay_i=RA_i-Ready_L.iloc[0]['AR_i']
                # Save the schedule delay
                task_waitting.loc[Ready_L.iloc[0].name,['delay']] = Delay_i
                # If This time+C_i > AD_i
                if RA_i+Ready_L.iloc[0]['C_i'] > Ready_L.iloc[0]['AD_i']:
                    # Feasibility = false remove this task
                    Ready_L.iloc[0]['feasibility'] == 0
                    # Delete this task from ready list, add into complete list
                    task_complete.loc[Ready_L.iloc[0].name,['Status']]=False
                    Ready_L = Ready_L.drop(Ready_L.iloc[0].name)
                else:
                    # Apply chechpointing for the task
                    Cc,m = get_checkpoint(Ready_L.iloc[0]['C_i'])
                    # Delete this task from the ready list
                    temp = Ready_L.iloc[0]
                    Ready_L = Ready_L.drop(temp.name)
                    # One of the idle CPU busy within Cc_i
                    env.process(CPU_core_checkpoint(env,res,temp['C_i'],m,temp['AD_i'],temp.name))

        yield env.timeout(0.1)



                            


env = simpy.Environment()
# Quad-core
res = simpy.Resource(env, capacity=4)
for i in range(task_list.shape[0]):
    env.process(Task_list(env,task_list.iloc[i]['C_i'],task_list.iloc[i]['T_i'],task_list.iloc[i]['D_i'],task_list.iloc[i]['R_i']))
env.process(CH(env,res))
env.run(until=10000)
complete_task=task_complete['Status'].value_counts()[True]
ratio=complete_task/500
print("Completion ratio:",ratio*100,"%")
print("Average scheduling delay is:",task_waitting[['delay']].mean()['delay'])