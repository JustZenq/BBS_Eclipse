<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>  
<%@ page import="java.io.PrintWriter" %>   
<%-- 외부 내부 페이지 import 하기--%>
<% request.setCharacterEncoding("UTF-8"); %>
<%-- user/User.java에서 ID,Password 받아오기 --%>
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="userEmail" />

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
	
		if(userID != null)	// 이미 로그인이 되어있는 유저는 로그인이 또 되어지지 않게 막기
		{
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 로그인이 되어있습니다.')");
				script.println("location.href = 'main.jsp'");	
				script.println("</script>");
			}
		}
	
		// 회원가입 양식에서 무언가 입력 X
		if (user.getUserID() == null || user.getUserPassword() == null || 
			user.getUserName() == null || user.getUserGender() == null || 
			user.getUserEmail() == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.')");
			script.println("history.back()");		// 이전 페이지로 사용자 돌려보내기
			script.println("</script>");
		}
		else
		{
			UserDAO userDAO = new UserDAO();
			int result = userDAO.join(user);
			if (result == -1) 		 // 데이터베이스 오류
			{
				// 데이터베이스 오류가 나는 경우는 이미 해당 아이디가 존재하는 경우!
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')");
				script.println("history.back()");	
				script.println("</script>");
			}
			else	// 회원가입이 이루어진 경우
			{
				session.setAttribute("userID", user.getUserID());
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'main.jsp'");
				script.println("</script>");
			}
		}

	%>
</body>
</html>



