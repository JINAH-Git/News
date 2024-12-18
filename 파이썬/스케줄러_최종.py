from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import time
from apscheduler.schedulers.background import BackgroundScheduler
from bs4 import BeautifulSoup
import gc
import dbmanager as db
from datetime import datetime, timedelta

dbms = db.DBManager()

#크롬 브라우저 옵션 설정
def web_driver():
    options = webdriver.ChromeOptions()
    user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    options.add_argument(f"user-agent={user_agent}")
    options.add_argument("headless")  
    driver = webdriver.Chrome(service = Service(ChromeDriverManager().install()), options=options)
    return driver

def _R(data):
    data = data.replace("'","''")
    return data

def GetDate(date):
    if len(date) == 19:
        if date[12:14] == '오후':
            chour = int(date[15:16]) + 12
        else:
            chour = date[15:16]
        year    = date[0:4]
        month   = date[5:7]
        day     = date[8:10]
        minute  = date[17:]
        date = ('%s-%s-%s %s:%s:00') % (year,month,day,chour,minute)
        return date
    elif len(date) == 20:
        if date[12:14] == '오후' and int(date[15:17]) != 12:
            chour = int(date[15:17]) + 12
        elif date[12:14] == '오전' and int(date[15:17]) == 12:
            chour = 00
        else:
            chour = date[15:17]
        year    = date[0:4]
        month   = date[5:7]
        day     = date[8:10]
        minute  = date[18:]
        date = ('%s-%s-%s %s:%s:00') % (year,month,day,chour,minute)  
        return date
    elif len(date) == 25:
        if date[17:19] == '오후' and int(date[20:22]) != 12:
            chour = int(date[20:22]) + 12
        elif date[17:19] == '오전' and int(date[20:22]) == 12:
            chour = 00
        else:
            chour = int(date[20:22])
        year    = date[5:9]
        month   = date[10:12]
        day     = date[13:15]
        minute  = date[23:]
        date = ('%s-%s-%s %s:%s:00') % (year,month,day,chour,minute)  
        return date
    
def crawl_category(driver, code1, sid2_categories):
    if dbms.DBOpen("192.168.0.27", "news", "root", "ezen") == False:
        print("Error")
        return
    else:
        print("OK")
        driver = web_driver()
        data_list = []
        for number in sid2_categories:
            links_list = []
            code2 = number
            wdate = time.strftime("%Y%m%d")
            url = DatePage(code1, code2, wdate, 1000)
            try: 
                driver.get(url)
                time.sleep(3)
            except Exception as e:
                print(f"Error loading URL {url}: {e}")
                continue
            # 웹에서 html 소스 가져오기
            newsurl = driver.page_source
            # 하위 카테고리 안에서 href 불러오기
            soup = BeautifulSoup(newsurl, "html.parser")
            # id main_content html 가져오기
            last_number = soup.select_one(".paging strong").get_text() # 영역 찾기 class.id
            print("마지막 페이지 번호: ", last_number)
            # 1-마지막 페이지 게시물 주소 
            # 코드1, 코드2, 날짜 가져오기
            for pages in range(1, int(last_number) + 1):
                driver.get(DatePage(code1, code2, wdate, pages)) # 날짜 받아오기
                # 웹에서 html 소스 가져오기
                newsurl = driver.page_source
                # 하위 카테고리 안에서 href 불러오기
                soup = BeautifulSoup(newsurl, "html.parser")
                # id main_content html 가져오기
                links = soup.select("#main_content > .list_body li") # 영역 찾기 class.id 
                for e in range(len(links)):
                    li = links[e].find("a")["href"]
                    links_list.append(li)
            GetPostInfo(driver, links_list, code1, code2, data_list)
        gc.collect()
        time.sleep(5)

#상위 카테고리, 하위 카테고리, 주소, 신문사, 제목, 날짜, 기자 이름, 내용(사진 포함) 추출
def GetPostInfo(driver, links_list, code1, code2, data_list) :
    index = 1;
    for a in links_list:
        try:
            driver.get(a)
            time.sleep(2)
            # HTML 페이지 소스를 받아온다.
            html = driver.page_source
            # 주소를 파싱한다.
            soup = BeautifulSoup(html, "html.parser")
        
            item = {"sid1" : "", "sid2" : "", "url" : "", "newspaper" : "", "title": "", "wdate" : "", "name" : "", "note" : "", "img" : ""}
            # 상위 카테고리
            item["sid1"] = code1
            #하위 카테고리
            item["sid2"] = code2
            # 주소
            item["url"] = a
            #신문사
            newsname = soup.find("img", {"class" : "media_end_head_top_logo_img light_type"})
            if newsname != None:
                item["newspaper"] = newsname["src"]
            # 신문사 - 연예
            elif soup.find("div", {"class" : "press_logo"}) != None:
                newsname = soup.find("div", {"class" : "press_logo"}).find("img")
                item["newspaper"] = newsname["src"]
            # 신문사 - 스포츠
            elif soup.find("span", {"class" : "logo"}) != None:   
                newsname = soup.find("span", {"class" : "logo"}).find('img')
                item["newspaper"] = newsname['src']
            elif soup.find("a", {"class" : "press_logo"}) != None:   
                newsname = soup.find("a", {"class" : "press_logo"}).find('img')
                item["newspaper"] = newsname['src']
            else:
                print("신문사를 찾을 수 없습니다.")
            #제목
            title = soup.find("h2", {"class" : "media_end_head_headline"})
            if title != None :
                item["title"] = title.text
            # 연예 등
            elif soup.find("h2", {"class" : "end_tit"}) != None :
                title = soup.find("h2", {"class" : "end_tit"})
                item["title"] = title.text
            # 스포츠
            elif soup.find("h4", {"class" : "title"}) != None :
                title = soup.find("h4", {"class" : "title"})
                item["title"] = title.text
            else :
                print("제목을 찾을 수 없습니다.")
            #날짜
            wdate = soup.find("span", {"class" : "media_end_head_info_datestamp_time _ARTICLE_DATE_TIME"})
            if wdate != None :           
                item["wdate"] = wdate.text
            elif soup.find("span", {"class" : "author"}) != None :
                wdate = soup.find("span", {"class" : "author"}).find('em')
                item["wdate"] = wdate.text
            # 날짜 - 스포츠
            elif soup.find("div", {"class" : "info"}) != None :
                wdate = soup.find("div", {"class" : "info"}).find('span')
                item["wdate"] = wdate.text.replace("기사입력", "")
            else :
                print("작성일을 찾을 수 없습니다.")
            #기자 이름
            name = soup.find("em", {"class" : "media_end_head_journalist_name"})
            if name != None:
                item["name"] = name.text
                print(name.text)
            # 내용(사진 포함)
            note = soup.find("article", {"id" : "dic_area"})
            if note != None :
                item["note"] = note
                img = note.find("img", {"id" : "img1"})
                if img != None:
                    item["img"] = img["src"]
                    print(img["src"])
            # 내용(사진 포함) -  연예
            elif soup.find("div", {"class" : "end_body_wrp"}) != None :
                note = soup.find("div", {"class" : "end_body_wrp"})
                item["note"] = note
                img = note.find("img", {"id" : "img1"})
                if img != None:
                    item["img"] = img["src"]
                    print(item["img"])
            # 내용(사진 포함) - 스포츠
            elif soup.find("div", {"class" : "news_end font1 size3"}) != None :
                note = soup.find("div", {"class" : "news_end font1 size3"})
                item["note"] = note
                img = note.find("span", {"class" : "end_photo_org"})
                if img != None:
                    item["img"] = img.find("img")["src"]
                    #print(item["img"])
            else :
                print("내용을 찾을 수 없습니다.")
            # 이미지만 따로 빼기
            data_list.append(item)
            print("상위 카테고리 :", code1, ", 하위 카테고리: ", code2, "//", index, "번째 게시물 수집 완료")
            #print(data_list)
        
            # 해당 기사 주소로 기존에 DB에 저장되어 있는지 확인
            check_query = "select count(*) as count from crawlingdata where cdurl = %(url)s AND cdtitle = %(title)s AND cdnote = %(note)s;"
            check_data = {
                'url': item["url"],
                'title': item["title"],
                'note': str(item["note"])
            }
            result = dbms.OpenQuery(check_query, check_data)
            print(result)
            
            if result:
                exists = result[0][0] # 첫 번째 행의 첫 번째 칼럼 값을 가져옵니다.
            else:
                exists = 0
            # DB에 해당 기사가 저장되어 있지 않다면 삽입
            if exists == 0:
                data = {
                    'url': item["url"],
                    'sid1': code1_mapping[code1],
                    'sid2': code2_mapping[code2],
                    'newspaper': item["newspaper"],
                    'title': _R(item["title"]),
                    'wdate': GetDate(item["wdate"]),
                    'name': item["name"],
                    'note': _R(str(item["note"])),
                    'img': item["img"]
                }
                query = "INSERT INTO crawlingdata (cdurl, cdtopcat, cdbtmcat, cdmedia, cdtitle, cddate, cdwriter, cdnote, cdimg) VALUES (%(url)s, %(sid1)s, %(sid2)s, %(newspaper)s, %(title)s, %(wdate)s, %(name)s, %(note)s, %(img)s);"
                
                #print(data)
                dbms.RunSQL(query, data)
                if dbms.RunSQL(query, data) == True :
                    print(f"Stored article {item['title']} to DB")
                else :
                    print("저장 실패")
        except Exception as e:
            print(f"Error loading or parsing {a}: {e}")
            
        index = index + 1
        
# 하위 카테고리에서 날짜
def DatePage(code1, code2, wdate, page):
    url = "https://news.naver.com/main/list.naver?mode=LS2D&sid2=" + code2 + "&sid1=" + code1 + "&mid=shm&date=" + wdate + "&page=" + str(page)
    return url

# 하위 주소 마지막 페이지 구하기
def GetLastPage(code1, code2, wdate) :
    driver = web_driver()
    try:
        driver.get(DatePage(code1, code2, wdate, 800)) # 날짜 받아오기
        # 웹에서 html 소스 가져오기
        newsurl = driver.page_source
        # 하위 카테고리 안에서 href 불러오기
        soup = BeautifulSoup(newsurl, "html.parser")
        # id main_content html 가져오기
        last_pageno = soup.select_one(".paging strong").get_text() # 영역 찾기 class.id
        return last_pageno
    except Exception as e:
        print(f"Error getting last page for {code1}, {code2}: {e}")
        return None
    

# deamon = True 속성을 주어 메인 프로세스가 종료되면 같이 종료되도록 함으로써
# background에서 계속 돌아가는걸 방지하도록 하자
sched = BackgroundScheduler(deamon=True)

# 저장할 이름 mapping 하긴
code1_mapping = {
    "100": "정치",
    "101": "경제",
    "102": "사회",
    "103": "생활,문화",
    "104": "세계",
    "105": "IT,과학",
}

code2_mapping = {
    "264": "대통령실",
    "265": "국회,정당",
    "268": "북한",
    "266": "행정",
    "267": "국방,외교",
    "269": "정치일반",
    "259": "금융",
    "258": "증권",
    "261": "산업,재계",
    "771": "중기,벤처",
    "260": "부동산",
    "262": "글로벌 경제",
    "310": "생활경제",
    "263": "경제 일반",
    "249": "사건사고",
    "250": "교육",
    "251": "노동",
    "254": "언론",
    "252": "환경",
    "59b": "인권,복지",
    "255": "식품,의료",
    "256": "지역",
    "276": "인물",
    "257": "사회 일반",
    "241": "건강정보",
    "239": "자동차,시승기",
    "240": "도로,교통",
    "237": "여행,레저",
    "238": "음식,맛집",
    "376": "패션,뷰티",
    "242": "공연,전시",
    "243": "책",
    "244": "종교",
    "248": "날씨",
    "245": "생활문화 일반",
    "231": "아시아,호주",
    "232": "미국,중남미",
    "233": "유럽",
    "234": "중동,아프리카",
    "322": "세계 일반",
    "731": "모바일",
    "226": "인터넷,SNS",
    "227": "통신,뉴미디어",
    "230": "IT 일반",
    "732": "보안,해킹",
    "283": "컴퓨터",
    "229": "게임,리뷰",
    "228": "과학 일반",
}

@sched.scheduled_job('cron', hour='12', minute='22', second='20', id='regular_crawling')
def job1():
    driver = web_driver()
    categories = {
        "100": ["264", "265", "268", "266", "267", "269"],
        "101": ["259", "258", "261", "771", "260", "262", "310", "263"],
        "102": ["249", "250", "251", "254", "252", "59b", "255", "256", "276", "257"],
        "103": ["241", "239", "240", "237", "238", "376", "242", "243", "244", "248", "245"],
        "104": ["231", "232", "233", "234", "322"],
        "105": ["731", "226", "227", "230", "732", "283", "229", "228"]
    }
    for code1, sid2_categories in categories.items():
        crawl_category(driver, code1, sid2_categories)
    driver.close()


sched.start()
print('스케줄 시작')
    
        


