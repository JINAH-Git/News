import dbmanager as db
import pandas as pd

def SaveData(filepath,i,k,d):
    csv_read = pd.read_csv(filepath,encoding='utf-8-sig')
    csv_read = csv_read.fillna('None')
    for j in range(len(csv_read)) :
        topcat = csv_read['sid1'][j]
        btmcat = csv_read['sid2'][j]
        url    = csv_read['url'][j]
        media  = csv_read['newspaper'][j]
        title  = csv_read['title'][j].replace("'","''")
        date   = csv_read['wdate'][j]
        writer = csv_read['name'][j]
        note   = csv_read['note'][j].replace("'","''")
        img    = csv_read['img'][j]
        if GetDate(date.lstrip()) == None:
            continue
        else:
            date = GetDate(date.lstrip())  
        print(date)
        print("상위 카테고리",i,'하위카테고리',k,'===>',j,'번째 데이터',d,'일째 입니다.',url)
        sql  = "insert into crawlingdata(cdurl,cdtopcat,cdbtmcat,cdmedia,cdtitle,cddate,cdwriter,cdnote,cdimg) values "
        sql += "('" + url + "','" + topcat + "','" + btmcat + "','" + media + "','" + title + "','" + date + "','" + writer + "','" + note + "','" + img + "')"
        #print(sql)
        
        if print(dbms.RunSQL(sql)) == False:
            print("상위 카테고리",i,'하위카테고리',k,'===>',j,'번째 데이터',d,'일째에서 ERROR.')
            break
        
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
        
        

#code1 = ["정치","경제","사회","생활,문화","세계","IT,과학"]
code1 = ["생활,문화"]
subcode1 = ["대통령실","국회,정당","북한","행정","국방,외교","정치일반"]
subcode2 = ["금융","증권","산업,재계","중기,벤처","부동산","글로벌 경제","생활경제","경제 일반"]
subcode3 = ["사건사고","교육","노동","언론","환경","인권,복지","식품,의료","지역","인물","사회 일반"]
subcode4 = ["건강정보","자동차,시승기","도로,교통","여행,레저","음식,맛집","패션,뷰티","공연,전시","책","종교","날씨","생활문화 일반"]
subcode5 = ["아시아,호주","미국,중남미","유럽","중동,아프리카","세계 일반"]
subcode6 = ["모바일","인터넷,SNS","통신,뉴미디어","IT 일반","보안,해킹","컴퓨터","게임,리뷰","과학 일반"]

dbms = db.DBManager()
if dbms.DBOpen("192.168.0.27", "news", "root", "ezen") == True :
    print("DB연결이 완료되었습니다.")
    for i in code1:
        print("상위 카테고리:",i)
        '''
        if i == "정치":
            print("상위 카테고리 '",i,"'에 들어왔습니다.")
            for k in subcode1:
                print("하위 카테고리 '",k,"'에 들어왔습니다.")
                #date  = ['20230901','20230902','20230903','20230904','20230905','20230906','20230907','20230908','20230909','20230910','20230911']
                date  = ['20230912','20230913','20230914','20230915','20230916','20230917']
                for d in date:
                    filepath = '.\정치\정치_' + k + '_데이터[' + d + '].csv'
                    SaveData(filepath,i,k,d)
        if i == "경제":
            for k in subcode2:
                date  = ['20230912','20230913','20230914','20230915','20230916','20230917']
                for d in date:
                    filepath = '.\경제\경제_' + k + '_데이터[' + d + '].csv'
                    SaveData(filepath,i,k,d)
        if i == "사회":
            for k in subcode3:
                date  = ['20230912','20230913','20230914','20230915','20230916','20230917']
                for d in date:
                    filepath = '.\사회\사회_' + k + '_데이터[' + d + '].csv'
                    SaveData(filepath,i,k,d)
                      '''
        if i == "생활,문화":
            for k in subcode4:
                date  = ['20230912','20230913','20230914','20230915','20230916','20230917']
                for d in date:
                    filepath = '.\생활,문화\생활,문화_' + k + '_데이터[' + d + '].csv'
                    SaveData(filepath,i,k,d)
        if i == "세계":
            for k in subcode5:
                date  = ['20230912','20230913','20230914','20230915','20230916','20230917']
                for d in date:
                    filepath = '.\세계\세계_' + k + '_데이터[' + d + '].csv'
                    SaveData(filepath,i,k,d)
        if i == "IT,과학":
            for k in subcode6:
                date  = ['20230912','20230913','20230914','20230915','20230916','20230917']
                for d in date:
                    filepath = '.\IT,과학\IT,과학_' + k + '_데이터[' + d + '].csv'
                    SaveData(filepath,i,k,d)
