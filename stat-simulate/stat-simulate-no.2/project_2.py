#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun  4 11:58:34 2019

@author: aofnev

This code is for the part in project 2 where it asked to perform
a computer simulation of the model on a 2D lattice described section 4.2 
in the paper (KephartWhite1991.pdf)
"""

import matplotlib.pyplot as plt
from matplotlib import colors
import numpy as np
from scipy.ndimage import convolve
from random import choices

# init start

#data = np.random.randint(2, size = (10, 10))
kernel = np.array([[1, 1, 1],
       [1, 0, 1],
       [1, 1, 1]])
kernel1 = np.array([[1, 1, 1, 1, 1],
       [1, 1, 1, 1, 1], 
       [1, 1, 0, 1, 1],
       [1, 1, 1, 1, 1],
       [1, 1, 1, 1, 1],])
kernel2 = np.array([[0, 1, 0],
       [1, 0, 1],
       [0, 1, 0]])

#infect_rate = 1.0
#cure_rate = 0.2

cmap = colors.ListedColormap(['white', 'black'])
bounds = [0,0.5,1]
norm = colors.BoundaryNorm(bounds, cmap.N)

# init end

def state_plot(data):
    
    fig, ax = plt.subplots()
    ax.imshow(data, cmap=cmap, norm=norm)

    # draw gridlines
    #ax.grid(which='major', axis='both', linestyle='-', color='k', linewidth=2)
    #ax.set_xticks(np.arange(0,3));
    #ax.set_yticks(np.arange(0,3));

    plt.show()


def infection(rate, data, grand_rate):
    p = grand_rate / (8 * rate) # average probability of an edge being included, 8 for 8 neightbours
    l = len(data)
    prob_array =  (1 - rate) ** (convolve(data, kernel, mode='constant')*p)
    #print(prob_array)
    for i in range(l):
        for j in range(l):
            if data[i, j] == 0:  
                data[i, j] = choices((0, 1), (prob_array[i, j], 1 - prob_array[i, j]))[0]
    return data
            
def cure(rate, data):
    l = len(data)
    fall_rate = 1 - rate
    for i in range(l):
        for j in range(l):
            if data[i, j] != 0: 
                data[i, j] = choices((0, 1), (rate, fall_rate))[0]
    return data
#print(infection(data))


def iteration(data, infect_rate, cure_rate, grand_rate):
    data = infection(infect_rate, data, grand_rate)
    #state_plot(data)
    data = cure(cure_rate, data)
    #state_plot(data)
    
def new_game(N):
    data = np.zeros((N,N))
    data[int(N/2), int(N/2)] = 1
    return data


def ntime(m, data, infect_rate, cure_rate, grand_rate):
    n = 1
    while n < m:
        iteration(data,infect_rate, cure_rate, grand_rate)
        n += 1
    state_plot(data)
    
ntime(50, new_game(101), 0.7, 0.2, 1)
