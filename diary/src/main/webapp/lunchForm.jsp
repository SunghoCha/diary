<%@page import="java.sql.*"%>
<%@page import="java.net.*"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// include isLoggedIn.jsp
		// 로그인 확인
	System.out.println("[lunchForm] session-param loginMember : " + session.getAttribute("loginMember"));
	if (session.getAttribute("loginMember") == null) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인을 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		return; 
	}
%>

<% 
	String lunchDate = request.getParameter("lunchDate");
	System.out.println("[lunchForm] request-param lunchDate : " + lunchDate);
	// db 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection con = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

	
	//
	String query = "SELECT * FROM lunch WHERE lunch_date = ?";
	psmt = con.prepareStatement(query);
	psmt.setString(1, lunchDate);
	System.out.println("[lunchForm] binding query : " + psmt);
	rs = psmt.executeQuery();
	
	if (rs.next()) {
		System.out.println("[lunchForm] 이미 존재하는 정보이므로 redirect");
		String errMsg = URLEncoder.encode("이미 존재하는 정보입니다.", "UTF-8");
		response.sendRedirect("/diary/lunchForm.jsp?errMsg=" + errMsg);
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<link rel="stylesheet" href="./main.css"/>
	<link href="https://fonts.googleapis.com/css2?family=Lato&display=swap" rel="stylesheet">
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
</head>
<header>
        <sub-a></sub-a>
        <sub-b></sub-b>
        <div>
        	<a href="/diary/diaryCalendar.jsp">go to calendar</a>
        	<a href="/diary/diaryList.jsp">go to list</a>
        	<a href="/diary/startLunch.jsp">go to startLunch</a>
        	<a href="/diary/lunchForm.jsp">go to addLunch</a>
        </div>
        <!-- 이미지를 src로 넣으면 화면 크기에 따라 다르게 보이는 배경이미지 불가능. css background 배경으로 넣어줘야함 -->
        <h1></h1>
        <h2>A Cloudy Day's Diary</h2> <!-- 날씨정보 연동-->
        <p>about things you don't usually write.</p>
</header>
<body>
<main class="content">
	<h1>오늘 먹을 점심 메뉴 선택</h1>
	<form method="post" action="/diary/lunchAction.jsp">
		<input type="hidden" name="lunchDate" value='<%=lunchDate%>'> <br>
	
		<input type="radio" name="menu" value="한식">한식
		<input type="radio" name="menu" value="일식">일식
		<input type="radio" name="menu" value="중식">중식
		<input type="radio" name="menu" value="양식">양식
		<input type="radio" name="menu" value="기타">기타
		<input type="submit" value="추가">
	</form>
</body>
</html>