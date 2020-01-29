#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jun  9 16:33:37 2019

@author: aofnev
"""

from bs4 import BeautifulSoup
import urllib
import requests
import pandas as pd
import re
from urllib.request import urlopen
import time
import random

url = 'http://mirror.bgm.rin.cat/subject/263750/doings'
    
def one_user(users):
    time.sleep(random.randint(1,3) / 10)
    users_id = users.find('a', class_ = 'avatar').get('href')
    users_comment_time = users.find('p', class_ = 'info').get_text()
#print(users_comment_time)
    users_rate = users.find_all('span', class_ = 'starstop')
    if len(users_rate) != 0:
        users_rate = int(users_rate[0].get('class')[0][5:])
    else:
        users_rate = None
#print(users_id)
    users_url = 'http://mirror.bgm.rin.cat' + users_id
    print(users_id)
    users_url = requests.get(users_url)
    print(users_rate)
    users_url.encoding = "UTF-8"
    users_url = users_url.text
    bans_users = BeautifulSoup(users_url, 'html.parser') 
    join_time = bans_users.find('span', class_ = 'tip').get_text()[:-3]
    no_watched = bans_users.find('a', href = re.compile('/anime/list/' + users_id[6:] + '/collect'))
    if no_watched != None:
        no_watched = int(no_watched.get_text()[:-3])
    else:
        no_watched = 0
    print(no_watched)
    return [users_id[6:], users_comment_time, users_rate, join_time, no_watched]


def one_page(url):
    l = []
    bangumi = requests.get(url)
    bangumi.encoding = "UTF-8"
    bangumi = bangumi.text
    bans = BeautifulSoup(bangumi, 'html.parser') 
    users = bans.find_all('div', class_= 'userContainer')
    for i in range(len(users)):
        l.append(one_user(users[i]))
    return l
# =============================================================================
# url = 'https://bangumi.tv/user/444751'
# bangumi = urlopen(url).read()
# bans = BeautifulSoup(bangumi, 'html.parser') 
# no_watched = bans.find('a', href = re.compile('/collect'))
# print(no_watched)
# =============================================================================
#print(one_page(url))

def one_anime(url):
    l = []
    bangumi = requests.get(url)
    bangumi.encoding = "UTF-8"
    bangumi = bangumi.text
    bans = BeautifulSoup(bangumi, 'html.parser') 
    pages = int(bans.find('span', class_= 'p_edge').get_text()[2:-2].split('/')[1][1:])
    for i in range(pages):
        print(i + 1)
        l += one_page(url + '?page=' + str(i + 1))
    return l

giant = one_anime(url)

#giant = one_page(url)
df = pd.DataFrame(giant, columns = ['uid', 'comment_time', 'rate', 'join_time', 'watched'])

df.to_csv('bgm_giant.csv', index = False)
