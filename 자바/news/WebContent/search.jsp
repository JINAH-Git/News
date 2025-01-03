<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./include/head.jsp"%>
<link rel="stylesheet" type="text/css" href="/news/style/search.css" />
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.css" rel="stylesheet" type="text/css" />
<style type="text/css"></style>
<%
request.setCharacterEncoding("UTF-8");
//검색어(search)
String search = request.getParameter("search_kyword");
if(search == null && session.getAttribute("search")!=null)
{
	session.setAttribute("search",search);
}
String topcat = request.getParameter("topcat");
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
	window.location.href="index.jsp";
	</script>
	<%
	return;
}else if(search != null && session.getAttribute("popup") == null && topcat == null)
{
	%>
	<script>
	var search = "<%= request.getParameter("search_kyword") %>";
	location.href = "searchok.jsp?search_kyword=" + search + "&page=" + <%= curPage %>;
	</script>
	<%
}else if(search != null && session.getAttribute("popup") == null && topcat != null)
{
	%>
	<script>
	var topcat = "<%= request.getParameter("topcat") %>";
	var search = "<%= request.getParameter("search_kyword") %>";
	location.href = "searchok.jsp?search_kyword=" + search + "&page=" + <%= curPage %> + "&topcat=" + topcat;
	</script>
	<%
}


RefinedataDTO rddto = new RefinedataDTO();
%>
<!-- 내용 -->
<script>
	var search = "<%= request.getParameter("search_kyword") %>";
	var topcat = "<%= request.getParameter("topcat") %>";
	//상위카테고리 체크박스선택에 따른 뉴스기사 보여주기
	function getcheckbox(){
		var selectedValues = [];
		
		$(".typelisttotal").find('input:checked').each(function(index){
			//console.log("Value: " + $(this).val(),", 검색어:" + search);
			selectedValues.push("'" + $(this).val() + "'");
		});
		//alert(selectedValues);
		if(selectedValues != null)
		{
			location.href = "searchok.jsp?search_kyword=" + search + "&topcat=" + selectedValues;	
		}else
		{
			location.href = "searchok.jsp?search_kyword=" + search + "&topcat= ";
		}
		
	};
</script>
<div class="wrap_cont">
	<!-- navigation bar -->
	<div class="navg">
		<span class="navgtxt"><b>홈 > 검색</b></span>
	</div>
	<!-- navigation bar 끝 -->
	<!-- word cloud -->
	<!-- word cloud 끝 -->
	<span class="count"><b> 검색어: <%= search %>  </b></span>
	<hr style="width:1200px;margin-bottom:30px;">
	<!-- 검색 컨텐츠 시작 -->
	<div class="searchcnt">
		<!-- 검색 분류 영역 시작 -->
		<div class="typearea">
			<span class="totalline">
				<b style="font-size:22px">통합분류</b>
			</span>
			<!-- 분류 목록 시작 -->
			<div class="typelisttotal">
				<%
				int getnwstotal = 0;  //검색어에 해당하는 기사 건수
				if(session.getAttribute("popup") != null)
				{
					HashMap<String,Integer> catlist = rddto.GetCatTotal(search);
					Collection<Integer> cntvalues = catlist.values();

					for(HashMap.Entry<String,Integer> pages : catlist.entrySet()) 
					{  
						if(request.getParameter("topcat").contains(pages.getKey()))
						{
							getnwstotal += pages.getValue();
						}
					}  

					int count = 0;
					%>
					<div class="typelist">
						<span style="display:inline-block; width:150px;">
							<% String key = "정치"; %>정치<small><% if(catlist.get(key)==null){count=0;}else{count=catlist.get(key);}%>(<%= count %>)</small>
						</span>
						<input class="topcat" type="checkbox" value="<%= key %>" onclick="getcheckbox()" 
					  	<%= request.getParameter("topcat").contains(key) ? "checked" : "" %>>
					</div>
					<div class="typelist">
						<span style="display:inline-block; width:150px;">
							<% key = "경제"; %>경제<small><% if(catlist.get(key)==null){count=0;}else{count=catlist.get(key);}%>(<%= count %>)</small>
						</span>
						<input class="topcat" name="topcat2" type="checkbox" value="<%= key %>" onclick="getcheckbox()"
						<%= (request.getParameter("topcat") != null && request.getParameter("topcat").contains(key)) ? "checked" : "" %>>
					</div>
					<div class="typelist">
						<span style="display:inline-block; width:150px;">
							<% key = "사회"; %>사회<small><% if(catlist.get(key)==null){count=0;}else{count=catlist.get(key);}%>(<%= count %>)</small>
						</span>
						<input class="topcat" type="checkbox" value="<%= key %>" onclick="getcheckbox()"
						<%= (request.getParameter("topcat") != null && request.getParameter("topcat").contains(key)) ? "checked" : "" %>>
					</div>
					<div class="typelist">
						<span style="display:inline-block; width:150px;">
							<% key = "생활,문화"; %>생활/문화<small><% if(catlist.get(key)==null){count=0;}else{count=catlist.get(key);}%>(<%= count %>)</small>
						</span>
						<input class="topcat" type="checkbox" value="<%= key %>" onclick="getcheckbox()"
						<%= (request.getParameter("topcat") != null && request.getParameter("topcat").contains(key)) ? "checked" : "" %>>
					</div>
					<div class="typelist">
						<span style="display:inline-block; width:150px;">
							<% key = "세계"; %>세계<small><% if(catlist.get(key)==null){count=0;}else{count=catlist.get(key);}%>(<%= count %>)</small>
						</span>
						<input class="topcat" type="checkbox" value="<%= key %>" onclick="getcheckbox()"
						<%= (request.getParameter("topcat") != null && request.getParameter("topcat").contains(key)) ? "checked" : "" %>>
					</div>
					<div class="typelist">
						<span style="display:inline-block; width:150px;">
							<% key = "IT,과학"; %>IT/과학<small><% if(catlist.get(key)==null){count=0;}else{count=catlist.get(key);}%>(<%= count %>)</small>
						</span>
						<input class="topcat" type="checkbox" value="<%= key %>" onclick="getcheckbox()"
						<%= (request.getParameter("topcat") != null && request.getParameter("topcat").contains(key)) ? "checked" : "" %>>
					</div>
					<%
				}
				%>
			</div>
			<!-- 분류 목록 종료 -->
			<!-- 검색 결과 영역 시작 -->
			<div class="searchwrap">
				<h2 style="margin-top:0px;text-align:center;">
					<span id="intcolor"><%= search %></span>(이)가 제목에 들어간 뉴스 검색 결과 <span id="intcolor">
					<%= getnwstotal  %></span> 건입니다.</h2>
				<hr style="width:950px;margin-bottom:30px;">
				<!-- 검색 결과 뉴스 리스트 영역 시작 -->
				<%
				if(session.getAttribute("popup") != null && session.getAttribute("popup").equals("empty"))
				{
					%>
					<br><br><h2 style="margin-top:0px;"><span id="intcolor"><%= search %></span> 검색 결과가 없습니다.</h2>
					<%
					session.removeAttribute("popup");
				}else if((ArrayList<RefinedataVO>)session.getAttribute("popup") != null)
				{
					ArrayList<RefinedataVO> searchpop = (ArrayList<RefinedataVO>)session.getAttribute("popup");
					for(RefinedataVO vo : searchpop)
					{
					%>
						<table class="searchnewlist" border="0" onClick="open_pop(<%= vo.getCdno() %>);">
							<tr>
								<td class="td1" rowspan="3"><div class="listpic">
								<%
								if(!vo.getRdimg().equals("이미지 없음"))
								{
									%>
									<img class="listpic" src=<%= vo.getRdimg() %>>
									<%
								}else
								{
									%>
									<img class="listpic" src="/news/img/icon.png">
									<%
								}%>
								</div></td>
								<% 
								String title = vo.getRdtitle();
								if(title.contains(search))
								{
									title = title.replaceAll(search, "<span style='color:red';>" + search + "</span>");
								}
								%>
								<td class="td2"><div class="td2div1"><b><%= title %></b></div></td>
							</tr>
							<tr>
								<td class="td2"><div class="td2div2"><%= vo.getRdnote().replaceAll("[^\uAC00-\uD7A30-9a-zA-Z]"," ").replaceAll("[A-z]","").replaceAll("[0-9]","") %></div></td>
							</tr>
							<tr>
								<td class="td2">
									<div class="td2div3">
										<span class="td2div3span1"><img class=td2div3span1 src=<%= vo.getRdmedia() %>></span> &nbsp;&nbsp;
										<span class="td2div3span2"> &nbsp;<%= vo.getRdtopcat() %> > <%= vo.getRdbtmcat() %> </span> &nbsp;&nbsp;
										<span class="td2div3span3"><%= vo.getRddate() %></span>
										<%
										if(vo.getRdwriter().equalsIgnoreCase("None"))
										{
											%>
											<span class="td2div3span4"> </span>
											<%
										}else
										{
											%>
											<span class="td2div3span4"> | <%= vo.getRdwriter() %></span>
											<%
										}%>
									</div>
								</td>
							</tr>
						</table>
					<%
					}					
					for(RefinedataVO vo2 : searchpop)
					{
						%>
						<!-- Modal 바깥 -->
						<div id="myModal<%= vo2.getCdno() %>" class="modal">
							<!-- Modal 안쪽 -->
							<div class="modal-content">
								<!-- 닫기1 버튼 -->
								<div style="cursor:pointer;" onClick="close_pop(<%= vo2.getCdno() %>);">
									<img src="/news/img/close.png" style="width:25px;float:right"></img>
								</div>
								<!-- 닫기 1버튼 끝 -->
								<!-- 뉴스 작성 정보 -->
								<div>
									<b style="font-size:20pt;"><img src="<%= vo2.getRdmedia() %>" width="70px"><br></b>
									<a href="<%= vo2.getRdurl() %>" target="_blank" style="border: 2px solid black; font-size: 14px; padding: 2px;">기사원문</a>
									<p style="font-size:20pt;"><%= vo2.getRdtitle() %></p>
									<p> <%= vo2.getRdwriter() %> | <%= vo2.getRddate() %></p>
								</div>
								<!-- 뉴스 작성 정보 끝 -->
								<!-- 뉴스 내용 -->
								<div>
									<%= vo2.getRdnote() %>
								</div>
								<!-- 뉴스 내용 끝 -->
								<!-- 워드 클라우드 -->
								<div class="word_cloud_pop" style="text-align:center;">
									<b style="font-size:20pt;">워드 클라우드<br></b>
									<div id="wordcloud<%= vo2.getCdno() %>" style="width: 880px; height: 500px; border: 1px solid black;"></div>
								</div>
								<!-- 워드 클라우드 끝 -->
								<div class="network_pop" style="text-align:center;border:1px solid black;margin-top:40px; width:880px;height:500px;">
									<b style="font-size:20pt;">네트워크 그래프<br></b>
									<div id="mynetwork<%=vo2.getCdno()%>"></div>
								</div>
								<!-- 닫기 버튼 2-->
								<div style="width:880px;height:50px">
									<input type="button" onClick="close_pop(<%= vo2.getCdno() %>);" value="닫기" style="cursor:pointer;float:right;margin:25px;width:80px;height:30px">
								</div>
								<!-- 닫기 버튼 2 끝 -->
							</div>
							<!--Modal 안쪽 끝-->
						</div>
					    <!--Modal 바깥 끝-->
					    <%
				 	}	
					session.removeAttribute("popup");
				}
				%>
				<!-- 검색 결과 뉴스 리스트 영역 끝 -->
			</div>
			<!-- 검색 결과 영역 끝 -->
		</div>
		<!-- 페이징 처리 -->
		<%
		int displayNum = 5; //화면에 보이는 페이지 번호의 개수
		int boardNum = 5; //한 페이지에 보이는 게시물의 개수
		int totalPage = (getnwstotal / boardNum) + 1;
		if(getnwstotal % boardNum == 0) totalPage--;
		
		int startBlock = curPage - (curPage % displayNum) + 1; //화면에 보이는 페이지의 시작 번호
		if(curPage % displayNum == 0) startBlock = curPage - displayNum + 1;
		
		int endBlock = startBlock + 4; //화면에 보이는 페이지의 끝 번호
		if(endBlock > totalPage) endBlock = totalPage; // 페이지의 끝 번호가 총 페이지 번호를 넘을 경우 총 페이지 번호가 끝 번호가 된다. 
		%>
		<div class="pagearea">
			<%
			if(startBlock > 1)
			{
				%>
				<a href="search.jsp?search_kyword=<%= search %>&page=<%= startBlock - 1 %>&topcat=<%= request.getParameter("topcat") %>"><img src="img/left.png" class="pageleft"></a>
				<%
			}
			for(int i = startBlock; i <= endBlock; i++)
			{
				if(curPage == i)
				{
					%>
					<a href="search.jsp?search_kyword=<%= search %>&page=<%= i %>&topcat=<%= request.getParameter("topcat") %>" class="pagenow"><%= i %></a>
					<%
				}else
				{
					%>
					<a href="search.jsp?search_kyword=<%= search %>&page=<%= i %>&topcat=<%= request.getParameter("topcat") %>" class="page"><%= i %></a>
					<%
				}
			}
			%>
			<%
			if(endBlock != totalPage)
			{
				%>
				<a href="search.jsp?search_kyword=<%= search %>&page=<%= endBlock + 1 %>&topcat=<%= request.getParameter("topcat") %>"><img src="img/right.png" class="pageright"></a>
				<%
			}
			session.setAttribute("search", search);
			System.out.println(request.getParameter("topcat"));
			System.out.println("search.jsp 마지막입니다.");
		%>
	</div>
		<!-- 페이징 처리 끝 -->
	</div>
</div>	
<!-- 검색 컨텐츠 끝 -->
<%@ include file="./include/tail.jsp"%>