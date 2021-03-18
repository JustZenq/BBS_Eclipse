<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>  
<%@ page import="java.io.PrintWriter" %>   
<%-- 외부 내부 페이지 import 하기--%>
<% request.setCharacterEncoding("UTF-8"); %>

<%-- bbs/Bbs.java에서 ID,Password 받아오기 --%>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />


<!DOCTYPE html>
<html>
<head>
<meta http-equv="Content-Type" content = "text/html"; charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null)
		{
			userID = (String) session.getAttribute("userID");
		}
	
		if(userID == null)	// 글쓰기는 로그인이 되어 있지 않으면 로그인 하도록 알려줌
		{
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('로그인을 하세요.')");
				script.println("location.href = 'login.jsp'");	
				script.println("</script>");
			}
		}
		else
		{
			// 글쓰기 양식에서 무언가 입력 X
			if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null)
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()");		// 이전 페이지로 사용자 돌려보내기
				script.println("</script>");
			}
			else
			{
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());
				if (result == -1) 		 // 데이터베이스 오류
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다.')");
					script.println("history.back()");	
					script.println("</script>");
				}
				else	
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'");
					script.println("</script>");
				}
			}
		}
	
		

	%>
</body>
</html>



