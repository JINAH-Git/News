import pymysql

class DBManager :
    #db를 연결한다
    def DBOpen(self,host,dbname,id,pw) :
        try :
            self.con = pymysql.connect(
                host=host,
                port=3306, 
                user=id, 
                passwd=pw,
                db=dbname, charset ="utf8")
            if self.con != None :
                self.cursor = self.con.cursor()     #cursor객체 만들기-하나의 DB connection에 대하여 독립적으로 SQL 문을 실행할 수 있는 작업환경을 제공하는 객체.
                return True
            return False
        except :
            return False
     
    #db를 종료한다.
    def DBClose(self) :
        self.con.close()            #self로 해당 con이 지역변수가 아님을 알려
    
    #입력받은 SQL 쿼리를 실행한다.     INSERT, UPDATE, DELETE     
    def RunSQL(self,sql) :
        try :
            self.cursor.execute(sql)
            self.con.commit()
            return True
        except :
            return False
         
    #입력받은 SQL 쿼리를 실행하고, 그 결과를 받아온다  SELECT
    def OpenQuery(self,sql):
        try :
            self.cursor.execute(sql)
            self.data = self.cursor.fetchall()
            self.num_fields = len(self.cursor.description)
            return self.data
        except :
            print("SQL ERROR:" + sql)
            return False       

    #쿼리 실행 후 사용한 커서 닫기        
    def CloseQuery(self) :
        self.cursor.close()
        
    #현재 가져온 데이터의 총 레코드 수를 반환   
    def GetTotal(self) :
        return len(self.data)
        
    #가져온 데이터에서 지정된 인덱스의 레코드와 해당 컬럼의 값을 반환하는 메서드
    def GetValue(self,index,column):
        count = -1
        for name in self.cursor.description:
            count = count + 1
            print(name[0])
            if name[0] == column :            
                return self.data[index][count]
        return ""
    

           