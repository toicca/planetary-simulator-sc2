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
obj_names=sorted(obj_names)

#Reading the results and sorting them first by name and then by index (time)
sim_results=pd.read_csv("../run/output.dat")
sim_results["indCol"]=sim_results.index
sim_results=sim_results.sort_values(["Object","indCol"])

#Number of iterations
iters=int((sim_results.count()/obj_count)["indCol"])

#Visualization initialization
fig=plt.figure()
ax=p3.Axes3D(fig)
ax.set_xlim3d([sim_results["X"].min(),sim_results["X"].max()])
ax.set_xlabel("X")
ax.set_ylim3d([sim_results["Y"].min(),sim_results["Y"].max()])
ax.set_ylabel("Y")
ax.set_zlim3d([sim_results["Z"].min(),sim_results["Z"].max()])
ax.set_zlabel("Z")
ax.set_title("SC2 Planetary Motion Simulation")
ax.view_init(40,10)

#Initial locations
scatters= [ax.scatter(sim_results["X"].iloc[i*iters],sim_results["Y"].iloc[i*iters],sim_results["Z"].iloc[i*iters],label=str(obj_names[i])) for i in range(obj_count)]

#Change of location with each iteration
def animate_scatters(iteration, data, scatters):
    for i in range(obj_count):
        scatters[i]._offsets3d = ([data["X"].iloc[i*iters+iteration]],
                                    [data["Y"].iloc[i*iters+iteration]],
                                    [data["Z"].iloc[i*iters+iteration]])
    return scatters

#Animation
ani=animation.FuncAnimation(fig,animate_scatters,iters,fargs=(sim_results,scatters),interval=10,blit=False,repeat=False)

#Option for saving the animation.
#ani.save('../run/animation.mp4', fps=30, extra_args=['-vcodec', 'libx264'])

#Drawing the animation
plt.legend()
plt.show()
