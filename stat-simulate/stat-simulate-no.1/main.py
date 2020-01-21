"""
This programe is created for MATH1402 project 4: Ants and Triangles

authors: Yang Lin & Jinsheng Zhuang

"""
from math import *
import numpy as np
import matplotlib.pyplot as plt
import random

class Ant(object):
    """we define the ant as an object which will make the whole program more readable"""
    def __init__(self, x, y, angle):
        self.x = x
        self.y = y
        self.angle = angle
    def go(self, distance):
        """return the position after the ant working through the distance"""
        self.x = self.x + distance * cos(self.angle)
        self.y = self.y + distance * sin(self.angle)
        self.angle = self.angle
        return self
    
def below_side(ant, x, y):
    """test if the ant is going out from the hypotenuse"""
    """we compare the current position with two points on the line of hypotenuse, 
       one with same x coordinate and the other one with same y coordinate; if its y
       is larger than fisrt one or x is larger than second one, than it's outside the triangle"""
    if (ant.x > x - x * ant.y / y or ant.y > y - y * ant.x / x):
        return False
    else:
        return True

def exit_side(ant, x, y):
    """ input initial position and triangle """
    """ return the side that the ant exit """
    count = 0
    while( ant.x > 0 and ant.y > 0 and below_side(ant, x, y)):
        """the following line effects precision, greater precision makes the program running slower"""
        ant = ant.go(count*0.00001)  
        count += 1
    if (ant.y < 0):
        return 'x'
    elif (not below_side(ant, x, y)):
        return 'side'
    else:
        return 'y'

def random_ant(a, b):
    """ a and b are the two short sides of the triangle """
    """ return the initial position and direction of ant """
    x = random.uniform(0, a)
    y = random.uniform(0, b)
    angle = random.uniform(0, 360)
    ant = Ant(x, y, radians(angle))
    if below_side(ant, a, b):
        return ant, True
    else:
        return ant, False

def count_side(N, a, b):
    """ input the sample size N and two short sides of triangle,
        return number of times exit from each side"""
    count, count_x, count_y, count_side = 0, 0, 0, 0
    while (count < N):
        ant, legal_ant = random_ant(a, b)
        if (legal_ant):
            side = exit_side(ant, a, b)
            if (side == 'x'):
                count_x += 1
            elif (side == 'y'):
                count_y += 1
            elif (side == 'side'):
                count_side += 1
            count += 1
    return count_x, count_y, count_side

def read_data(file_name):
    """read in data, separate them in lists"""
    infile = open(file_name,'r')
    l=[]
    for line in infile:
        lloc=[]
        strlist=line.split()
        for i in range(len(strlist)):
            lloc.append(float(strlist[i]))
        l.append(lloc)
    infile.close()
    return l

def test_all_trg():
    """using the file 'triangle_triples.data' to calculate the probablity of
       exiting hypotenuse for each triangle in that file"""
    N = int(input("\nenter the sample size for each triangle: "))
    triangles = read_data('triangle_triples.data')
    prob_list = []
    print("loading...")
    for i in range(0, len(triangles)):
        x, y, side = count_side(N, triangles[i][0], triangles[i][1])
        prob = 100.0 * side / N
        prob_list.append(prob)
        if (max(prob_list) == prob):
            max_trig = [triangles[i][0], triangles[i][1], triangles[i][2]]
            max_prob = prob
        elif (min(prob_list) == prob):
            min_trig = [triangles[i][0], triangles[i][1], triangles[i][2]]
            min_prob = prob
    plotting(N, prob_list)
    print'Triangle with largest probability: %s'%(max_trig)
    print'p = %f %%'%(max_prob)
    print'Triangle with smallest probability: %s' %(min_trig)
    print'p = %f %%' %(min_prob)
    print'\n\nDone.'
            
def plotting(N, prob_list):
    """plotting the histogram for the probabilities"""
    prob_list = np.array(prob_list)
    n, bins, patches = plt.hist(prob_list, 20, normed=1, facecolor='green', alpha=0.75)
    plt.xlabel('Probability (%)')
    plt.ylabel('Density')
    plt.title('Histogram of Estimated Probabilities \nof Exiting through Hypotenuse ',fontweight='bold')
    plt.axis([min(prob_list) - 1, max(prob_list) + 1, 0, 0.45])
    plt.grid(True)
    plt.savefig("histogram.png", dpi = 800)
    plt.show()
    
def test_one(N):
    """this is for the task that we want to estimate the probability of exiting hypotenuse 
       of the triangle [3, 4, 5]"""
    print'loading...'
    x, y, side = count_side(N, 3, 4)
    print'exit through x-axis at: %d times' %(x)
    print'exit through y-axis at: %d times' %(y)
    print'exit through hypotenuse: %d  times' %(side)
    print'probability of exiting from hypotenuse:%f' %(float(side)/N)
    print'Done.'
    
def menu():
    """we make this function to 'talk' to user so that it makes the program easier to use
       and the user don't have to edit the program in order to run it"""
    print("\n project 4: Ants and Triangles ")
    choice = raw_input("enter a to test all triangles, enter o to test the 3/4/5 one: ")
    while ((choice == 'a') or (choice == 'o')):
        if (choice == 'a'):
            test_all_trg()
        if (choice == 'o'):
            N = int(input("\nenter the sample size for the triangle: "))
            test_one(N)
        choice = raw_input("enter a to test all triangles, enter o to test the 3/4/5 one, or enter q to quit: ")
    print'Done.'

"""the following line gathers everying together"""
menu()
