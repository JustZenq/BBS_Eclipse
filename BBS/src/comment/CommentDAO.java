package comment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet; 
import java.util.ArrayList;

import bbs.Bbs;

public class CommentDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	// CommentDAO 생성자
	public CommentDAO()
	{
		try 
		{
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.jdbc.Driver");	// Driver 라이브러리
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
	
	// 지금 현재 시간 얻는 함수
	public String getDate()
	{
		String SQL = "SELECT NOW()";
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next())
				return rs.getString(1);
				
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return "";	// 데이터베이스 오류
	}
	
	// 다음 commentID를 얻는 함수
		public int getCommentNext()
		{
			String SQL = "SELECT commentID FROM COMMENT ORDER BY commentID DESC";
			try
			{
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				rs = pstmt.executeQuery();
				if(rs.next())
					return rs.getInt(1) + 1;
					
				return 1;	// 첫 번째 댓글인 경우
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
			return -1;	// 데이터베이스 오류
		}
		
	
	// 댓글을 적게 해주는 함수
	public int commentWrite(int bbsID, String userID, String commentContent)
	{
		String SQL = "INSERT INTO COMMENT VALUES (?, ?, ?, ?, ?)";
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getCommentNext());		// commentID insert
			pstmt.setInt(2, bbsID);					// bbsID insert
			pstmt.setString(3, userID);				// userID insert
			pstmt.setString(4, commentContent);		// commentContent insert
			pstmt.setString(5, getDate());			// commentDate insert
			
			return pstmt.executeUpdate();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return -1;	// 데이터베이스 오류
	}
	
	public ArrayList<CommentDTO> getCommentList(int bbsID)
	{
		// 게시판 글번호(bbsID)와 맞는 댓글 모두 출력하는 SQL
		String SQL = "SELECT * FROM COMMENT WHERE bbsID = ?";
		ArrayList<CommentDTO> list = new ArrayList<CommentDTO>();
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			while(rs.next()) 
			{
				CommentDTO commentDTO = new CommentDTO();
				commentDTO.setCommentID(rs.getInt(1));
				commentDTO.setBbsID(rs.getInt(2));
				commentDTO.setUserID(rs.getString(3));
				commentDTO.setCommentContent(rs.getString(4));
				commentDTO.setCommentDate(rs.getString(5));
				list.add(commentDTO);
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return list;	
	}
	
}
