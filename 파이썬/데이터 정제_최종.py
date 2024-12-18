from apscheduler.schedulers.background import BackgroundScheduler
from datetime import datetime
import dbmanager as db
'''
crawling data
data[0],'#기사관리번호'
data[1],'#기사주소'
data[2],'#상위카테고리'
data[3],'#하위카테고리'
data[4],'#신문사'
data[5],'#제목'
data[6],'#날짜'
data[7],'#기자이름'
data[8],'#내용'
data[9],'#사진'
'''

TodayDate = datetime.today().strftime("%Y-%m-%d")

# 스케쥴러 작동
sched = BackgroundScheduler(daemon=True)

per_page = 10000 #데이터를 5000개씩 잘라서 메모리에 올린다.

#데이터를 페이징한다. 원본데이터에서 전체 페이지수를 가져온다.
def GetSliceTotalPage(dbms) :
    global per_page
    sql = "select count(*) as count from crawlingdata where cddate = '" + TodayDate + "'"
    dbms.OpenQuery(sql)
    total = int(dbms.GetValue(0,"count"))
    total_page =  total // per_page
    if(total % per_page != 0) :
        total_page = total_page + 1
    return total_page

def DelNone(dbms,pageNo,total_page) :
    global per_page
    startNo = pageNo * per_page
    endNo   = per_page
    
    #null 제거 - 기자이름null값 말고 나머지는 정제테이블에 저장하지 않는다.
    sql = "select * from crawlingdata where cddate = '" + TodayDate + "' limit %d,%d" % (startNo,endNo)
    result = dbms.OpenQuery(sql)
    
    for i in range(len(result)):
        data = result[i]
        if data[1] == 'None' or data[2] == 'None' or data[3] == 'None' or data[4] == 'None' or data[5] == 'None' or data[6] == 'None' or data[8] == 'None':
            print('해당 데이터는 저장되지 않습니다. 기사번호 => ', data[0])
        else:
            #print('해당 데이터는 None이 없습니다. 기사번호 => ', data[0])
            date = str(data[6])
            date = date[:11].replace("-","")
            if int(date) < 20230901 :
                print('해당 데이터는 날짜 조건을 만족하지 않습니다. 기사번호 => ', data[0])
            else:
                print('해당 데이터는 None이 없고, 날짜도 조건을 만족. 정제 테이블에 저장. 기사번호 => ', data[0]) 
                sql  = "insert into refinedata (cdno,rdrefine,rdurl,rdtopcat,rdbtmcat,rdmedia,rdtitle,rddate,rdwriter,rdnote,rdimg) "
                sql += "values ('" + str(data[0]) + "','" + str(1) + "','" + data[1] + "','" + data[2] + "','" + data[3] + "','" + data[4] + "','" + data[5].replace("'","''") + "','" + str(data[6]) + "','" + data[7] + "','" + data[8].replace("'","''") + "','" + data[9] + "')"            
                #print(sql)
                if print(dbms.RunSQL(sql)) == False:
                    print("기사번호가",date[0],'에서 ERROR.')
                
'''
refine data
data[0],'#기사관리번호'
data[1],'#정제차수'
data[2],'#기사주소'
data[3],'#상위카테고리'
data[4],'#하위카테고리'
data[5],'#신문사'
data[6],'#제목'
data[7],'#날짜'
data[8],'#기자이름'
data[9],'#내용'
data[10],'#사진'
'''
#데이터를 페이징한다. 원본데이터에서 전체 페이지수를 가져온다.
def GetSliceTotalPage2(dbms) :
    global per_page
    sql = "select count(*) as count from refinedata where rdrefine = 1 and rddate >= '2023-09-12' and rddate <= '2023-09-30'"
    dbms.OpenQuery(sql)
    total = int(dbms.GetValue(0,"count"))
    total_page =  total // per_page
    if(total % per_page != 0) :
        total_page = total_page + 1
    return total_page
    
#이미지 없는 경우 이미지 없음으로 저장
def PickImg(dbms,pageNo,total_page):
    global per_page
    startNo = pageNo * per_page
    endNo   = per_page

    sql = "select * from refinedata where rdrefine = 1 and rddate >= '2023-09-12' and rddate <= '2023-09-30' limit %d,%d" % (startNo,endNo)
    result = dbms.OpenQuery(sql)
    
    for i in range(len(result)):
        data = result[i]
        if data[10] == 'None':
            print(data[0],'이미지 없음')
            sql  = "insert into refinedata (cdno,rdrefine,rdurl,rdtopcat,rdbtmcat,rdmedia,rdtitle,rddate,rdwriter,rdnote,rdimg) "
            sql += "values ('" + str(data[0]) + "','" + str(2) + "','" + data[2] + "','" + data[3] + "','" + data[4] + "','" + data[5] + "','" + data[6].replace("'","''") + "','" + str(data[7]) + "','" + data[8] + "','" + data[9].replace("'","''") + "','이미지 없음')"      
            print(sql)
            if print(dbms.RunSQL(sql)) == False:
                print("기사번호가",data[0],'에서 ERROR.')                
            
        else:
            sql  = "insert into refinedata (cdno,rdrefine,rdurl,rdtopcat,rdbtmcat,rdmedia,rdtitle,rddate,rdwriter,rdnote,rdimg) "
            sql += "values ('" + str(data[0]) + "','" + str(2) + "','" + data[2] + "','" + data[3] + "','" + data[4] + "','" + data[5] + "','" + data[6].replace("'","''") + "','" + str(data[7]) + "','" + data[8] + "','" + data[9].replace("'","''") + "','" + data[10] +"')"            
            print(data[0],"번째 데이터 저장.")
            if print(dbms.RunSQL(sql)) == False:
                print("기사번호가",data[0],'에서 ERROR.')

@sched.scheduled_job('cron', hour='10', minute='00', second='0', id='refine1')  
def refine1():
    dbms = db.DBManager()
    if dbms.DBOpen("192.168.0.27", "news", "root", "ezen") == True :
        print("DB연결이 완료되었습니다.")    
        total_page = GetSliceTotalPage(dbms)
        #null,날짜 9월1일 이전 데이터 삭제(1차)
        for page in range(total_page) :
            DelNone(dbms,page,total_page)   
        dbms.CloseQuery()
        dbms.DBClose()    

#두번째 작업
@sched.scheduled_job('cron', hour='14', minute='00', second='0', id='refine2')
def refine2():
    dbms = db.DBManager()
    if dbms.DBOpen("192.168.0.27", "news", "root", "ezen") == True :
        print("DB연결이 완료되었습니다.")    
        total_page = GetSliceTotalPage2(dbms)
        #이미지 하나만뽑기(2차)
        for page in range(total_page):
            PickImg(dbms,page,total_page)
        dbms.CloseQuery()
        dbms.DBClose()
        
sched.start()