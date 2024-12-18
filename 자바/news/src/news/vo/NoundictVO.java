//명사사전 자료를 담기위한 VO(Value Object)클래스
package news.vo;

public class NoundictVO 
{
	String ndnoun;		//명사
	String ndsort;		//명사분류
	
	public String getNdnoun() {	return ndnoun;	}
	public String getNdsort() {	return ndsort;	}
	
	public void setNdnoun(String ndnoun) {	this.ndnoun = ndnoun;	}
	public void setNdsort(String ndsort) {	this.ndsort = ndsort;	}
	
}
