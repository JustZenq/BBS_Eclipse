package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class BbsDAO {

	private Connection conn;
	private ResultSet rs;
	
	public BbsDAO()
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
	
	// BbsDAO 클래스는 여러 개의 함수가 이용되기 때문에 pstmt는 함수 안에 집어넣기
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
	
	// 다읍 번에 쓰여야 될 게시글의 번호
	public int getNext()
	{
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next())
				return rs.getInt(1) + 1;
				
			return 1;	// 첫 번째 게시글인 경우
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return -1;	// 데이터베이스 오류
	}
	
	public int write(String bbsTitle, String userID, String bbsContent)
	{
		String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)";
		try
		{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);
			
			return pstmt.executeUpdate();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return -1;	// 데이터베이스 오류
	}
	
	
}
