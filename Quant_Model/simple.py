import numpy as np

T=1000    # total invest value
N=50      # times of investments 

# parameters for function
beta = 10  # inital value
#alpha = 0.6 # max fluction
lamda = T/N
period = np.pi
bias = 0
#s = 0 # total gain

def price(t, beta,alpha,period,bias):
    return alpha*beta*np.sin(period/N*t+bias) + beta

def y(t):
    return lamda*(price(N,beta,alpha,period,bias)/price(t, beta, alpha,period,bias)-1)

def gain():
    s = 0
    for i in range(N):
        s = s + y(i)
    return s

for i in range(50):
    alpha=i/50
    print(alpha, gain()/T)

#print("total gain is: ", s)
#print("total gain percentage is: ", s/T)