```flow
st=>start: Starting Point
op1=>operation: Select neighbour node
op2=>operation: Set current node as working node
cond1=>condition: Is f the lowest cost?
cond2=>condition: Is current node at end point?
e=>end
st->op1->cond1
cond1(no)->op1
cond1(yes)->op2
op2->cond2
cond2(yes)->e
cond2(no)->op1
```











