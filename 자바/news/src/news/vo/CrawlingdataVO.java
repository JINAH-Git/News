//크롤링한 데이터의 자료를 담기위한 VO(Value Object)클래스
//정제 차수 없는 이유:1차, 2차 정제하고 DB에 올림
package news.vo;

public class CrawlingdataVO 
{
	int    cdno;           //기사관리번호
	String cdurl;          //기사 주소
	String cdtopcat;       //상위카테고리
	String cdbtmcat;       //하위카테고리
	String cdmedia;        //신문사
	String cdtitle;		   //제목
	String cddate;		   //날짜
	String cdwriter;       //기자이름
	String cdnote;         //내용
	String cdimg;          //사진
	
	public int getCdno()		{	return cdno;		}
	public String getCdurl() 	{	return cdurl;		}
	public String getCdtopcat() {	return cdtopcat;	}
	public String getCdbtmcat() {	return cdbtmcat;	}
	public String getCdmedia()  {	return cdmedia;		}
	public String getCdtitle()  {	return cdtitle;		}
	public String getCddate()   {	return cddate;		}
	public String getCdwriter() {	return cdwriter;	}
	public String getCdnote()   {	return cdnote;		}
	public String getCdimg()    {	return cdimg;		}
	
	public void setCdno(int cdno) 			 {	this.cdno = cdno;			}
	public void setCdurl(String cdurl) 		 {	this.cdurl = cdurl;			}
	public void setCdtopcat(String cdtopcat) {	this.cdtopcat = cdtopcat;	}
	public void setCdbtmcat(String cdbtmcat) {	this.cdbtmcat = cdbtmcat;	}
	public void setCdmedia(String cdmedia) 	 {	this.cdmedia = cdmedia;		}
	public void setCdtitle(String cdtitle)   {	this.cdtitle = cdtitle;		}
	public void setCddate(String cddate)     {	this.cddate = cddate;		}
	public void setCdwriter(String cdwriter) {	this.cdwriter = cdwriter;	}
	public void setCdnote(String cdnote)     {	this.cdnote = cdnote;		}
	public void setCdimg(String cdimg)       {	this.cdimg = cdimg;			}

	
}
