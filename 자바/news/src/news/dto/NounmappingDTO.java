//명사들를 모델(Model)로 부터 처리하기 위한 DTO클래스(Data Transfer Object)
package news.dto;

import news.dao.*;

public class NounmappingDTO extends DBManager
{
	//워드클라우드
	public String GetNouns(String cdno)
	{
		this.DBOpen();
		String nouns = "";
		String sql = "";
		sql = "select nmnouns from nounmapping where cdno = '" + cdno + "' ";
		//System.out.println(sql);
		this.RunSelect(sql);
		if(this.Next() == true) nouns = this.getValue("nmnouns");
		this.DBClose();
		
		return nouns;
	}
	
	//명사 사전으로 속성 분류
	public String GetNounSort(String nounname)
	{
		this.DBOpen();
		String sort = "";
		String sql = "";
		sql = "select ndsort from noundict where ndnoun = '" + nounname + "' ";
		//System.out.println(sql);
		this.RunSelect(sql);
		if(this.Next() == true) sort = this.getValue("ndsort");
		this.DBClose();
		
		return sort;
	}
}
