import random
import pymysql
import pandas as pd
import time

time_start = time.time()
conn = pymysql.connect(host='localhost',user='VEC',passwd='666888',database='utilization')
# conn = sqlite3.connect("/home/lwh/nfsroot/Taskoffload.db")
c = conn.cursor()

per = random.uniform(0,100)
sql = "UPDATE CPU set persentage = %s where ID = 1"
time_start = time.time()
c.execute(sql, (per))
# c.execute("INSERT INTO vehicle (ID, v, angle, x, y) VALUES ('left_0', 35.8, 90, 265.4, 102.9)")
# c.execute("DELETE from vehicle where ID in (4,5,6,7,8)")
# c.execute("UPDATE vehicle set (v,angle,x,y) = (%s,%s,%s,%s) where ID = %s",(16, 270, 512 , 365,'left_0'))
# c.execute("REPLACE into vehicle (ID,v,angle,x,y) values (%s,%s,%s,%s,%s)",('test',16, 270, 512 , 365))
# c.execute("DELETE from vehicle where ID in ('left_0','left_1','right_2','right_3')")
# c.execute("DELETE from vehicle where ID = 'left_0'")
# c.execute("insert into vehicle (ID,v,angle,x,y,status) values (%s,%s,%s,%s,%s,%s) on duplicate key update v = %s",('right_99',15, 60,12,13,'run',20))


conn.commit()
time_end = time.time()
total_time = time_end - time_start
print("Total time is:", total_time)

conn.close()
print ("Close database")