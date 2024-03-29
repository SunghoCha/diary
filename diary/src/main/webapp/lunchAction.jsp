<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.net.*"%>
<%
	// include isLoggedIn.jsp
		// 로그인 확인
	System.out.println("[lunchAction] session-param loginMember : " + session.getAttribute("loginMember"));
	if (session.getAttribute("loginMember") == null) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인을 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		return;
	}
%>
<% 
	String lunchDate = request.getParameter("lunchDate");
	String menu = request.getParameter("menu");

	System.out.println("[lunchAction] request param lucnDate : " + lunchDate);
	System.out.println("[lunchAction] request param menu : " + menu);
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection con = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	System.out.println("[lunchAction] DB 연결 성공");
	

	
	String query = "INSERT INTO lunch(lunch_date, menu, create_date, update_date) VALUES(?, ?, NOW(), NOW())";
	psmt = con.prepareStatement(query);
	psmt.setString(1, lunchDate);
	psmt.setString(2, menu);
	System.out.println("[lunchForm] binding query : " + psmt);
	int row = psmt.executeUpdate();
	
	if (row == 1) {
		System.out.println("[lunchAction] 오늘의 점심 메뉴 작성 성공");
		response.sendRedirect("/diary/diaryCalendar.jsp");
	} else {
		String errMsg = URLEncoder.encode("점심 메뉴 선택에 실패하였습니다.", "UTF-8");
		response.sendRedirect("/diary/lunchForm.jsp?errMsg=" + errMsg);
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	
</body>
</html>