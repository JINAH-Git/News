//정제한 원천 데이터의 자료를 담기위한 VO(Value Object)클래스
package news.vo;

public class RefinedataVO 
{
	int    cdno;           //기사관리번호
	String rdrefine;	   //정제차수
	String rdurl;          //기사 주소
	String rdtopcat;       //상위카테고리
	String rdbtmcat;       //하위카테고리
	String rdmedia;        //신문사
	String rdtitle;		   //제목
	String rddate;		   //날짜
	String rdwriter;       //기자이름
	String rdnote;         //내용
	String rdimg;          //사진
	int    rdcatcount;     //카테고리별 카운트수
	
	public int getCdno() 		{	return cdno;		}
	public String getRdrefine() {	return rdrefine;	}
	public String getRdurl() 	{	return rdurl;		}
	public String getRdtopcat() {	return rdtopcat;	}
	public String getRdbtmcat() {	return rdbtmcat;	}
	public String getRdmedia() 	{	return rdmedia;		}
	public String getRdtitle() 	{	return rdtitle;		}
	public String getRddate() 	{	return rddate;		}
	public String getRdwriter() {	return rdwriter;	}
	public String getRdnote() 	{	return rdnote;		}
	public String getRdimg() 	{	return rdimg;		}
	public int getRdcatcount() 	{	return rdcatcount;		}
	
	public void setCdno(int cdno) 			 {	this.cdno = cdno;			}
	public void setRdrefine(String rdrefine) {	this.rdrefine = rdrefine;	}
	public void setRdurl(String rdurl)		 {	this.rdurl = rdurl;			}
	public void setRdtopcat(String rdtopcat) {	this.rdtopcat = rdtopcat;	}
	public void setRdbtmcat(String rdbtmcat) {	this.rdbtmcat = rdbtmcat;	}
	public void setRdmedia(String rdmedia) 	 {	this.rdmedia = rdmedia;		}
	public void setRdtitle(String rdtitle)   {	this.rdtitle = rdtitle;		}
	public void setRddate(String rddate)     {	this.rddate = rddate;		}
	public void setRdwriter(String rdwriter) {	this.rdwriter = rdwriter;	}
	public void setRdnote(String rdnote) 	 {	this.rdnote = rdnote;		}	
	public void setRdimg(String rdimg) 		 {	this.rdimg = rdimg;			}
	public void setRdcatcount(int rdcatcount)  {	this.rdcatcount = rdcatcount;			}
}
