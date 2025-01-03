//클러스터링 정보를 모델(Model)로 부터 처리하기 위한 DTO클래스(Data Transfer Object)
package news.dto;

import news.vo.*;
import news.dao.*;
import java.util.ArrayList;


public class ClusteringDTO extends DBManager
{
	//클러스터링 기사 불러오기
	public ArrayList<RefinedataVO> NewsList()
	{
		ArrayList<RefinedataVO> list1 = new ArrayList<RefinedataVO>();
		ArrayList<ClusteringVO> list2 = CtList();
		RefinedataVO vo = null;
		this.DBOpen();
		for(ClusteringVO vo2 : list2)
		{
			String sql  = "";
			sql  = "select  * from ";
			sql += "refinedata a join clustering b on a.cdno = b.cdno where a.rdrefine = '2' and b.cttitle = '" + _R(vo2.getCttitle()) + "' limit 1";
			this.RunSelect(sql);
			System.out.println(RunSelect(sql));
			
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
				list1.add(vo);
			}
		}
		this.DBClose();
		return list1;
	}
	
	//클러스터링 기사 갯수 5개 불러오기
	public ArrayList<ClusteringVO> CtList()
	{
		ArrayList<ClusteringVO> list = new ArrayList<ClusteringVO>();
		ClusteringVO vo = null;
		this.DBOpen();
		String sql  = "";
		sql  = "select c1.ctcluster, max(c1.cttitle) as cttitle, max(c2.ctcount) as ctcount ";
		sql	+= "from clustering c1 "; 
		sql	+= "join ( select ctcluster, count(*) as ctcount from clustering group by ctcluster ) "; 
		sql += "c2 on c1.ctcluster = c2.ctcluster "; 
		sql += "group by c1.ctcluster ";
		sql += "order by ctcount desc "; 
		sql += "limit 5";
		//System.out.println(sql);
		this.RunSelect(sql);
		//System.out.println(RunSelect(sql));
		
		//clustering테이블에 저장되어있는 cdno, cttitle, ctnluster값을 받아서 출력하기 위해서 VO에 저장해준다.
		while(this.Next() == true)
		{
			vo = new ClusteringVO();
			vo.setCttitle(this.getValue("cttitle"));
			vo.setCtcount(this.getValue("ctcount"));
			vo.setCtcluster(this.getValue("ctcluster"));
			list.add(vo);
		}
		this.DBClose();
		return list;
	}
	
	//분석 대상 뉴스 갯수 구하기
	public ArrayList<ClusteringVO> NewsCount()
	{
		ArrayList<ClusteringVO> list = new ArrayList<ClusteringVO>();
		ClusteringVO vo = null;
		this.DBOpen();
		
		String sql = "";
		sql  = "select sum(count) from count ";
		sql += "where ctdate = '20231004' and cttime = '0024'";
		this.RunSelect(sql);
		
		while(this.Next() == true)
		{
			vo = new ClusteringVO();
			String ctnews = this.getValue("sum(count)"); //문자열로 값을 다시 받아온다
	        try {
	            int ctnewsInt = Integer.parseInt(ctnews); //문자열로 받은 값을 정수로 변환한다
	            String FormatCtnews = String.format("%,d", ctnewsInt); //콤마로 구분된 문자열로 포맷팅을 활용해서 구성해준다
	            vo.setCtnews(FormatCtnews); //구성된 문자열을 설정
	        } catch (NumberFormatException e) {
	            //숫자로 변환할 수 없으면 에러 처리한다
	            e.printStackTrace();
	        }
	        list.add(vo);
		}
		this.DBClose();
		return list;
	}
	
	//뉴스 클러스터링 갯수 구하기
	public ArrayList<ClusteringVO> CtCount()
	{
		ArrayList<ClusteringVO> list = new ArrayList<ClusteringVO>();
		ClusteringVO vo = null;
		this.DBOpen();
		String sql = "";
		sql  = "select count(*) as ctcount ";
		sql += "from clustering";
		this.RunSelect(sql);
		
		while(this.Next() == true)
		{
			vo = new ClusteringVO();
			String ctcount = this.getValue("ctcount");
			try {
				int ctcountInt = Integer.parseInt(ctcount);
				String FormatCtcount = String.format("%,d", ctcountInt);
				vo.setCtcount(FormatCtcount);
			} catch (NumberFormatException e) {
				
				e.printStackTrace();
			}
			list.add(vo);
		}
		this.DBClose();
		return list;
	}
}
