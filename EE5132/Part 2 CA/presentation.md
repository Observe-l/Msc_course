### Page 1

Thanks Jun xian, I'm Liu Weihao. Nitin and me implement the algorithm. We select two algorithm to research: TL-LEACH and Improvised TL-LEACH. I'm in charge of TL-LECH. 

### Page 2

All the parameters in the simulation is default, as it's shown on this table. Just note in TL-LEACH, the percentage of SCH is 20.

To improve our simulation time, we commented out the map plotting part, which improve our simulation efficiently significantly!

### Page 3

As Junxian mentioned, TL-LEACH has two clusters head level. PCH and SCH. We use the same formula to select CH. LHS is our implementation flow chart. there are four phases.

 First is **advertisement phase**, we will select 10% nodes as PCH and then 20% as SCH from remaining pool. These two progress are independently,  The cluster head can be selected as different types of cluster head in the next round.

In the setup phase, the nodes will find the nearest SCH or PCH to form the cluster. Unlike theory, we don't have TDMA phase, so after setup phase, we will transmit the data directly. 

### Page 4

Besides, because the TL-LEACH paper doesn't provide the exactly ratio, we also research the impact of different percentage of SCH on the energy dissipation. In this figure, the percentage of PCH is fixed at 10% and we vary the ratio of SCH from 0 to 100%. It's clear that, the optimal point is 25%.  That's because if the SCH more than optimal point, the distance between common node and cluster head dose decrease significantly. If it less than 25%, some node may communicate with PCH directly.

### Page 5

We also try to change the percentage of PCH to see the different between LEACH and TL-LEACH. every point on this figure corresponding to the last figures optimal point. We can see that percentage bigger than 20% LEACH and TL-LEACH have almost same energy dissipation, when p less than 0.15, TL-LEACH could save about 10% energy. That's because if percent of PCH is large,  common nodes is more likely communicate with PCH directly. That's same as LEACH actually. So, we select primary cluster head 10% , SCH 20% in the next comparison.

That's all of my part, next silds pass to my Nitin.