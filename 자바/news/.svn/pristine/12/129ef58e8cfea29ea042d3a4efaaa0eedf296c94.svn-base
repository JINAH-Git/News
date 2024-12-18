<%@ page language="java" contentType="text/json; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="news.dto.*" %>
<%@ page import="news.vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>

<%
//번호 
String cdno = request.getParameter("cdno");
//json 객체와 배열 초기화
JSONObject jsonObj = null;
JSONArray jsonArray = new JSONArray();

//데이터베이스 연결 및 데이터 가져오기
NetworkgraphDTO nwdto = new NetworkgraphDTO(); 
ArrayList<NetworkgraphVO> list = nwdto.GetNetworkgraph(cdno);

for(NetworkgraphVO vo : list) {
    jsonObj = new JSONObject();
    jsonObj.put("noun1", vo.getNoun1());
    jsonObj.put("noun2", vo.getNoun2());
    jsonObj.put("weight", vo.getNwgweight());
    jsonArray.add(jsonObj);
}

out.println(jsonArray.toJSONString());
%>
