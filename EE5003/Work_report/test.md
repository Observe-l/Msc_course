

```mermaid
graph LR
A(Create task vehicle) --> B(input vehicle's number, comupting resource)
A --> C(generate totla task number)
C --> D(generate parameter)
D --> E(sent tasks to different service vehicle)
```

```mermaid
graph TD
A(Parameter) --> B(Data size)
A --> C(Computation size)
A --> D(Tolerable delay)
A --> E(Unit price)
```

```flow
st=>start: Creat Service vehical
op1=>operation: Allocate task
cond=>condition: Is this a service vehicle?
op2=>operation: Task process
op3=>operation: Caculate reliability etc.
e=>end: Return parameter
st->op1->cond->op2->op3
cond(yes)->op2->op3->e
cond(no)->op1
```

```mermaid
graph LR
A(Parameter) --> B(Relibility)
A --> C(Utility of service vehicle)
A --> D(Delay time)
```

![image-20210916144050859](/home/lwh/.config/Typora/typora-user-images/image-20210916144050859.png)