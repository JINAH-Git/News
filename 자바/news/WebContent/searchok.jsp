<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="news.dto.*" %>
<%@ page import="news.vo.*" %>
<%@ page import="java.util.*" %>     
<%@ page import="java.net.*" %>
<%
System.out.println("여기는 searchok.jsp입니다.");
request.setCharacterEncoding("UTF-8");
String search = request.getParameter("search_kyword");
String rdtopcat = request.getParameter("topcat");
int curPage = 1;
try
{
	curPage = Integer.parseInt(request.getParameter("page")); //페이지 번호 클릭시 받아온다.		
}catch(Exception e){};


if(search == null)
{
	%>
	<script>
		alert("검색어를 입력해주세요");
		window.location.href="search.jsp";
	</script>
	<%
}
if(rdtopcat == null)
{
	rdtopcat = "'정치','경제','사회','생활,문화','세계','IT,과학'";
}else if(rdtopcat.equals(""))
{
	rdtopcat = "";
	session.setAttribute("popup", "empty");		
	session.setAttribute("search", request.getParameter("search_kyword"));
	response.sendRedirect("search.jsp?search_kyword=" + URLEncoder.encode(search,"UTF-8"));
	return;
}

System.out.println("--------------------------------");
System.out.println("파라미터 :" + request.getParameter("search_kyword"));
System.out.println("세션       :" + session.getAttribute("search"));
System.out.println("팝업세션  :" + session.getAttribute("popup"));
System.out.println("상위카테고리:" + rdtopcat);
System.out.println("현재페이지 :" + curPage);
System.out.println("--------------------------------");

RefinedataDTO rddto = new RefinedataDTO();
ArrayList<RefinedataVO> list = rddto.GetSearchList(rdtopcat, search,curPage);
if(list.isEmpty())
{
	session.setAttribute("popup", "empty");	
	session.setAttribute("search", request.getParameter("search_kyword"));
}else
{
	session.setAttribute("popup", list);
	session.setAttribute("search", request.getParameter("search_kyword"));
}

response.sendRedirect("search.jsp?search_kyword=" + URLEncoder.encode(search,"UTF-8") + "&page=" + curPage +  "&topcat=" + URLEncoder.encode(rdtopcat,"UTF-8") );
%>