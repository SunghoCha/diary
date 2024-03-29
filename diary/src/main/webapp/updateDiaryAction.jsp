<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
System.out.println("=============== updateDiaryAction ===============");
// 로그인 (인증) 분기
// diary.login.my.session (db -> table -> col)
// diary.login.my.session => 'OFF' => redirect(loginForm.jsp);
// session값에 따른 리다이렉트
System.out.println("[updateDiaryAction] session-param loginMember : " + session.getAttribute("loginMember"));
	if (session.getAttribute("loginMember") == null) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인을 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		return; 
	}

// DB 연결
Connection con = null;
PreparedStatement findSessionPsmt = null;
ResultSet sessionResultSet = null;
Class.forName("org.mariadb.jdbc.Driver");
con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
System.out.println("[DiaryAction] DB 연결 성공");
// findSessionQuery 실행 및 결과 반환
/* String findSessionQuery = "SELECT my_session mySession FROM login";
findSessionPsmt = con.prepareStatement(findSessionQuery);
System.out.println("[DiaryAction] findSessionQuery : " + findSessionPsmt);
sessionResultSet = findSessionPsmt.executeQuery();

System.out.println("[DiaryAction] DB 연결 해제");
// sessionResultSet 값 유무 체크
String mySession = "null";
if (sessionResultSet.next()) {
	mySession = sessionResultSet.getString("mySession");
	System.out.println("[DiaryAction] mySession 반환값 : " + mySession);
} else {
	System.out.println("[DiaryAction] Session 반환 실패");
} */

////
%>

<%
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	String diaryDate = request.getParameter("diaryDate");
	
	String sql2 = "UPDATE diary SET title = ?, content = ?, update_date = NOW() WHERE diary_date = ?;";
	PreparedStatement psmt2 = null;
	psmt2 = con.prepareStatement(sql2);
	psmt2.setString(1, title);
	psmt2.setString(2, content);
	psmt2.setString(3, diaryDate);
	System.out.println("[updateDairyAction] binging query : " + psmt2);
	int row = psmt2.executeUpdate();
	
	if(row == 1) {
		System.out.println("[updateDiaryAction] 업데이트 성공");
		response.sendRedirect("/diary/diaryList.jsp");
	} else {
		System.out.println("[updateDiaryAction] 업데이트 실패");
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