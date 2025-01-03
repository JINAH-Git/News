//정제한 데이터 정보를 모델(Model)로 부터 처리하기 위한 DTO클래스(Data Transfer Object)
package news.dto;

import news.vo.*;
import news.dao.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class RefinedataDTO extends DBManager
{
	//현재날짜 얻기
	public String GetNow()
	{
		LocalDate now = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일  (E)");
		String timenow = now.format(formatter);
		return timenow;
	}
	
	//현재시간 얻기
	public String GetTime()
	{
		LocalTime now = LocalTime.now(); 
		int hour = now.getHour();
		
		String printhour = "";
		if( hour <= 9 )
		{
			printhour = "00:00 ~ 09:00";
		}else if( hour <= 13 )
		{
			printhour = "00:00 ~ 13:00";
		}else
		{
			printhour = "00:00 ~ 17:00";
		}
		
		return printhour;
	}

	//모달팝업 리스트 가져오기,sub.jsp
	public ArrayList<RefinedataVO> GetNewsList(String rdtopcat,String rdbtmcat,int curPage)
	{
		ArrayList<RefinedataVO> list = new ArrayList<RefinedataVO>();
		RefinedataVO vo = null;
		int startNo = (curPage - 1) * 5;
		this.DBOpen();
		String sql = "";
		sql  = "select cdno,rdurl,rdmedia,rdtitle,rddate,rdwriter,rdnote,rdimg from refinedata where rdrefine = '2' ";
		sql += "and rdtopcat = '" + rdtopcat + "' and rdbtmcat = '" + rdbtmcat + "' ";
		sql += "order by rddate desc ";
		sql += "limit " + startNo + ",5 ";
		System.out.println(sql);
		this.RunSelect(sql);
		while(this.Next() == true)
		{
			vo = new RefinedataVO();
			vo.setCdno(Integer.parseInt(this.getValue("cdno")));
			vo.setRdurl(this.getValue("rdurl"));
			vo.setRdmedia(this.getValue("rdmedia"));
			vo.setRdtitle(this.getValue("rdtitle"));
			vo.setRddate(this.getValue("rddate"));
			vo.setRdwriter(this.getValue("rdwriter"));
			vo.setRdnote(this.getValue("rdnote"));
			vo.setRdimg(this.getValue("rdimg"));
			list.add(vo);
		}
		this.DBClose();
		
		return list;
	}
	
	//전체 기사 개수를 얻는다
	public int GetTotal(String rdtopcat,String rdbtmcat)
	{
		int total = 0;
		this.DBOpen();
		
		String sql  = "";
		sql  = "select sum(count) as count from count ";
		sql += "where cttopcat = '" + rdtopcat + "' and ctbtmcat = '" + rdbtmcat + "' and cttime = '0024'";
		System.out.println(sql);
		this.RunSelect(sql);
		
		if(this.Next() == true)
		{
			total = Integer.parseInt(this.getValue("count"));
		}
		this.DBClose();
		
		return total;
	}
	//오늘 기사 카테고리별 개수 가져오기
	public HashMap<String, Integer> GetTodayTotal(String time)
	{
		HashMap<String, Integer> list = new HashMap<>();
		String gettime = time.substring(0, 14);
		gettime = gettime.replace(" ", "").replace("년", "").replace("월", "").replace("일", "");
		
		LocalTime now = LocalTime.now(); 
		int hour = now.getHour();
		String cttime = "";
		if( hour <= 9 )
		{
			gettime = Integer.toString(Integer.parseInt(gettime)-1);
			cttime = "0024";
		}else if( hour <= 13 )
		{
			cttime = "0009";
		}else if( hour <= 19 )
		{
			cttime = "0013";
		}else
		{
			cttime = "0017";
		}
		
		int total = 0;
		this.DBOpen();
		
		String sql  = "";
		sql  = "select cttopcat,sum(count) as count from count ";
		//sql += "where ctdate = '" + gettime + "' and cttime = '" + cttime + "' ";
		sql += "where ctdate = '20231004' and cttime = '0024'";
		sql += "group by cttopcat;";
		System.out.println(sql);
		this.RunSelect(sql);
		
		while(this.Next()==true)
		{
			list.put(this.getValue("cttopcat"), Integer.parseInt(this.getValue("count")));
		}
		this.DBClose();
		
		return list;
	}
	
	//검색창 검색어로 검색한 카테고리 건수
	public HashMap<String, Integer> GetCatTotal(String search)
	{
		System.out.println(search);
		String [] rdtopcat = { "정치", "경제", "사회" , "생활,문화", "세계", "IT,과학"};
		HashMap<String, Integer> list = new HashMap<>();
		this.DBOpen();
		String sql = "";
		
		for(int i = 0 ; i < rdtopcat.length; i++)
		{
			sql  ="select count(*) as count from refinedata where rdrefine = '2' and ";
			sql +="rdtopcat = '" + rdtopcat[i] + "' and match(rdtitle) against('" + this._R(search) + "')";	
			System.out.println(sql);
			this.RunSelect(sql);
			
			while(this.Next()==true)
			{
				list.put(rdtopcat[i] , Integer.parseInt(this.getValue("count")));
			}
		}
		
		this.DBClose();		
		return list;
	}
	
	//검색어를 포함하는 기사 리스트 search.jsp
	public ArrayList<RefinedataVO> GetSearchList(String rdtopcat,String search,int curPage)
	{
		System.out.println(search);
		ArrayList<RefinedataVO> list = new ArrayList<RefinedataVO>();
		RefinedataVO vo = null;
		int startNo = (curPage - 1) * 5;
		this.DBOpen();
		String sql = "";
		sql  = "select cdno,rdurl,rdtopcat,rdbtmcat,rdmedia,rdtitle,rddate,rdwriter,rdnote,rdimg from refinedata ";
		sql += "where rdrefine = '2' and rdtopcat in (" + rdtopcat + ") and match(rdtitle) against('" + this._R(search) + "') ";
		//sql += "order by rddate desc ";
		sql += "limit " + startNo + ",5 ";
		System.out.println(sql);
		this.RunSelect(sql);
		while(this.Next() == true)
		{
			vo = new RefinedataVO();
			vo.setCdno(Integer.parseInt(this.getValue("cdno")));
			vo.setRdurl(this.getValue("rdurl"));
			vo.setRdtopcat(this.getValue("rdtopcat"));
			vo.setRdbtmcat(this.getValue("rdbtmcat"));
			vo.setRdmedia(this.getValue("rdmedia"));
			vo.setRdtitle(this.getValue("rdtitle"));
			vo.setRddate(this.getValue("rddate"));
			vo.setRdwriter(this.getValue("rdwriter"));
			vo.setRdnote(this.getValue("rdnote"));
			vo.setRdimg(this.getValue("rdimg"));
			list.add(vo);
		}
		this.DBClose();
		
		return list;
	}
}

