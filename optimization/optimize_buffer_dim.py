import matplotlib.pyplot as plt
import numpy as np
import statistics

#function to learn open/cloe time and sample write time from a file
def getTimes(fileName):
    time=[]
    temp=0

    for line in open(fileName,"r"):
        values=line.split(",")
        values[0]=int(values[0])
        if (values[0]-temp>50):
            time.append(values[0]-temp)
        temp=values[0]

    time.pop(0)
    print("FILE: "+fileName)
    setup_time=time[0]
    print("setup+oc+buf*w= "+str(time[0]))
    time.pop(0)
    average=statistics.mean(time)
    print("setup+oc+buf*w= "+str(average))
    print("\n")

    return setup_time, average

#file with buffer dimension 100
f101_oc, f101_avg= getTimes("LOG101.CSV")
#file with buffer dimension 200
f200_oc, f200_avg = getTimes("LOG200.CSV")

#solve system of equations to define:
#    oc = open/close time
#    w = single line write time
A=np.array([[1,100],[1,200]])
b=np.array([f101_avg, f200_avg])

oc,w=np.linalg.solve(A,b)
print (oc,w)

buffer_dim = np.arange(0., 200., 1)

values=[]
for v in buffer_dim:
    values.append(oc/v+w*v)

#plot cost function
plt.plot(values)
plt.title("Buffer dimension optimization")
plt.xlabel('Buffer dimension [number of elements]')
plt.ylabel('Time cost [s]')
plt.axis([0, 200, 0, .3])
plt.show()

#find the dimension of buffer and the overall time cost
x=values.index(min(values))
y=min(values)

print(x,y)
