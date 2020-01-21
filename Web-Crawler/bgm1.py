from bs4 import BeautifulSoup
import urllib
import pandas as pd
import re
from urllib.request import urlopen
import time
import random

def is_subj(href):
     return href and re.compile("subject").search(href) 

def get_score_stat(url):
    bangumi = urlopen(url).read()
    bans = BeautifulSoup(bangumi, 'html.parser')
    anime_part = bans.find_all(href=is_subj, class_= 'l')
    stat = []
    name = []
    lon = len(anime_part)
    time.sleep(random.randint(1,3))  # slow down
    for e in range(lon):
        uurl = 'https://bangumi.tv'+anime_part[e]['href']
        anime= urlopen(uurl).read()
        ani = BeautifulSoup(anime, 'html.parser')
        #mean = ani.find('span', property= 'v:average')
        #print(mean.string)
        scoring = ani.find_all('span',class_ = 'count' )
        #print(scoring)
        nums = []
        for i in range(len(scoring)):
            nums.append(scoring[i].string[1:-1])
        #print(anime)
        stat.append(nums)
        name.append(anime_part[e].string)
    return stat, name

def get_data(pages):
    stat = []
    name = []
    for i in range(1, pages):
        url = 'https://bangumi.tv/anime/browser?sort=rank&page='+ str(i)
        s, n = get_score_stat(url)
        stat += s
        name += n
    return stat, name

stat, name = get_data(3)

# rearrange statistics of ratings
scoring = []
for i in range(10):
    y = []
    lon = len(stat)
    for j in range(lon):
        y.append(stat[j][i])
    scoring.append(y)

columns = []
numb = 10
while numb > 0:
    columns.append('rating_' + str(numb))
    numb-=1
dat = dict(zip(columns,scoring))

data = pd.DataFrame(dat, index = name)
data.to_csv('bangumi.csv')
