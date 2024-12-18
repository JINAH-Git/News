import dbmanager as db

def GetCount(i,k,d,t):
    '''
    sql  = "select count(*) from refinedata "
    sql += "where rdrefine = '2' and rdtopcat = '" + i + "' "
    sql += "and rdbtmcat = '"  + k + "' "
    sql += "and rddate like '" + d + "%' " 
    sql += "and rddate between '" + d +" 00:00:00' and '" + d + " " + t +"'"
    '''
    sql = "select count(*) from refinedata where rdrefine = '2' and rdbtmcat = '" + k +"' and rddate>='2023-10-04'"
    print(sql)
    result = dbms.OpenQuery(sql)
    print(result)
    
    if result[0][0] != False:
        count = result[0][0]
    else:
        count = 0
    print(count)
    
    dat = d.replace("-", "")    
    print(d)
    '''
    if t == '09:00:00':
        t = "0009"
        sql  = "insert into count (cttopcat,ctbtmcat,ctdate,cttime,count) "
        sql += "values ('" + i +"','" + k + "','" + dat + "','" + t + "'," + str(count) +")"
        print(sql)
        #print(dbms.RunSQL(sql))
    elif t == '13:00:00':
        t = "0013"
        sql  = "insert into count (cttopcat,ctbtmcat,ctdate,cttime,count) "
        sql += "values ('" + i +"','" + k + "','" + dat + "','" + t + "'," + str(count) +")"
        print(sql)
        #print(dbms.RunSQL(sql))
    elif t == '17:00:00':
        t = "0017"
        sql  = "insert into count (cttopcat,ctbtmcat,ctdate,cttime,count) "
        sql += "values ('" + i +"','" + k + "','" + dat + "','" + t + "'," + str(count) +")"
        print(sql)
        #print(dbms.RunSQL(sql))
    elif t == '23:59:59':
        '''
    t = "0024"
    sql  = "insert into count (cttopcat,ctbtmcat,ctdate,cttime,count) "
    sql += "values ('" + i +"','" + k + "','" + dat + "','" + t + "'," + str(count) +")"
    print(sql)
    print(dbms.RunSQL(sql))


code1 = ["정치","경제","사회","생활,문화","세계","IT,과학"]
subcode1 = ["대통령실","국회,정당","북한","행정","국방,외교","정치일반"]
subcode1 = ["국회,정당","북한","행정","국방,외교","정치일반"]
subcode2 = ["금융","증권","산업,재계","중기,벤처","부동산","글로벌 경제","생활경제","경제 일반"]
subcode3 = ["사건사고","교육","노동","언론","환경","인권,복지","식품,의료","지역","인물","사회 일반"]
subcode4 = ["건강정보","자동차,시승기","도로,교통","여행,레저","음식,맛집","패션,뷰티","공연,전시","책","종교","날씨","생활문화 일반"]
subcode5 = ["아시아,호주","미국,중남미","유럽","중동,아프리카","세계 일반"]
subcode6 = ["모바일","인터넷,SNS","통신,뉴미디어","IT 일반","보안,해킹","컴퓨터","게임,리뷰","과학 일반"]

dbms = db.DBManager()
if dbms.DBOpen("192.168.0.27", "news", "root", "ezen") == True :
    print("DB연결이 완료되었습니다.")
    for i in code1:
        if i == "정치":
            for k in subcode1:
                #date  = ['2023-09-12','2023-09-13','2023-09-14','2023-09-15','2023-09-16','2023-09-17']
                date  = ['2023-10-04']
                for d in date:
                    time = ['09:00:00','13:00:00','17:00:00','23:59:59']
                    for t in time:
                        GetCount(i,k,d,t)
        if i == "경제":
            for k in subcode2:
                #date  = ['2023-09-12','2023-09-13','2023-09-14','2023-09-15','2023-09-16','2023-09-17']
                date  = ['2023-10-04']
                for d in date:
                    time = ['09:00:00','13:00:00','17:00:00','23:59:59']
                    for t in time:
                        GetCount(i,k,d,t)
        if i == "사회":
            for k in subcode3:
                #date  = ['2023-09-12','2023-09-13','2023-09-14','2023-09-15','2023-09-16','2023-09-17','2023-09-18','2023-09-19','2023-09-20','2023-09-21','2023-09-22','2023-09-23','2023-09-24','2023-09-25','2023-09-26','2023-09-27','2023-09-28','2023-09-29','2023-09-30']
                date  = ['2023-10-04']
                for d in date:
                    time = ['09:00:00','13:00:00','17:00:00','23:59:59']
                    for t in time:
                        GetCount(i,k,d,t)
        if i == "생활,문화":
            for k in subcode4:
                #date  = ['2023-09-12','2023-09-13','2023-09-14','2023-09-15','2023-09-16','2023-09-17','2023-09-18','2023-09-19']
                date  = ['2023-10-04']
                for d in date:
                    time = ['09:00:00','13:00:00','17:00:00','23:59:59']
                    for t in time:
                        GetCount(i,k,d,t)
        if i == "세계":
            for k in subcode5:
                #date  =  ['2023-09-12','2023-09-13','2023-09-14','2023-09-15','2023-09-16','2023-09-17','2023-09-18','2023-09-19','2023-09-20','2023-09-21','2023-09-22','2023-09-23','2023-09-24','2023-09-25']
                date  = ['2023-10-04']
                for d in date:
                    time = ['09:00:00','13:00:00','17:00:00','23:59:59']
                    for t in time:
                        GetCount(i,k,d,t)
        if i == "IT,과학":
            for k in subcode6:
                #date  = ['2023-09-12','2023-09-13','2023-09-14','2023-09-15','2023-09-16','2023-09-17','2023-09-18','2023-09-19','2023-09-20','2023-09-21','2023-09-22','2023-09-23','2023-09-24']
                date  = ['2023-10-04']
                for d in date:
                    time = ['09:00:00','13:00:00','17:00:00','23:59:59']
                    for t in time:
                        GetCount(i,k,d,t)