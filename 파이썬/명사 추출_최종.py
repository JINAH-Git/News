import pymysql
from konlpy.tag import Okt
from collections import Counter
    
def _R(data):
    data = data.replace("'","''");
    return data;

#데이터베이스 연결
con = pymysql.connect(host="192.168.0.27", port=3306, 
                      user="root", passwd="ezen",
                      db="news", charset="utf8")
cursor = con.cursor()
con.commit()

#231207
for i in range(261694,384850) :
    try:
        sql = "select rdnote from refinedata where rdrefine = 2 and cdno = " + str(i);
        cursor.execute(sql)
        note = cursor.fetchone()
        print("="*100)
        okt = Okt()
        nouns = okt.nouns(note[0])
        print(nouns)
        #print(nouns)  
        words = [n for n in nouns if len(n) > 1] # 단어의 길이가 1개인 것은 제외
        #print(words)
        #명사가 아닌 단어 불용어 사전에 등록하여 제거
        stopwords = ['다른','엮다','여러','널리','모든','제라','거듭','가치나','부로','절대로','결코','얻지','오른','상대로'
                     ,"또한",'달라','라며','로서','갈라치','미나',"꼽았다",'비롯','하니','패율제','지원이','자예드','자꾸','별로'
                     ,'여태','무르익','맹종하','만주군','만들기','더욱','다시','꼽는다','그으','그린','그었다','그대로','곧바로'
                     ,'고스','겹치','거나','거꾸로','보이지','보지','이자보','공선택']
        words = [i for i in words if not i in stopwords]
        #print(words)
        c = Counter(words)
        c = dict(c)
        c = str(c)
        #print(c)    

        #명사 매핑에 insert
        sql = "insert into nounmapping(cdno,rdrefine,nmnouns) values (%s,2,%s)"
        cursor.execute(sql,(i,c))
        
        #명사 사전에 insert
        for word in words :
            sql = "select * from noundict where ndnoun = %s"
            check = cursor.execute(sql,word)
            if check == 0 :
                print(word)
                sql = "insert into noundict(ndnoun) values (%s)"
                cursor.execute(sql,word)
               
        #워드클라우드 insert
        wc = c.split(",")
        for items in wc :
            item = items.split(":")
            wordname = item[0].replace("{","").replace("'","").replace(" ","")
            #print(wordname)
            wordcount = item[1].replace("}","").replace("'","").replace(" ","")
            #print(wordcount)
            sql = "insert into wordcloud(cdno,wcnoun,wccount) values (%s,%s,%s)"
            cursor.execute(sql,(i,wordname,wordcount))
        con.commit()

        print("%d번째 게시물 저장 완료"%i)
    except:
        print("%d번째 게시물 저장 실패"%i)
con.close()





        