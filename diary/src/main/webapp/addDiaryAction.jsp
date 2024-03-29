<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 로그인 확인
	System.out.println("[addDiaryAction] session-param loginMember : " + session.getAttribute("loginMember"));
	if (session.getAttribute("loginMember") == null) {
	String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인을 먼저 해주세요", "utf-8");
	response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
	return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return 사용
	}
		
	// 요청 파라미터 가져오기
	String diaryDate = request.getParameter("diaryDate");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	
	System.out.println("[addDiaryAction] request-param diaryDate : " + diaryDate);
	System.out.println("[addDiaryAction] request-param title : " + title);
	System.out.println("[addDiaryAction] request-param weather : " + weather);
	System.out.println("[addDiaryAction] request-param content : " + content);
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection con = null;
	PreparedStatement psmt = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	System.out.println("[addDiaryAction] DB 연결 성공");

		
	
	// 쿼리 실행
	String query = "INSERT INTO diary(diary_date, title, weather, content, update_date, create_date) VALUES(?, ?, ?, ?, NOW(), NOW());";
	psmt = con.prepareStatement(query);
	psmt.setString(1, diaryDate);
	psmt.setString(2, title);
	psmt.setString(3, weather);
	psmt.setString(4, content);
	int row = psmt.executeUpdate();
	// 쿼리 결과에 따른 처리
	if (row == 1) {
		System.out.println("[addDiaryAction] 커밋 성공");
		response.sendRedirect("/diary/diaryCalendar.jsp");
	} else {
		System.out.println("[addDiaryAction] 커밋 실패");
		response.sendRedirect("/diary/addDiaryForm.jsp");
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