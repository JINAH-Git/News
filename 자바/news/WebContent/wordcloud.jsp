<%@ page language="java" contentType="text/json; charset=EUC-KR"
    pageEncoding="EUC-KR"%>    
<%@ page import="news.dto.*" %>
<%@ page import="news.vo.*" %>
<%@ page import="java.util.*" %>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%
String code = request.getParameter("code");
JSONObject data = null;
JSONArray arr = new JSONArray();
String json = null;
if(code.equals("1")) //상위카테고리 하나에 관한 워드클라우드
{
	String cate1 = request.getParameter("cate1");
	String date = request.getParameter("date");
	String time = request.getParameter("time");
	WordcloudDTO wdto = new WordcloudDTO();
	ArrayList<WordcloudVO> list = wdto.GetNoun(cate1,date,time);
	for(WordcloudVO vo : list)
	{
		data = new JSONObject();
		data.put("text",vo.getNoun());
		data.put("weight",vo.getCnt());	
		NounmappingDTO ndto = new NounmappingDTO();
		String sort = ndto.GetNounSort(vo.getNoun());
		if(sort.equals("인물")) data.put("color","#F78E00");
		else if(sort.equals("장소")) data.put("color","#23C4AE");
		else if(sort.equals("기관")) data.put("color","#0F58FF");
		else data.put("color","gray");
		arr.add(data);
	}
	json = arr.toJSONString();
	out.print(json);
}
else if(code.equals("2")) //상위카테고리와 하위 카테고리에 관한 워드클라우드
{
	String cate1 = request.getParameter("cate1");
	String cate2 = request.getParameter("cate2");
	WordcloudDTO wdto = new WordcloudDTO();
	ArrayList<WordcloudVO> list = wdto.GetNoun(cate1,cate2);
	for(WordcloudVO vo : list)
	{
		data = new JSONObject();
		data.put("text",vo.getNoun());
		data.put("weight",vo.getCnt());	
		NounmappingDTO ndto = new NounmappingDTO();
		String sort = ndto.GetNounSort(vo.getNoun());
		if(sort.equals("인물")) data.put("color","#F78E00");
		else if(sort.equals("장소")) data.put("color","#23C4AE");
		else if(sort.equals("기관")) data.put("color","#0F58FF");
		else data.put("color","gray");
		arr.add(data);
	}
	json = arr.toJSONString();
	out.print(json);
}else if(code.equals("3")) //게시물을 클릭했을 때 게시물에 해당되는 워드클라우드
{
	int no = Integer.parseInt(request.getParameter("no"));
	WordcloudDTO wdto = new WordcloudDTO();
	ArrayList<WordcloudVO> list = wdto.GetNoun(no);
	for(WordcloudVO vo : list)
	{
		data = new JSONObject();
		data.put("text",vo.getNoun());
		data.put("weight",vo.getCnt());	
		NounmappingDTO ndto = new NounmappingDTO();
		String sort = ndto.GetNounSort(vo.getNoun());
		if(sort.equals("인물")) data.put("color","#F78E00");
		else if(sort.equals("장소")) data.put("color","#23C4AE");
		else if(sort.equals("기관")) data.put("color","#0F58FF");
		else data.put("color","gray");
		arr.add(data);
	}
	json = arr.toJSONString();
	out.print(json);
}
%>
