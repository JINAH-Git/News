<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./include/head.jsp"%>
<link rel="stylesheet" type="text/css" href="/news/style/sub.css" />
<%
NetworkgraphDTO nwdto = new NetworkgraphDTO();

String cate1 = request.getParameter("cate1");
if(cate1 == null) cate1 = "정치";
String cate2 = request.getParameter("cate2");
if(cate2 == null) cate2 = "대통령실";
int curPage = 1; //현재 페이지 번호,초기에 1로 설정
try
{
	curPage = Integer.parseInt(request.getParameter("page")); //페이지 번호 클릭시 받아온다.		
}catch(Exception e){};

RefinedataDTO dto = new RefinedataDTO();
int totalData = dto.GetTotal(cate1,cate2); //해당 카테고리의 데이터 총 개수
%>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.css" rel="stylesheet" type="text/css" />
<style type="text/css">
</style>
<script>
//전제 오늘의 키워드
window.addEventListener('load',function(){
	$.ajax({
        type:"get",
        url:"wordcloud.jsp",
        dataType:"json",
        data:
        {
       		cate1:"<%= cate1 %>", 	
       		cate2:"<%= cate2 %>",
       		code:"2"
        },
        success: function(data){
        	$(".content2_cloud").jQCloud(data);                       
        },
        error:function(){
        	alert("에러");       
        }
	})
});

</script>
<!-- 내용 -->
<div class="wrap_frm">
	<div class="wrap_cont">
		<!-- navigation bar -->
	<div class="navg">
		<span class="navgtxt"><b>홈 > <%= cate1 %> > <%= cate2 %></b></span>
	</div>
	<!-- navigation bar 끝 -->
	<!-- word cloud -->
	<!-- word cloud 끝 -->
	<span class="count"><b> 전체 건수 : <%= totalData %>건  </b></span>
	<hr style="width:1244px;margin-bottom: 20px;">
	<!-- 뉴스 기사  -->
	<div class="wrap_news">
		<div class="wrap_news_frm">
		<%
		ArrayList<RefinedataVO> list = dto.GetNewsList(cate1,cate2,curPage);
		for(RefinedataVO vo : list)
		{
			%>
			<!-- 뉴스  -->
			<div class="news">
				<div style="cursor:pointer;" onClick="open_pop(<%= vo.getCdno() %>);" class="news">
				<%
				if(!vo.getRdimg().equals("이미지 없음"))
				{
					%>
					<img src="<%= vo.getRdimg() %>" class="newsimg">
					<%
				}else
				{
					%>
					<img src="/news/img/icon.png" class="newsimg">
					<%
				}%>
				<div class="newstxt">
					<b style="overflow:hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; height: 50px;"><%= vo.getRdtitle() %></b>
					<p class="news_wdate"><%= vo.getRddate() %></p>
					<div class="newscon">
					<%= vo.getRdnote().replaceAll("[^\uAC00-\uD7A30-9a-zA-Z]"," ").replaceAll("[A-z]","").replaceAll("[0-9]","") %>
					</div>
					<div class="newswrt"><img src="<%= vo.getRdmedia() %>" width="30px;"> | <%= vo.getRdwriter() %></div>
				</div>
				</div>
			</div>
			<%
		}
		%>
		</div>
		<!-- 하위 클라우들 시작 -->
		<div class="content2_cloud_frm">
			<div class="1top" style="text-align: left;font-size: 22px;position:relative;left:10px;margin-top: 10px;">오늘의 키워드: <%= cate1 %></div>
			<div class="1top_wdate" style="margin: 0 atuo;position: absolute;margin-top: 10px;font-size: 16px;left:10px;">2023.10.04(수)</div>
			<div class="content2_cloud">
				<div class="cloud_sort">
					<ul>
						<li class="person">인물 </li>
						<li class="region">장소 </li>
						<li class="agency">기관</li>
					</ul>
				</div>
			</div>
		</div>
		<!-- 하위 클라우들 끝 -->
		<%
		for(RefinedataVO vo2 : list)
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
					<!-- 네트워크 그래프 -->
					<div class="network_pop" style="text-align:center;border:1px solid black;margin-top:40px; width:880px;height:500px;">
						<b style="font-size:20pt;">네트워크 그래프<br></b>
						<div id="mynetwork<%=vo2.getCdno()%>"></div>
					</div>
					<!-- 네트워크 그래프 끝-->
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
	 	%>
	</div>
	<!-- 뉴스 기사 끝-->
	<%
	int displayNum = 5; //화면에 보이는 페이지 번호의 개수
	int boardNum = 5; //한 페이지에 보이는 게시물의 개수
	int totalPage = totalData / boardNum + 1;
	if(totalData % boardNum == 0) totalPage--;
	int startBlock = curPage - (curPage % displayNum) + 1; //화면에 보이는 페이지의 시작 번호
	if(curPage % displayNum == 0) startBlock = curPage - displayNum + 1;
	int endBlock = startBlock + displayNum - 1; //화면에 보이는 페이지의 끝 번호
	if(endBlock > totalPage) endBlock = totalPage; // 페이지의 끝 번호가 총 페이지 번호를 넘을 경우 총 페이지 번호가 끝 번호가 된다. 
	%>
	<div class="pagearea">
		<%
		if(startBlock != 1)
		{
			%>
			<a href="sub.jsp?cate1=<%= cate1 %>&cate2=<%= cate2 %>&page=<%= startBlock - 1 %>"><img src="img/left.png" class="pageleft"></a>
			<%
		}
		%>
		<%
		for(int i = startBlock; i <= endBlock; i++)
		{
			if(curPage == i)
			{
				%>
				<a href="sub.jsp?cate1=<%= cate1 %>&cate2=<%= cate2 %>&page=<%= i %>" class="pagenow"><%= i %></a>
				<%
			}else
			{
				%>
				<a href="sub.jsp?cate1=<%= cate1 %>&cate2=<%= cate2 %>&page=<%= i %>" class="page"><%= i %></a>
				<%
			}
		}
		%>
		<%
		if(endBlock != totalPage)
		{
			%>
			<a href="sub.jsp?cate1=<%= cate1 %>&cate2=<%= cate2 %>&page=<%= endBlock + 1 %>"><img src="img/right.png" class="pageright"></a>
			<%
		}
		%>
	</div>
	<!-- 페이징 처리 끝 -->
</div>
<!-- 내용 끝-->	
<%@ include file="./include/tail.jsp"%>
