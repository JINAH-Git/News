//기사 내용의 명사 정보를 모델(Model)로 부터 처리하기 위한 DTO클래스(Data Transfer Object)
package news.dto;

import news.dao.*;
import news.vo.*;
import java.util.*;

public class WordcloudDTO extends DBManager
{
	//상위 카테고리 하나의 워드클라우드
	public ArrayList<WordcloudVO> GetNoun(String cate1,String date,String time)
	{
		String[] times = time.split("~");
		date = date.substring(0,13);
		String startTime = date.replaceAll("[가-힣]","").replaceAll(" ","-") + " " + times[0].replace(" ","") + ":00";
		String endTime = date.replaceAll("[가-힣]","").replaceAll(" ","-") + times[1] + ":00";
		startTime = "2023-10-04 00:00:00";
		endTime = "2023-10-04 13:00:00";
		if(cate1.equals("생활/문화")) cate1 = "생활,문화";
		if(cate1.equals("IT/과학")) cate1 = "IT,과학";
		ArrayList<WordcloudVO> list = new ArrayList<WordcloudVO>();
		WordcloudVO vo = null;
		this.DBOpen();
		String sql = "";
		sql  = "select a.wcnoun as wcnoun,sum(a.wccount) as wccount from wordcloud a ";
		sql += "inner join refinedata b on a.cdno = b.cdno ";
		if(cate1.equals("전체"))
		{
			sql += "where b.rdrefine = '2' and b.rddate between '" + startTime + "' and '" + endTime + "' " ;		
		}else
		{
			sql += "where b.rdrefine = '2' and b.rdtopcat = '" + cate1 + "' and b.rddate between '" + startTime + "' and '" + endTime + "' " ;			
		}
		sql += "group by a.wcnoun order by wccount desc limit 20 ";
		System.out.println(sql);
		this.RunSelect(sql);
		while(this.Next() == true)
		{
			vo = new WordcloudVO();
			vo.setNoun(this.getValue("wcnoun"));
			vo.setCnt(this.getValue("wccount"));
			list.add(vo);
		}
		this.DBClose();
		
		return list;
	}
		
	//상위 카테고리와 하위 카테고리와의 워드클라우드
	public ArrayList<WordcloudVO> GetNoun(String cate1,String cate2)
	{
		ArrayList<WordcloudVO> list = new ArrayList<WordcloudVO>();
		WordcloudVO vo = null;
		this.DBOpen();
		String sql = "";
		sql  = "select a.wcnoun as wcnoun,sum(a.wccount) as wccount from wordcloud a ";
		sql += "inner join refinedata b on a.cdno = b.cdno ";
		sql += "where rdrefine = '2' and rdtopcat = '" + cate1 + "' and rdbtmcat = '" + cate2 + "' ";
		sql += "group by a.wcnoun order by wccount desc limit 40 ";
		//System.out.println(sql);
		this.RunSelect(sql);
		while(this.Next() == true)
		{
			vo = new WordcloudVO();
			vo.setNoun(this.getValue("wcnoun"));
			vo.setCnt(this.getValue("wccount"));
			list.add(vo);
		}
		this.DBClose();
		
		return list;
	}
		
	//게시물 하나의 워드클라우드
	public ArrayList<WordcloudVO> GetNoun(int no)
	{
		ArrayList<WordcloudVO> list = new ArrayList<WordcloudVO>();
		WordcloudVO vo = null;
		this.DBOpen();
		String sql = "";
		sql  = "select wcnoun,wccount from wordcloud ";
		sql += "where cdno = '" + no + "' ";
		System.out.println(sql);
		this.RunSelect(sql);
		while(this.Next() == true)
		{
			vo = new WordcloudVO();
			vo.setNoun(this.getValue("wcnoun"));
			vo.setCnt(this.getValue("wccount"));
			list.add(vo);
		}
		this.DBClose();
	
		return list;
	}
}
