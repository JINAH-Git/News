<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="news.dto.*" %>
<%@ page import="news.vo.*" %>
<%@ page import="news.dao.*" %>
<%@ page import="java.util.*" %>     
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>메인 페이지</title>
		<link rel="stylesheet" type="text/css" href="/news/style/head.css" />
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@900&display=swap" rel="stylesheet">
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<!-- 글씨 스타일 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300&display=swap" rel="stylesheet">
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500&display=swap" rel="stylesheet">
		<!-- 상위 카테고리 글씨 -->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@700&display=swap" rel="stylesheet">
		
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@600&display=swap" rel="stylesheet">
		
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300&display=swap" rel="stylesheet">
		<script src="/news/js/jquery-3.7.0.js"></script>
		<!-- 워드클라우드를 위한 jqcloud -->
		<script src="https://golangkorea.github.io/js/jqcloud/jqcloud.min.js"></script>
		<link rel="stylesheet" href="https://golangkorea.github.io/js/jqcloud/jqcloud.min.css">
	</head>
	<style>
		#loading 
		{
			height: 150vw;
		}
		#loading-image
		{
		    margin-top: 300px;
		    height: 300px;
		    width: 300px;
		}
		.paging-div
		{
		  padding: 15px 0 5px 10px;
		  display: table;
		  margin-left: auto;
		  margin-right: auto;
		  text-align: center;
		}
	</style>
	<script> 
		vis = [];
        //팝업 Open 기능
        function open_pop(flag) {
             $('#myModal' + flag).show();
             $.ajax({
                type:"get",
                url:"wordcloud.jsp",
                dataType:"json",
                data:
                {
                	no: flag,
                	code: "3"
                },
                success: function(data){
                   $("#wordcloud" + flag).jQCloud(data);	                        
                },
                error:function(){
                	alert("에러");       
                }
			})
			/* Ajax 요청을 사용하여 서버에서 노드와 엣지 데이터 가져오기 */
			$.ajax({
		            type: "GET",
		            url: "d3.jsp", // 서버의 엔드포인트
		            data: {
		                cdno: flag // 관리번호 사용
		            },
		            dataType: "json",
		            success: function(response) {
		                // 데이터 변환 (실제 데이터 구조에 따라 변환 로직을 조정)
		                var nodesArray = []; //노드(명사) 받을 자리
		                var edgesArray = []; //엣지(연결선) 받을 자리
		                var addedNodes = {}; // 이미 추가된 노드를 확인하기 위한 객체
		                
		                //서버로부터 받은 응답
		                response.forEach(function(item) {
		                	
		                	//빈도수에 따른 투명도
		                	function getColorByFrequency(frequency) {
		                	    var alpha = frequency / 5.0;  // alpha는 0.0 ~ 1.0 사이의 값
		                	    return 'rgba(0, 123, 255, ' + alpha + ')';  // 예시로 파란색을 사용. 여기서의 alpha 값은 색상의 투명도를 결정
		                	}

		                	//빈도수에 따른 색상
		                	function getColorByFrequencyRange(frequency) {
							    if (frequency > 5.0) {
							        return 'red';
							    } else if (frequency > 3.0) {
							        return 'blue';
							    } else {
							        return 'lightgray';
							    }
							    window.print();
							}


		                	// 명사1 노드가 이미 추가되지 않았다면 배열에 추가
		                    if (!addedNodes[item.noun1]) {
		                        nodesArray.push({ id: item.noun1, label: item.noun1, color: getColorByFrequencyRange()});
		                        addedNodes[item.noun1] = true;
		                    }
		                    // 명사2 노드가 이미 추가되지 않았다면 배열에 추가
		                    if (!addedNodes[item.noun2]) {
		                        nodesArray.push({ id: item.noun2, label: item.noun2, color: getColorByFrequencyRange()});
		                        addedNodes[item.noun2] = true;
		                    }

		                    edgesArray.push({ from: item.noun1, to: item.noun2, value: item.nwgweight });
		                });
		                
		              //vis.js 데이터 준비
						var nodes = new vis.DataSet(nodesArray);
						var edges = new vis.DataSet(edgesArray);
						
		                //그래프 초기화 및 그리기
		                var container = document.getElementById('mynetwork' + flag);
		                var data = {
		                    nodes: nodes,
		                    edges: edges
		                };
		                var options = {
		                    // 여기에 그래프 옵션 설정 (예: 물리적 효과, 노드 디자인 등)
		                    height: '450px',
	                    	autoResize: true,
	                    	nodes: {
	                    		shape: 'dot',
	                    		borderWidth:4,
	                    		size:15,
	                    		color: {
	                    			border: 'white',
	                    			background: '#666666'
	                    		},
	                    		font:{color:'black'}
	                    	},
	                    	edges: {
	                    		color:'lightgray'
	                    	}
		                };
		                
		              	//토폴로지 생성
		                network = new vis.Network(container, data, options);

		                //토폴로지 이벤트 추가
		                network.on("click", function (params) {
		                  console.log(params.nodes[0]);
		                });
		                
		                var network = new vis.Network(container, data, options);

		            },
		            error: function() {
		                alert("데이터 로드 중 오류 발생!");
		            }
		        });
        };
        //팝업 Close 기능
        function close_pop(flag) {
             $('#myModal' + flag).hide();
        };
        //검색 창 클릭 시 기능
        $(function(){
        	$("#top_search").click(function(){
        		if($("#site_search").css("display") == "none")
        		{
        			$("#site_search").show();
        			$("#search_kyword").focus();
        		}
        		else if($("#site_search").css("display")!= "None")
       			{
        			$("#site_search").hide();
       			}
        	});
        	// 검색 창 외에 다른 구간 선택시 검색 창 없애기
            $("#content_wrap").click(function(){
            	if($("#site_search").css("display") != "none")
           		{
            		$("#site_search").hide();
           		}
            });        
        });
       	$(function(){
	        //검색어 버튼 누르면 검색 넘어가기 
	      	$(".search_btn").click(function()
   			{
	        	$("#search_frm").submit();
        	});
	        //상위메뉴에 마우스를 갖다대면 하위 메뉴 보이게 하기
	        $('.section1').mouseenter(function(){ $('.subsection1').slideDown(100); $('.section1').css('color','gold');})
	        $('.section2').mouseenter(function(){ $('.subsection2').slideDown(100); $('.section2').css('color','gold');})
	        $('.section3').mouseenter(function(){ $('.subsection3').slideDown(100); $('.section3').css('color','gold');})
	        $('.section4').mouseenter(function(){ $('.subsection4').slideDown(100); $('.section4').css('color','gold');})
	        $('.section5').mouseenter(function(){ $('.subsection5').slideDown(100); $('.section5').css('color','gold');})
	        $('.section6').mouseenter(function(){ $('.subsection6').slideDown(100); $('.section6').css('color','gold');})
			//하위메뉴에 마우스를 옮겨도 하위 메뉴 보이게 하기
			$('.subsection1').mouseenter(function(){ $('.subsection1').show(); })
			$('.subsection1 a').mouseenter(function(){ $(this).css('color','gold'); })
	        $('.subsection2').mouseenter(function(){ $('.subsection2').show(); })
	        $('.subsection2 a').mouseenter(function(){ $(this).css('color','gold'); })
	        $('.subsection3').mouseenter(function(){ $('.subsection3').show(); })
	        $('.subsection3 a').mouseenter(function(){ $(this).css('color','gold'); })
	        $('.subsection4').mouseenter(function(){ $('.subsection4').show(); })
	        $('.subsection4 a').mouseenter(function(){ $(this).css('color','gold'); })
	        $('.subsection5').mouseenter(function(){ $('.subsection5').show(); })
	        $('.subsection5 a').mouseenter(function(){ $(this).css('color','gold'); })
	        $('.subsection6').mouseenter(function(){ $('.subsection6').show(); })
	        $('.subsection6 a').mouseenter(function(){ $(this).css('color','gold'); })
	        //상위메뉴에서 마우스가 밖으로 나가면 하위 메뉴 숨기기
	        $('.section1').mouseleave(function(){ $('.subsection1').hide(); $('.section1').css('color','#000');})
	        $('.section2').mouseleave(function(){ $('.subsection2').hide(); $('.section2').css('color','#000');})
	        $('.section3').mouseleave(function(){ $('.subsection3').hide(); $('.section3').css('color','#000');})
	        $('.section4').mouseleave(function(){ $('.subsection4').hide(); $('.section4').css('color','#000');})
	        $('.section5').mouseleave(function(){ $('.subsection5').hide(); $('.section5').css('color','#000');})
	        $('.section6').mouseleave(function(){ $('.subsection6').hide(); $('.section6').css('color','#000');})
	        //하위메뉴에서 마우스가 밖으로 나가면 하위메뉴 숨기기
	        $('.subsection1').mouseleave(function(){ $('.subsection1').hide(); })
	        $('.subsection1 a').mouseleave(function(){ $(this).css('color','#000'); })
	        $('.subsection2').mouseleave(function(){ $('.subsection2').hide(); })
	        $('.subsection2 a').mouseleave(function(){ $(this).css('color','#000'); })
	        $('.subsection3').mouseleave(function(){ $('.subsection3').hide(); })
	        $('.subsection3 a').mouseleave(function(){ $(this).css('color','#000'); })
	        $('.subsection4').mouseleave(function(){ $('.subsection4').hide(); })
	        $('.subsection4 a').mouseleave(function(){ $(this).css('color','#000'); })
	        $('.subsection5').mouseleave(function(){ $('.subsection5').hide(); })
	        $('.subsection5 a').mouseleave(function(){ $(this).css('color','#000'); })
	        $('.subsection6').mouseleave(function(){ $('.subsection6').hide(); })
	        $('.subsection6 a').mouseleave(function(){ $(this).css('color','#000'); })
   		});
        //로딩중 화면에 표시
        window.onbeforeunload = function() { $('#loading').show(); };  //현재 페이지에서 다른 페이지로 넘어갈 때 표시해주는 기능
        window.onload = function()  //페이지가 로드 되면 로딩 화면을 없애주는 것
        { 
        	$('#loading').hide();
        	$('#loading').remove();
        };
    </script>
    <body>
	<!-- head 시작 -->	
	<div id="head">
		<div class="header_inner">
			<!-- 로고 시작 -->
			<div class="mainicon"><a href="/news/index.jsp"><b>Newsroom</b></a></div>
			<!-- 로고 끝 -->
			<!-- 상위 카테고리 시작 -->
			<div class="wrap_section">
				<div class="section1">정치</div>			
				<div class="section2">경제</div>
				<div class="section3">사회</div>
				<div class="section4">생활/문화</div>
				<div class="section5">세계</div>
				<div class="section6">IT/과학</div>
				<div id="top_search">
					<img src="/news/img/search.png" style="width:22px;height:22px;">
				</div>
				<!-- 하위카테고리 시작 -->
				<div class="subsection1">
					<span>
						<a href="/news/sub.jsp?cate1=정치&cate2=대통령실">대통령실</a>
					</span>| 
					<span>
						<a href="/news/sub.jsp?cate1=정치&cate2=국회,정당">국회/정당</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=정치&cate2=북한">북한</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=정치&cate2=행정">행정</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=정치&cate2=국방,외교">국방/외교</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=정치&cate2=정치일반">정치일반</a>
					</span>
				</div>
				<div class="subsection2">
					<span>
						<a href="/news/sub.jsp?cate1=경제&cate2=금융">금융</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=경제&cate2=증권">증권</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=경제&cate2=산업,재계">산업/재계</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=경제&cate2=중기,벤처">중기/벤처</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=경제&cate2=부동산">부동산</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=경제&cate2=글로벌 경제">글로벌 경제</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=경제&cate2=생활경제">생활경제</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=경제&cate2=경제 일반">경제 일반</a>
					</span>
				</div>
				<div class="subsection3">
					<span>
						<a href="/news/sub.jsp?cate1=사회&cate2=사건사고">사건사고</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=사회&cate2=교육">교육</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=사회&cate2=노동">노동</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=사회&cate2=언론">언론</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=사회&cate2=환경">환경</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=사회&cate2=인권,복지">인권/복지</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=사회&cate2=식품,의료">식품/의료</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=사회&cate2=지역">지역</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=사회&cate2=인물">인물</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=사회&cate2=사회 일반">사회 일반</a>
					</span>
				</div>
				<div class="subsection4">
					<span>
						<a href="/news/sub.jsp?cate1=생활,문화&cate2=건강정보">건강정보</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=생활,문화&cate2=자동차,시승기">자동차/시승기</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=생활,문화&cate2=도로,교통">도로/교통</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=생활,문화&cate2=여행,레저">여행/레저</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=생활,문화&cate2=음식,맛집">음식/맛집</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=생활,문화&cate2=패션,뷰티">패션/뷰티</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=생활,문화&cate2=공연,전시">공연/전시</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=생활,문화&cate2=책">책</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=생활,문화&cate2=종교">종교</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=생활,문화&cate2=날씨">날씨</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=생활,문화&cate2=생활문화 일반">생활문화 일반</a>
					</span>
				</div>
				<div class="subsection5">
					<span> 
						<a href="/news/sub.jsp?cate1=세계&cate2=아시아,호주">아시아/호주</a> 
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=세계&cate2=미국,중남미">미국/중남미</a> 
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=세계&cate2=유럽">유럽</a>
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=세계&cate2=중동,아프리카">중동/아프리카</a> 
					</span>|
					<span>
						<a href="/news/sub.jsp?cate1=세계&cate2=세계 일반">세계 일반</a>
					</span>
				</div>
				<div class="subsection6">
					<span> 
						<a href="/news/sub.jsp?cate1=IT,과학&cate2=모바일">모바일</a> 
					</span>|
					<span> 
						<a href="/news/sub.jsp?cate1=IT,과학&cate2=인터넷,SNS">인터넷/SNS</a> 
					</span>|
					<span> 
						<a href="/news/sub.jsp?cate1=IT,과학&cate2=통신,뉴미디어">통신/뉴미디어</a> 
					</span>|
					<span> 
						<a href="/news/sub.jsp?cate1=IT,과학&cate2=IT 일반">IT 일반</a> 
					</span>|
					<span> 
						<a href="/news/sub.jsp?cate1=IT,과학&cate2=보안,해킹">보안/해킹</a>  
					</span>|
					<span> 
						<a href="/news/sub.jsp?cate1=IT,과학&cate2=컴퓨터">컴퓨터</a>
					</span>|
					<span> 
						<a href="/news/sub.jsp?cate1=IT,과학&cate2=게임,리뷰">게임/리뷰</a> 
					</span>|
					<span> 
						<a href="/news/sub.jsp?cate1=IT,과학&cate2=과학 일반">과학 일반</a> 
					</span>
				</div>
				<!-- 하위카테고리 끝 -->
			</div>
			<!-- 상위 카테고리 끝 -->
			<!-- 검색 창 틀 시작 -->
			<div id="site_search">
				<div class="center">
					<p>통합검색</p>
					<form method="post" id="search_frm" action="/news/search.jsp">
					<div class="search_box">
						<div class="placeholder_box">
							<input type="text" title="통합검색" id="search_kyword" name="search_kyword" class="blank_search" placeholder="검색어를 입력해주세요.">
							<button type="button" class="search_btn"><img src="/news/img/search.png"></img></button>
						</div>
					</div>
					</form>
				</div>
			</div>
			<!-- 검색 창 틀 끝 -->
		</div>
		<div id="loading">
        	<img id="loading-image" src="img/Spinner-1s-200px (2).gif" alt="Loading..." />
	    </div>
	</div>
	<!-- head 끝 -->
