package news.dao;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBManager 
{
	//외부에서 접근하지 못하게 private적용.
	private Connection conn;
	private Statement  stmt; //지역 변수여서 {}끝나면 끝남.그래서 위에다가 선언
	private ResultSet  rs; //지역 변수여서 {}끝나면 끝남.
	
	//생성자
	public DBManager()
	{
		//값은 이쪽에 집어넣기.
		conn = null;
		stmt = null;
		rs   = null;
	}
	
	//메소드 오버로딩
	//드라이버 로딩 및 DB 연결
	public boolean DBOpen() //연결이 성공하면 참으로 리턴 실패하면 false로 
	{
		//1.jdbc 라이브러리 로딩
		try 
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //
		}catch (ClassNotFoundException e) 
		{
			e.printStackTrace();
			return false;
		}
			
		//2. 데이터베이스에 연결한다. (Connection 객체를 연결)
		String host = "jdbc:mysql://192.168.0.27:3306/news"; //ezen은 데이터베이스 이름
		host += "?useUnicode=true&characterEncoding=utf-8";
		host += "&serverTimezone=UTC";
		
		
		try 
		{
			conn = DriverManager.getConnection(host, "root", "ezen");
			//데이터베이스  연결해주겠다. 
			stmt = conn.createStatement();
		}catch (SQLException e) 
		{
			e.printStackTrace();
			return false; //실패 했다는 뜻임. 그래서 false로 돌려줌.
		}
		//반환된 결과를 가져옴
		System.out.println("데이터베이스 연결에 성공했습니다.");
		return true;
	}
	
	//DB연결을 닫는다.
	public void DBClose()
	{
		
		//4. 연결을 닫는다.
		try 
		{
			//!!!조심!!! 역 순서대로(작은 범위 먼저) 닫아줘야 함.
			stmt.close();
			conn.close();
		}catch (SQLException e) 
		{
			e.printStackTrace();
		}
		
		
	}
	
	//Insert,Delete,Update를 실행한다.
	public boolean RunSQL(String sql)
	{
		try 
		{
			stmt.executeUpdate(sql);
		}catch (SQLException e) 
		{
			e.printStackTrace();
			return false; //구동 시켰는데 실패했다는 뜻 -> 오류난 거.
		}
		return true; //예외처리가 안되면 
	}
	
	//ResetSet을 Next 처리한다.
	public boolean Next()
	{
		try 
		{
			return rs.next(); //메소드가 성공하면 즉시 종료
		} catch (SQLException e) 
		{
			e.printStackTrace();
			return false;   //메소드가 실패하면 위로 올라감.
		}
		//return true;해도 아무 의미 없음. 왜냐면 여기 위치까지 안 내려옴.
	}
	
	//ResultSet에서 GetString을 처리한다. 결과에서 받은 거 
	public String getValue(String column)
	{
		try 
		{
			return rs.getString(column);
		} catch (SQLException e) 
		{
			e.printStackTrace();
			return null; //문자열이기 때문에 null을 해줘야 함. 
		}
	}
	
	
	//Select를 실행한다.
	public boolean RunSelect(String sql)
	{
		try 
		{
			rs = stmt.executeQuery(sql); //결과들이 resultset으로 받음.
		} catch (SQLException e) 
		{
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	//작은 따옴표 한 개를 두 개로 처리한다. (Replace 줄임말)
	public String _R(String data)  //문자열이 들어왔을 때
	{
		if(data == null) return null;
		return data.replace("'", "''");
	}
	
	//문자열의  숫자사이에 반점(,)을 제거한다.
	public String _D(String data) //문자열이 들어왔을 때
	{	
		if(data == null) return null;
		return data.replace(",", "");
	}
}
