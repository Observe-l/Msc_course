from collections import Counter
import socket
import time

import ray

print('''This cluster consists of
    {} nodes in total
    {} CPU resources in total
'''.format(len(ray.nodes()), ray.cluster_resources()['CPU']))

@ray.remote
def f():
    time.sleep(0.001)
    # Return IP address.
    return socket.gethostbyname(socket.gethostname())

object_ids = [f.options(resources={"Task_Vehicle": 4}).remote() for _ in range(600)]
test_ids = [f.options(resources={"Service_Vehicle": 4}).remote() for _ in range(600)]
object_ids += test_ids
ip_addresses = ray.get(object_ids)

print('Tasks executed')
for ip_address, num_tasks in Counter(ip_addresses).items():
    print('    {} tasks on {}'.format(num_tasks, ip_address))