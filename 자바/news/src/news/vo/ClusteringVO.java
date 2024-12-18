//클러스터링 자료를 담기위한 VO(Value Object)클래스
package news.vo;

public class ClusteringVO 
{
	int    ctno;		//클러스터관리번호
	int    cdno;        //기사관리번호
	String ctcluster;	//클러스터
	String cttitle;     //기사제목
	String ctcount;     //클러스터갯수
	String ctnews;      //분석뉴스갯수
	
	public int 	  getCtno() 	 {	return ctno;		}
	public int    getCdno() 	 {	return cdno;		}
	public String getCttitle()   {  return cttitle;     }
	public String getCtcluster() {	return ctcluster;	}
	public String getCtcount()   {	return ctcount;	    }
	public String getCtnews()    {	return ctnews;	    }
	
	public void setCdno(int cdno) 			   {	this.cdno = cdno;			}
	public void setCtno(int ctno)			   {	this.ctno = ctno;			}
	public void setCttitle(String cttitle)     {	this.cttitle = cttitle;	    }
	public void setCtcluster(String ctcluster) {	this.ctcluster = ctcluster;	}
	public void setCtcount(String ctcount) 	   {	this.ctcount = ctcount;	    }
	public void setCtnews(String ctnews) 	   {	this.ctnews = ctnews;	    }
	
}
