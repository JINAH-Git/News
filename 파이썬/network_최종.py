# 상위 15개만 추출
import dbmanager as db
import ast              #딕셔너리 변환을 위해 Abstract Syntax Tree

#DB 연결
dbms = db.DBManager()
if dbms.DBOpen("192.168.0.27", "news", "root", "ezen") == False:
    print("Error")
else:
    print("OK")
    
    # 명사매핑에서 모든 기사의 관리번호와 명사 가져오기 
    sql = "select cdno, nmnouns from nounmapping"
    net_results = dbms.OpenQuery(sql)
    print(len(net_results))
    for net_result in net_results:
        cdno, total = net_result   #cdno = 기사관리번호, total = 명사, 빈도 수
        
        #명사, 빈도 수 dic로 바꾸기
        noun_dict = ast.literal_eval(total)
        #print(noun_dict)
        nouns = list(noun_dict.keys())                  #명사(key) list로 변환
        #print(nouns)
        frequencies = list(noun_dict.values())          #빈도수(value) list로 변환
        combined = list(zip(nouns, frequencies))        #list인 명사랑 빈도수 합치기
        sorted_combined = sorted(combined, key=lambda x: x[1], reverse=True)    #내림차순 정렬
        top_15_nouns = sorted_combined[:15]             #빈도수 기준 상위 15개 가져오기(명사, 빈도수)
        #print(top_15_nouns)
        if len(top_15_nouns) > 0:                       #빈 리스트가 없게 확인
            top_nouns, top_freqs = zip(*top_15_nouns)   #리스트의 데이터를 명사와 빈도수로 분리하여 저장
        else:
            continue
        #print(top_nouns)
        #print(top_freqs)
        
        combinations = []
        for i in range(len(top_nouns)):
            for j in range(i+1, len(top_nouns)):
                noun_pair = (top_nouns[i], top_nouns[j])
                weight = (top_freqs[i] + top_freqs[j]) / 2
                combinations.append((noun_pair, weight))
        
        top_edges = sorted(combinations, key=lambda x: x[1], reverse=True)[:15]
        for (noun1, noun2), weight in top_edges:
            sql = f"INSERT INTO networkgraph (noun1, noun2, nwgweight, cdno) VALUES ('{noun1}', '{noun2}', {weight}, {cdno})"
            dbms.RunSQL(sql)
    # 연결 종료
    dbms.DBClose()
