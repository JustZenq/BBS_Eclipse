<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="comment.CommentDAO" %>  
<%@ page import="bbs.BbsDAO" %>  
<%@ page import="java.util.ArrayList" %>  
<%@ page import="java.io.PrintWriter" %>   
<%-- 외부 내부 페이지 import 하기--%>
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:useBean id="comment" class="comment.CommentDTO" scope="page" />
<jsp:setProperty name="bbs" property="bbsID" />
<jsp:setProperty name="comment" property="commentContent" />


<!DOCTYPE html>
<html>
<head>
<meta http-equv="Content-Type" content = "text/html"; charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
		
		String temp = request.getParameter("bbsID");
		int bbsID = Integer.parseInt(temp);
		
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
			// 댓글을 입력 X
			if (comment.getCommentContent() == null)
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('댓글 입력이 되지 않았습니다.')");
				script.println("history.back()");		// 이전 페이지로 사용자 돌려보내기
				script.println("</script>");
			}
			else
			{
				CommentDAO commentDAO = new CommentDAO();
				int result = commentDAO.commentWrite(bbsID, userID, comment.getCommentContent());
				if (result == -1) 		 // 데이터베이스 오류
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패하였습니다." + comment.getCommentContent()  + "')");
					//script.println("alert('글쓰기에 실패했습니다.')");
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



