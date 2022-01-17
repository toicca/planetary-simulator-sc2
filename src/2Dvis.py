import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3
import matplotlib.animation as animation

#Reading the input instructions and names of the objects.
obj_names=[]
f = open("../run/input.dat","r")
obj_count=int(f.readline())
for obj in range(obj_count):
    obj_names.append(f.readline().split()[0])
obj_names=sorted(obj_names)

step=float(f.readline())
sim_length=float(f.readline())
step_count=float(f.readline())
if step==0:
    step=sim_length/step_count
elif sim_length==0:
    sim_length=step*step_count
else:
    step_count=sim_length/step
f.close()

#Reading the results and sorting them first by name and then by index (time)
sim_results=pd.read_csv("../run/output.dat")
sim_results["indCol"]=sim_results.index
sim_results=sim_results.sort_values(["Object","indCol"])

#Number of iterations
iters=int((sim_results.count()/obj_count)["indCol"])

#Visualization initialization. Title is added separately, and lims and ticks are changed as needed.
fig, ax = plt.subplots()
ax.set_xlabel("X [meters]")
ax.set_ylabel("Y [meters]")
#ax.set_xlim(-3e11,3e11)
#ax.set_ylim(-3e11,3e11)
#ax.set_xticks(np.arange(0,10e9,step=1e9))
#ax.set_yticks(np.arange(0,10e9,step=1e9))

#Place a text box in upper left in axes coords
textstr = f'Time: {sim_length} days'
props = dict(boxstyle='round', facecolor='wheat', alpha=0.5)
ax.text(0.05, 0.95, textstr, transform=ax.transAxes, fontsize=14,
        verticalalignment='top', bbox=props)

#Paths of the objects
plot= [ax.plot(sim_results["X"][i*iters:i*iters+iters],sim_results["Y"][i*iters:i*iters+iters],label=obj_names[i]) for i in range(obj_count)]

#Initial and final markers
scatters_init=[ax.scatter(sim_results["X"].iloc[i*iters],sim_results["Y"].iloc[i*iters],s=25,marker="x") for i in range(obj_count)]
scatter_final=[ax.scatter(sim_results["X"].iloc[i*iters+iters-1],sim_results["Y"].iloc[i*iters+iters-1],s=25,marker="v") for i in range(obj_count)]

#Display
#plt.legend()
plt.show()