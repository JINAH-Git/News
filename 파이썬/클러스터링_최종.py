#DBSCAN을 이용한 클러스터링 작업
import pandas as pd
import konlpy
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.cluster import DBSCAN
from apscheduler.schedulers.background import BackgroundScheduler
from datetime import datetime
import dbmanager as db

TodayDate = datetime.today().strftime("%Y-%m-%d")

dbms = db.DBManager()

stop_words = ["전", "길", "뒤", "실", "말", "로", "곳", "약", "등", "재판매", "개", "위해", "때", "제", "중", 
              "국", "코", "날", "김", "손", "티", "놈", "및", "주지", "것", "못", "놈", "로서", "고", "생으로", 
              "그", "더", "편", "론", "디", "티스", "다지", "또", "처", "것", "이", "수", "옆", "어가", "최근", 
              "디", "고", "바", "며", "마가", "및", "잠시", "서서", "모디", "의", "고", "새", "를", "을", "어", "늘", "며"]

# 스케쥴러 작동
sched = BackgroundScheduler(daemon=True)

#첫번째 작업
@sched.scheduled_job('cron', hour='10', minute='50', second='0', id='clustering_one')
def clustering_one():
    #DB 연결 설정
    if dbms.DBOpen("192.168.0.27", "news", "root", "ezen") == True:
        #DB에서 뉴스 데이터를 가져옴
        print('작업을 시작합니다')
        sql = f"select rdtopcat, rdbtmcat, rdtitle, rddate, rdnote, cdno from refinedata where rdrefine = 2 and DATE(rddate) = '" + TodayDate +"'"
        result = dbms.OpenQuery(sql)
        #print(result)
        
        #데이터프레임 생성
        #값을 가공하고 저장해둘 데이터 틀을 만들어준다
        column_names = ['cttopcat', 'ctbtmcat', 'cttitle', 'ctdate', 'ctnote', 'cdno']
        news_df = pd.DataFrame(result, columns=column_names)
        
        row_count = news_df.shape[0]
        print("행 갯수 (rows):", row_count)
        #데이터 전처리 - 명사 추출 및 텍스트로 묶기
        
        print("명사 추출을 시작합니다")
        documents_processed = []
        #형태소 분석을 통해 명사를 추출한다
        okt = konlpy.tag.Okt()
        
        for text in news_df['ctnote']: #ctnote에 있는 내용을 text로 받는다
            okt_pos = okt.pos(text)    #text(내용)를 품사로 추출해준다 
            words = []
            for word, pos in okt_pos:
                if 'Noun' in pos and word not in stop_words:      #품사중 명사가 있으면 words에 저장해준다
                    words.append(word)
            documents_processed.append(' '.join(words)) #최종적으로 documents_processed에 명사들을 공백을 주면서 저장해준다
                                                        #공백을 주고 저장해야 토큰화 할 때 분석에 유용하다
        print("명사 데이터 저장 완료")
        
        #TF-IDF 벡터화
        #min_df값은 빈도수가 낮은 단어는 무시하는 값
        #ngram_range값은 (1,1)이면 단어 단위로 토큰화, (1,2)이면 단어와 바이그램까지 즉, 두 단어의 조합된 단어를 토큰화
        tfidf_vectorizer = TfidfVectorizer(min_df=2, ngram_range=(1, 1))
        tfidf_vector = tfidf_vectorizer.fit_transform(documents_processed) #documents_processed 단어의 전처리를 해준다 (불필요한 단어)
        tfidf_dense = tfidf_vector.todense() #벡터를 밀집 행렬로 변환, 행렬 연산을 더 쉽게 할 수 있기 때문에 변환해준다
        
        
        #클러스터링 ==========================================================================================
        #eps 값이 크면 더 많은 데이터 포인트가 하나의 클러스터로 묶이게 되고, 작으면 더 작은 클러스터가 형성된다
        #min_samples 값이 작으면 노이즈로 간주되는 데이터 포인트가 늘어날 수 있고, 크면 더 큰 클러스터만 형성된다
        model = DBSCAN(eps=0.3, min_samples=7, metric = "cosine")
        print("훈련을 시작합니다.")
        model.fit(tfidf_dense)
        cluster_labels = model.labels_
        
        #클러스터링 결과를 데이터프레임에 추가
        news_df['ctcluster'] = cluster_labels
        #데이터프레임의 컬럼 찍어보기
        column_names = news_df.columns
        #print(column_names)
        #print(news_df)
        
        #노이즈 값인 -1과 클러스터로 안묶인 값 0 데이터를 제외해주는 필터링
        filtered_news_df = news_df[(news_df['ctcluster'] != -1) & (news_df['ctcluster'] != 0)]
        
        #클러스터링 결과를 테이블에 저장
        for index, row in filtered_news_df.iterrows():
            ctcluster = row['ctcluster']
            cdno = row['cdno']
            cttitle = row['cttitle']
            cttitle = cttitle.replace("'", "''")
            try:
                insert_sql  = "insert into clustering "
                insert_sql += "(ctcluster, cdno, cttitle) "
                insert_sql += "values "
                insert_sql += "('{}', '{}', '{}')".format(ctcluster, cdno, cttitle)
                dbms.RunSQL(insert_sql)
                print(f"작업 {index + 1}/{len(news_df)} 완료")
            except Exception as e:
                print(f"오류 발생: {str(e)}")
                continue
        
        print(filtered_news_df)
        current_datetime = datetime.today().strftime("%Y-%m-%d %H:%M:%S")
        print(current_datetime + "작업 완료")
        #DB 연결 종료
        dbms.CloseQuery()
        dbms.DBClose()

#두번째 작업
@sched.scheduled_job('cron', hour='14', minute='50', second='0', id='clustering_two')
def clustering_two():
    #DB 연결 설정
    if dbms.DBOpen("192.168.0.27", "news", "root", "ezen") == True:
        #DB에서 뉴스 데이터를 가져옴
        print('작업을 시작합니다')
        sql = f"select rdtopcat, rdbtmcat, rdtitle, rddate, rdnote, cdno from refinedata where rdrefine = 2 and DATE(rddate) = '" + TodayDate +"'"
        result = dbms.OpenQuery(sql)
        #print(result)
        
        #데이터프레임 생성
        #값을 가공하고 저장해둘 데이터 틀을 만들어준다
        column_names = ['cttopcat', 'ctbtmcat', 'cttitle', 'ctdate', 'ctnote', 'cdno']
        news_df = pd.DataFrame(result, columns=column_names)
        
        row_count = news_df.shape[0]
        print("행 갯수 (rows):", row_count)
        #데이터 전처리 - 명사 추출 및 텍스트로 묶기
        
        print("명사 추출을 시작합니다")
        documents_processed = []
        #형태소 분석을 통해 명사를 추출한다
        okt = konlpy.tag.Okt()
        
        for text in news_df['ctnote']: #ctnote에 있는 내용을 text로 받는다
            okt_pos = okt.pos(text)    #text(내용)를 품사로 추출해준다 
            words = []
            for word, pos in okt_pos:
                if 'Noun' in pos and word not in stop_words:      #품사중 명사가 있으면 words에 저장해준다
                    words.append(word)
            documents_processed.append(' '.join(words)) #최종적으로 documents_processed에 명사들을 공백을 주면서 저장해준다
                                                        #공백을 주고 저장해야 토큰화 할 때 분석에 유용하다
        print("명사 데이터 저장 완료")
        
        #TF-IDF 벡터화
        #min_df값은 빈도수가 낮은 단어는 무시하는 값
        #ngram_range값은 (1,1)이면 단어 단위로 토큰화, (1,2)이면 단어와 바이그램까지 즉, 두 단어의 조합된 단어를 토큰화
        tfidf_vectorizer = TfidfVectorizer(min_df=2, ngram_range=(1, 1))
        tfidf_vector = tfidf_vectorizer.fit_transform(documents_processed) #documents_processed 단어의 전처리를 해준다 (불필요한 단어)
        tfidf_dense = tfidf_vector.todense() #벡터를 밀집 행렬로 변환, 행렬 연산을 더 쉽게 할 수 있기 때문에 변환해준다
        
        
        #클러스터링 ==========================================================================================
        #eps 값이 크면 더 많은 데이터 포인트가 하나의 클러스터로 묶이게 되고, 작으면 더 작은 클러스터가 형성된다
        #min_samples 값이 작으면 노이즈로 간주되는 데이터 포인트가 늘어날 수 있고, 크면 더 큰 클러스터만 형성된다
        model = DBSCAN(eps=0.3, min_samples=7, metric = "cosine")
        print("훈련을 시작합니다.")
        model.fit(tfidf_dense)
        cluster_labels = model.labels_
        
        #클러스터링 결과를 데이터프레임에 추가
        news_df['ctcluster'] = cluster_labels
        #데이터프레임의 컬럼 찍어보기
        column_names = news_df.columns
        #print(column_names)
        #print(news_df)
        
        #노이즈 값인 -1과 클러스터로 안묶인 값 0 데이터를 제외해주는 필터링
        filtered_news_df = news_df[(news_df['ctcluster'] != -1) & (news_df['ctcluster'] != 0)]
        
        #클러스터링 결과를 테이블에 저장
        for index, row in filtered_news_df.iterrows():
            ctcluster = row['ctcluster']
            cdno = row['cdno']
            cttitle = row['cttitle']
            cttitle = cttitle.replace("'", "''")
            try:
                insert_sql  = "insert into clustering "
                insert_sql += "(ctcluster, cdno, cttitle) "
                insert_sql += "values "
                insert_sql += "('{}', '{}', '{}')".format(ctcluster, cdno, cttitle)
                dbms.RunSQL(insert_sql)
                print(f"작업 {index + 1}/{len(news_df)} 완료")
            except Exception as e:
                print(f"오류 발생: {str(e)}")
                continue
        
        print(filtered_news_df)
        current_datetime = datetime.today().strftime("%Y-%m-%d %H:%M:%S")
        print(current_datetime + "작업 완료")
        #DB 연결 종료
        dbms.CloseQuery()
        dbms.DBClose()

#세번째 작업
@sched.scheduled_job('cron', hour='18', minute='50', second='0', id='clustering_three')
def clustering_three():
    #DB 연결 설정
    if dbms.DBOpen("192.168.0.27", "news", "root", "ezen") == True:
        #DB에서 뉴스 데이터를 가져옴
        print('작업을 시작합니다')
        sql = f"select rdtopcat, rdbtmcat, rdtitle, rddate, rdnote, cdno from refinedata where rdrefine = 2 and DATE(rddate) = '" + TodayDate +"'"
        result = dbms.OpenQuery(sql)
        #print(result)
        
        #데이터프레임 생성
        #값을 가공하고 저장해둘 데이터 틀을 만들어준다
        column_names = ['cttopcat', 'ctbtmcat', 'cttitle', 'ctdate', 'ctnote', 'cdno']
        news_df = pd.DataFrame(result, columns=column_names)
        
        row_count = news_df.shape[0]
        print("행 갯수 (rows):", row_count)
        #데이터 전처리 - 명사 추출 및 텍스트로 묶기
        
        print("명사 추출을 시작합니다")
        documents_processed = []
        #형태소 분석을 통해 명사를 추출한다
        okt = konlpy.tag.Okt()
        
        for text in news_df['ctnote']: #ctnote에 있는 내용을 text로 받는다
            okt_pos = okt.pos(text)    #text(내용)를 품사로 추출해준다 
            words = []
            for word, pos in okt_pos:
                if 'Noun' in pos and word not in stop_words:      #품사중 명사가 있으면 words에 저장해준다
                    words.append(word)
            documents_processed.append(' '.join(words)) #최종적으로 documents_processed에 명사들을 공백을 주면서 저장해준다
                                                        #공백을 주고 저장해야 토큰화 할 때 분석에 유용하다
        print("명사 데이터 저장 완료")
        
        #TF-IDF 벡터화
        #min_df값은 빈도수가 낮은 단어는 무시하는 값
        #ngram_range값은 (1,1)이면 단어 단위로 토큰화, (1,2)이면 단어와 바이그램까지 즉, 두 단어의 조합된 단어를 토큰화
        tfidf_vectorizer = TfidfVectorizer(min_df=2, ngram_range=(1, 1))
        tfidf_vector = tfidf_vectorizer.fit_transform(documents_processed) #documents_processed 단어의 전처리를 해준다 (불필요한 단어)
        tfidf_dense = tfidf_vector.todense() #벡터를 밀집 행렬로 변환, 행렬 연산을 더 쉽게 할 수 있기 때문에 변환해준다
        
        
        #클러스터링 ==========================================================================================
        #eps 값이 크면 더 많은 데이터 포인트가 하나의 클러스터로 묶이게 되고, 작으면 더 작은 클러스터가 형성된다
        #min_samples 값이 작으면 노이즈로 간주되는 데이터 포인트가 늘어날 수 있고, 크면 더 큰 클러스터만 형성된다
        model = DBSCAN(eps=0.3, min_samples=7, metric = "cosine")
        print("훈련을 시작합니다.")
        model.fit(tfidf_dense)
        cluster_labels = model.labels_
        
        #클러스터링 결과를 데이터프레임에 추가
        news_df['ctcluster'] = cluster_labels
        #데이터프레임의 컬럼 찍어보기
        column_names = news_df.columns
        #print(column_names)
        #print(news_df)
        
        #노이즈 값인 -1과 클러스터로 안묶인 값 0 데이터를 제외해주는 필터링
        filtered_news_df = news_df[(news_df['ctcluster'] != -1) & (news_df['ctcluster'] != 0)]
        
        #클러스터링 결과를 테이블에 저장
        for index, row in filtered_news_df.iterrows():
            ctcluster = row['ctcluster']
            cdno = row['cdno']
            cttitle = row['cttitle']
            cttitle = cttitle.replace("'", "''")
            try:
                insert_sql  = "insert into clustering "
                insert_sql += "(ctcluster, cdno, cttitle) "
                insert_sql += "values "
                insert_sql += "('{}', '{}', '{}')".format(ctcluster, cdno, cttitle)
                dbms.RunSQL(insert_sql)
                print(f"작업 {index + 1}/{len(news_df)} 완료")
            except Exception as e:
                print(f"오류 발생: {str(e)}")
                continue
        
        print(filtered_news_df)
        current_datetime = datetime.today().strftime("%Y-%m-%d %H:%M:%S")
        print(current_datetime + "작업 완료")
        #DB 연결 종료
        dbms.CloseQuery()
        dbms.DBClose()

sched.start()


