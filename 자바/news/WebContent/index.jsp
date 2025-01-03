<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="/news/style/index.css" />
<script src="https://cdn.amcharts.com/lib/4/core.js"></script>
<script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
<script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>
<%@ include file="./include/head.jsp"%>
<%
NetworkgraphDTO nwdto = new NetworkgraphDTO();
RefinedataDTO rddto = new RefinedataDTO();
ClusteringDTO ctdto = new ClusteringDTO();

//ArrayList<ClusteringVO> clist = ctdto.CtCount();   
//ArrayList<ClusteringVO> clist = ctdto.CtList();    //뉴스 갯수를 출력하기 위해서 작성
ArrayList<ClusteringVO> ctlist = ctdto.CtCount();    //클러스터 갯수를 출력하기 위해서 작성
ArrayList<ClusteringVO> nlist = ctdto.NewsCount();   //뉴스 갯수를 출력하기 위해서 작성
ArrayList<RefinedataVO> listshow = ctdto.NewsList(); //팝업창을 위해서 작성
%>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.css" rel="stylesheet" type="text/css" />
<style type="text/css">
</style>
<script>
$(function(){
	$('.content2_cloud > div').hide();
	$('.total_frm a').click(function() {
		$(".content2_cloud").empty('jqcloud');
		$("#WCloading").show();
		const category = $(this).text();
		$.ajax({
	        type:"get",
	        url:"wordcloud.jsp",
	        dataType:"json",
	        data:
	        {
	       		cate1:category,
	       		date: '<%= rddto.GetNow() %>',
	       		time: '<%= rddto.GetTime() %>',
	       		code:"1"
	        },
	        success: function(data){
	        	$("#WCloading").hide();
	        	if($(".content2_cloud").hasClass('jqcloud') == true) $(".content2_cloud").jQCloud('update',data);
	        	else $(".content2_cloud").jQCloud(data);
	        },
	        error:function(){
	        	alert("에러");       
	        }
		})
		$('.content2_cloud > div').hide().filter(this.hash).fadeIn();
		$('.total_frm a').removeClass('active');
		$(this).addClass('active');
		return false;
	}).filter(':eq(0)').click();
});

$(document).ready(function(){
	var imgs;
	var img_count;
	img_position = 1;
	
	imgs = $(".slide_ul");
	img_count = imgs.children().length;
	
	//버튼을 클릭했을 때 함수 실행
	$('.btn_prev').click(function(){
		back();
	});
	
	$('.btn_next').click(function(){
		next();
	});
	
	
	function back(){
		if(1 < img_position){
			imgs.animate({
				left:'+=1150px'
			});
			img_position--;
		}
	}
	
	function next(){
		if(img_count > img_position){
			imgs.animate({
				left:'-=1150px'
			});
			img_position++;
		}
	}
});
var x = [];
var y = [];
</script>
<!-- 컨텐츠들 전체 시작 -->
<div id="content_wrap" style="width:100%;margin: 0px;">
	<!-- 컨텐츠 1 시작 -->
	<div class="content1">
		<!-- 뉴스 정보들 시작 -->
		<div class="content_news">
			<div class="news_info">
				<p class="news_main_title"><b>오늘의 이슈</b></p><br>
				<p class="news_total"><b>분석 대상 뉴스</b>
				<%
				for(ClusteringVO vo : nlist)
				{
					%>
					<%= vo.getCtnews() %>건
					<%
				}
				%>
				</p>
				<p class="today_cluster">
				<b>뉴스 클러스터 </b>
				<%
				for(ClusteringVO vo : ctlist)
				{
					%>
					<%= vo.getCtcount() %>건
					<%
				}
				%>
				</p>
				<p class="news_wdate"><b>분석기준</b> 2023년 10월 04일 (수) <!-- 날짜 들어가는 부분에 rddto.GetNow() 값을 넣어야함 -->
				<%= rddto.GetTime() %><p>
			</div>
			<!-- 오늘의 이슈 기사 제목들 시작 -->
			<%
			ArrayList<ClusteringVO> list = ctdto.CtList();
			%>
			<div class="news_list">
				<ul class="news_list_sort">
					<%
					for (ClusteringVO vo : list)
					{
						%>
						<li class="swiper-slide">
							<a href="#"><p class="news_title"><%= vo.getCttitle() %></p>
							<p class="news_count"><%= vo.getCtcount() %>건</p></a>
						</li>
						<%
					}
					%>
				</ul>
			</div>
			<!-- 오늘의 이슈 기사 제목들 끝 -->
		</div>
		<!-- 뉴스 정보들 끝 -->
		<!-- 오늘의 이슈 슬라이드쇼 시작 -->
		<div class="news_photo_frm">
			<div class="controls_left">
				<button type="button" class="btn_prev">이전 슬라이드</button>
			</div>
			<!-- 뉴스 제목과 뉴스 사진 시작 -->
			<div class="slide_frm">
			<!-- 뉴스 제목 틀 시작 -->
				<!-- 슬라이드 틀 시작 -->
				<ul class="slide_ul">
					<%
					for(RefinedataVO vo : listshow)
					{
						%>
						<li class="slide_li">
							<div class="news_photo_title">
								<div class="title"><b><%= vo.getRdtitle() %></b></div>
								<div class="news_photo_wdate"><p>2023년 10월 04일 (수)</p></div> <!-- 날짜 들어가는 부분에 rddto.GetNow() 값을 넣어야함 -->
							</div>
						<!-- 뉴스 제목 틀 끝 -->
						<!-- 뉴스 사진 시작 -->
						<%
						String imgSrc = vo.getRdimg();
						if(!imgSrc.equals("이미지 없음"))
						{
							%>
							<div class="news_slide_frm">
								<img src="<%= vo.getRdimg() %>" onClick="open_pop(<%= vo.getCdno() %>);" style="width:800px;height:450px; cursor: pointer;"></img> <!-- src에 이미지주소 넣기 -->
							</div>
							<%
						}else
						{
							%>
							<div class="news_slide_frm">
								<img src="img/icon.png" onClick="open_pop(<%= vo.getCdno() %>);" style="width:800px;height:450px; cursor: pointer;"></img> <!-- src에 이미지주소 넣기 -->
							</div>
							<%
						}
						%>
						</li>
						<%
					}
					%>
				</ul>
				<!-- 슬라이드 틀 끝 -->
				<!-- 뉴스 사진 끝 -->
				<!-- 슬라이드 쇼 시작, 멈춤 조작 -->
				<div class="slide_s_r">
					<button type="button" class="btn_auto"></button>
					<div class="btn_page">
						<button type="button" class="1"></button>
						<button type="button" class="2"></button>
						<button type="button" class="3"></button>
					</div>
				</div>
			</div>
			<!-- 뉴스 제목과 뉴스 사진 끝 -->
			<!-- 슬라이드쇼 오른쪽 버튼 -->
			<div class="controls_right">
				<button type="button" class="btn_next">다음 슬라이드</button>
			</div>
		</div>
		<!-- 오늘의 이슈 슬라이드쇼 끝 -->
	</div>
	<!-- 컨텐츠 1 끝 -->
	<!-- 뉴스 팝업창 시작 -->
	<%
		for(RefinedataVO vo : listshow)
		{
			%>
			<!-- Modal 바깥 -->
			<div id="myModal<%= vo.getCdno() %>" class="modal">
				<!-- Modal 안쪽 -->
				<div class="modal-content">
					<!-- 닫기1 버튼 -->
					<div style="cursor:pointer;" onClick="close_pop(<%= vo.getCdno() %>);">
						<img src="/news/img/close.png" style="width:25px;float:right"></img>
					</div>
					<!-- 닫기 1버튼 끝 -->
					<!-- 뉴스 작성 정보 -->
					<div>
						<b style="font-size:20pt;"><img src="<%= vo.getRdmedia() %>" width="70px"><br></b>
						<a href="<%= vo.getRdurl() %>" target="_blank" style="border: 2px solid black; font-size: 14px; padding: 2px;">기사원문</a>
						<p style="font-size:20pt;"><%= vo.getRdtitle() %></p>
						<p> <%= vo.getRdwriter() %> | <%= vo.getRddate() %></p>
					</div>
					<!-- 뉴스 작성 정보 끝 -->
					<!-- 뉴스 내용 -->
					<div>
						<%= vo.getRdnote() %>
					</div>
					<!-- 뉴스 내용 끝 -->
					<!-- 워드 클라우드 -->
					<div class="word_cloud_pop" style="text-align:center;">
						<b style="font-size:20pt;">워드 클라우드<br></b>
						<div id="wordcloud<%= vo.getCdno() %>" style="width: 880px; height: 500px; border: 1px solid black;"></div>
					</div>
					<!-- 워드 클라우드 끝 -->
					<!-- 네트워크 그래프 -->
					<div class="network_pop" style="text-align:center;border:1px solid black;margin-top:40px; width:880px;height:500px;">
						<b style="font-size:20pt;">네트워크 그래프<br></b>
						<div id="mynetwork<%=vo.getCdno()%>"></div>
					</div>
					<!-- 네트워크 그래프 끝-->
					<!-- 닫기 버튼 2-->
					<div style="width:880px;height:50px">
						<input type="button" onClick="close_pop(<%= vo.getCdno() %>);" value="닫기" style="cursor:pointer;float:right;margin:25px;width:80px;height:30px">
					</div>
					<!-- 닫기 버튼 2 끝 -->
				</div>
				<!--Modal 안쪽 끝-->
			</div>
		    <!--Modal 바깥 끝-->
		    <%
	 	}
	 	%>
	<!-- 컨텐츠 2 시작 -->
	<div class="content2">
		<div class="content2_frm">
			<!-- 왼쪽 기준 1구간 시작 -->
			<div class="frm">
				<!-- 오늘의 키워드, 분석 대상 뉴스 건 시작 -->
				<div class="today_frm">
					<div class="today_keyword"><b>오늘의 키워드</b></div>
					<div class="today_count">
					<b>분석 대상 뉴스 
					<%
					for(ClusteringVO vo : nlist)
					{
						%>
						<%= vo.getCtnews() %>건
						<%
					}
					%>
					</b>
					</div>
					<div class="today_wdate"><b>분석기준 2023년 10월 04일 (수)&nbsp;<%= rddto.GetTime() %></b></div> <!-- 날짜 들어가는 부분에 rddto.GetNow() 값을 넣어야함 -->
				</div>
				<!-- 오늘의 키워드, 분석 대상 뉴스 건 끝 -->
				<!-- 상위 카테고리 시작 -->
				<div class="tab" style="float:left; width:800px; min-height:400px;"> 
					<ul class="total_frm">
						<li><a href=".cloud_conts0">전체</a></li>
						<li><a href=".cloud_conts1">정치</a></li>
						<li><a href=".cloud_conts2">경제</a></li>
						<li><a href=".cloud_conts3">사회</a></li>
						<li><a href=".cloud_conts4">생활/문화</a></li>
						<li><a href=".cloud_conts5">세계</a></li>
						<li><a href=".cloud_conts6">IT/과학</a></li>
					</ul>
					<!-- 전체, 상위 카테고리 클라우들 시작 -->
					<img id="WCloading" src="img/Spinner-1s-200px (2).gif" style="width: 200px; height: 200px; position: absolute; top: 200px; left: 300px;">
					<div class="content2_cloud"></div>
					<ul class="cloud_conts">
						<li class="person">인물 </li>
						<li class="region">장소 </li>
						<li class="agency">기관</li>
					</ul>
				</div>
				<!-- 상위 카테고리 끝 -->
			</div>
			<!-- 왼쪽 기준 1구간 끝 -->
			<!-- 전체, 상위 카테고리 클라우들 끝 -->
			<!-- 오늘의 뉴스 현황 그래프 시작 -->
			<div class="news_now_frm">
				<div class="now_title"><b>오늘의 뉴스 현황</b></div>
				<div>
					<div class="now_wdate">2023년 10월 04일 (수)</div><!-- 날짜 들어가는 부분에 rddto.GetNow() 값을 넣어야함 -->
					<div class="now_count">
					<%
					HashMap<String,Integer> catlist = rddto.GetTodayTotal(rddto.GetNow());
					for(HashMap.Entry<String,Integer> graph : catlist.entrySet()) 
					{  
						%>
						<script>
							x.push('<%= graph.getKey() %>');
							y.push('<%= graph.getValue() %>');
						</script>
						<%
					}
					%>
					</div>
					<div style="border-bottom: 1px solid lightgray;"></div>
					<div class="now_graph"></div>		
				</div>
			</div>
		<!-- 오늘의 뉴스 현황 그래프 끝 -->
		</div>
	</div>
	<!-- 컨텐츠 2 끝 -->
</div>
<!-- 컨텐츠들 끝 -->
<%@ include file="./include/tail.jsp"%>
<script src="js/bargraph.js"></script>