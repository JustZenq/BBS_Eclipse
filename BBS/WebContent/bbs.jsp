<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 외부 스크립트 참조--%>
<%@ page import="java.io.PrintWriter" %>  
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>  
    
<!DOCTYPE html>
<html>
<head>
<meta http-equv="Content-Type" content = "text/html"; charset="UTF-8">
<meta name = "viewport" content = "width-device-width", initial-scale = "1">
<%-- w-d-w 브라우저 너비를 장치 너비에 맞추어 표시 / i-s 1.0 = 100% --%>
<link rel="stylesheet" href="css/bootstrap.css">
<%-- 내부 css 파일 참조--%>

<title>JSP 게시판 웹 사이트</title>
<style type="text/css">
	a, a:hover {
		color: #000000;
		text-decoration: none;
	}
</style>
</head>
<body>
	<%
		String userID = null;	// 로그인을 안 한 사람이라면 null 값
		if (session.getAttribute("userID") != null)	// 로그인을 한 사람이라면 값 유지
		{
			userID = (String) session.getAttribute("userID");
		}
		
		int pageNumber = 1; // 기본이 1페이지
		if(request.getParameter("pageNumber") != null)
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
	%>

	<%-- 네비게이션 링크 --%>
	<nav class="navbar navbar-default">
	<%-- 내부 css 파일 참조--%> 
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<%-- 메뉴바 줄 3개 --%>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		
		<%-- 메뉴 링크 --%>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>	<%-- active = 지금 접속한 페이지 --%>
			</ul>
			
			<%
				if(userID == null)	// 로그인 X
				{
			%>
			<%-- 드랍다운 메뉴 --%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toogle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
							
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>	
			<%
				} else				// 로그인 O
				{
			%>
			<%-- 드랍다운 메뉴 --%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toogle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
							
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<% 		
				}
			%>
		</div>
	</nav>
	
	<div class = "container">
		<div class = "row">
			<table class="table table-striped" style="text-align: center; border: solid 1px #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				
				<tbody>
					<%
						BbsDAO bbsDAO = new BbsDAO();
						ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
						for(int i = 0; i < list.size(); i++)
						{	
					%>
					<tr>
						<td><%= list.get(i).getBbsID() %></td>
						<td><a href="view.jsp?bbsID= <%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle() %></a></td>
						<td><%= list.get(i).getUserID() %></td>
						<td><%= list.get(i).getBbsDate().substring(0,11) + 
								list.get(i).getBbsDate().substring(11,13) + "시 " +
								list.get(i).getBbsDate().substring(14,16) + "분 " %></td>
						<%-- 오류가 아닌데도 IDE에서 오류라고 우긴다 ㅡㅡ --%>
					</tr>
					<%
						}
					%>
					
				</tbody>
			</table>
			<%
				if(pageNumber != 1)
				{
			%> 
					<a href="bbs.jsp?pageNumber=<%= pageNumber - 1 %>" class="btn btn-success btn-arrow-left">이전</a>
			<% 
				}
				
				if(bbsDAO.nextPage(pageNumber + 1))
				{
			%> 
					<a href="bbs.jsp?pageNumber=<%= pageNumber + 1 %>" class="btn btn-success btn-arrow-left">다음</a>
			<% 
				}
			%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	
	
	<%-- 외부 js와 내부 js 파일 참조--%>
	<script src = "https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src = "js/bootstrap.js"></script>
</body>
</html>