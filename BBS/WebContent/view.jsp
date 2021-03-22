<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 외부 스크립트 참조--%>
<%@ page import="java.io.PrintWriter" %>    
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>  
<!DOCTYPE html>
<html>
<head>
<meta http-equv="Content-Type" content = "text/html"; charset="UTF-8">
<meta name = "viewport" content = "width-device-width", initial-scale = "1">
<%-- w-d-w 브라우저 너비를 장치 너비에 맞추어 표시 / i-s 1.0 = 100% --%>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<%-- 내부 css 파일 참조--%>

<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;	// 로그인을 안 한 사람이라면 null 값
		if (session.getAttribute("userID") != null)	// 로그인을 한 사람이라면 값 유지
		{
			userID = (String)session.getAttribute("userID");
		}
		int bbsID = 0;
		
		if(request.getParameter("bbsID") != null)
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		
		if(bbsID == 0)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");	
			script.println("</script>");
		}
		
		Bbs bbs = new BbsDAO().getBbs(bbsID);
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
							<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
						</tr>
					</thead>
					
					<tbody>
						<tr>
							<td style="width: 20%;">글 제목</td>
							<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;")
									.replaceAll(">", "&gt;").replaceAll("\n","<br>") %></td>
							<%-- script 해킹 대비 --%>
						</tr>				
						<tr>
							<td>작성자</td>
							<td colspan="2"><%= bbs.getUserID() %></td>
						</tr>
						<tr>
							<td>작성일자</td>
							<td colspan="2"><%= bbs.getBbsDate().substring(0,11) + 
								bbs.getBbsDate().substring(11,13) + "시 " +
								bbs.getBbsDate().substring(14,16) + "분 " %></td>
						</tr>
						<tr>
							<td>내용</td>
							<td colspan="2" style="min-height: 200px; text-align: left;">
								<%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;")
								.replaceAll(">", "&gt;").replaceAll("\n","<br>")%></td>
								<%-- 특수문자 출력 --%>
						</tr>
					</tbody>
				</table>
				<a href="bbs.jsp" class="btn btn-primary">목록</a>
				<%
					if(userID != null && userID.equals(bbs.getUserID())) {
				%>
						<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
						<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a>
				<%
					}
				%>
				
		</div>
	</div>
	
	
	<%-- 외부 js와 내부 js 파일 참조--%>
	<script src = "https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src = "js/bootstrap.js"></script>
</body>
</html>