<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
<%
	System.out.println("=============== addCommentAction ===============");
	// 로그인 확인
	System.out.println("[addCommentAction] session-param loginMember : " + session.getAttribute("loginMember"));
	if (session.getAttribute("loginMember") == null) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인을 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return 사용
	}
	// request param 가져오기
	String diaryDate = request.getParameter("diaryDate");
	String memo = request.getParameter("memo");
	
	System.out.println("[addCommentAction] request-param diaryDate : " + diaryDate);
	System.out.println("[addCommentAction] request-param memo : " + memo);
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection con = null;
	PreparedStatement psmt = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	System.out.println("[addDiaryAction] DB 연결 성공");
	
	String sql1 = "INSERT INTO COMMENT (diary_date, memo, update_date, create_date) VALUES (?, ?, NOW(), NOW());";
	psmt = con.prepareStatement(sql1);
	psmt.setString(1, diaryDate);
	psmt.setString(2, memo);
	System.out.println("[addCommentAction] binding-query psmt : " + psmt);
	int row = psmt.executeUpdate();
	// 쿼리 결과에 따른 처리
	if (row == 1) {
		System.out.println("[addCommentAction] 커밋 성공");
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" + diaryDate);
	} else {
		System.out.println("[addCommentAction] 커밋 실패");
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" + diaryDate);
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