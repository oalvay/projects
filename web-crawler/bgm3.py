from bs4 import BeautifulSoup
import requests, re, time
from multiprocessing import Pool

global base, filename, errorfile
base = 'http://mirror.bgm.rin.cat'
type_ = "anime"

def get_html(url):
    request = requests.get(url)
    while 502 <= request.status_code <= 503:
        time.sleep(2)
        request = requests.get(url)
    request.encoding = "UTF-8"
    if request.status_code != 200:
        print("url:", url, ", code:", request.status_code, request.reason)
    return request.status_code, request.reason, BeautifulSoup(request.text, "html.parser")

def get_user(user):
    """ user: str, user id
        return a list of bs4 Tags"""
    stats, reason, html = get_html(base + f"/user/{user}")
    #print("id:", user, ", code:", stats, reason)
    html = html.find("div", id=type_)
    if html is None:
        return []
    else:
        return html.findAll("a", href = \
                re.compile(f"/{type_}/list/.*/(wish|collect|on_hold|dropped|do)"))

def get_info(item, status):
    """ item: bs4 Tags, status: str
        return anime id, status, date to watch, rate, comment"""
    info_list = [
        item.get("id")[5:], # anime id
        status, 
        item.find("span", class_ = "tip_j").get_text(), # date to watch
        item.find("span", class_ = re.compile("^starlight stars\d+$")), # rate
        item.find("span", class_ = "tip"), # tag
        item.find("div", class_ = "text"), # comment
    ]
    info_list[4] = info_list[4].get_text()[5:] if info_list[4] is not None else " "
    info_list[5] = info_list[5].get_text() if info_list[5] is not None else " "
    info_list[3] = info_list[3].get("class")[1][5:] if info_list[3] is not None else "0"
    return info_list

def process_user(user):
    try:
        for i in get_user(user):
            html, page = "start", 1
            while html:
                url = base+i.get("href") # url+f"?page={page}"
                status = i.get("href").split("/")[-1]
                stats, reason, html = get_html(url+f"?page={page}")
                html = html.find('ul', id = 'browserItemList').findAll("li",\
                                                                re.compile("^item (odd|even) clearit$"))
                for item in html:
                    with open(filename, "a") as f:
                        f.write("\t".join([str(user)] + get_info(item, status))+"\n")

                page += 1
    except AttributeError:
        with open(errorfile, "a") as f:
            f.write(url+f"?page={page}"+"\n")
    except Exception as e:
        print(user, e)
        time.sleep(1200)
        process_user(user)
            
filename = "bgm_anime.csv"
errorfile = "bgm_error.txt"

with open(filename, "w") as f:
    f.write("\t".join(['user_id', 'subject_id', 'status',
                   'date', 'rate', 'tag' ,'comment'])+"\n")
with open(errorfile, "w") as f:
    f.write("ok\n")

start = time.time()
    
with Pool(8) as p:
        p.map(process_user, range(1, 574600))
duration = time.time() - start
print("time used:", duration)