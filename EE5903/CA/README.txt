There are three programm. Two of them are algorithm implementation one is dataset generation program.
DFTS.py, Dynamic fault-tolerant scheduling algorithm
CH.py, Checkpointing with roll back recovery algorithm
task_generate.py, Generate the dataset

How to running the program:
1. Running task_generate.py to generate dataset.
You can modify the data range following the comments.
You can change: C_i, D_i, T_i, R_i in this programs.
This program will generate a .csv file which will be used in other two programs
2. Running the DFTS.py, CH.py directly to get the results
You can modify phi, mu, lamda in this program
These program will output the completion ratio and scheduling dealy in terminal
