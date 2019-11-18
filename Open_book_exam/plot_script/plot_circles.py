import matplotlib.pyplot as plt
import numpy as np

with open('circles_4.txt','r') as f:
    data = f.read()
data = data.split('\n')
data.pop()
data.pop()
x = [raw.split(',')[0] for raw in data]
y = [raw.split(',')[1] for raw in data]

print(len(x))
print(len(y))

plt.plot(x, y, 'r*')
plt.show()