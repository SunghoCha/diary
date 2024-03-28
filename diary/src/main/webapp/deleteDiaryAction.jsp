<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
System.out.println("=============== deleteDiaryAction ===============");
// 로그인 (인증) 분기
// diary.login.my.session (db -> table -> col)
// diary.login.my.session => 'OFF' => redirect(loginForm.jsp);

// DB 연결
Connection con = null;
PreparedStatement findSessionPsmt = null;
ResultSet sessionResultSet = null;
Class.forName("org.mariadb.jdbc.Driver");
con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
System.out.println("[deleteDiaryAction] DB 연결 성공");
// findSessionQuery 실행 및 결과 반환
String findSessionQuery = "SELECT my_session mySession FROM login";
findSessionPsmt = con.prepareStatement(findSessionQuery);
System.out.println("[deleteDiaryAction] findSessionQuery : " + findSessionPsmt);
sessionResultSet = findSessionPsmt.executeQuery();


// sessionResultSet 값 유무 체크
String mySession = "null";
if (sessionResultSet.next()) {
	mySession = sessionResultSet.getString("mySession");
	System.out.println("[deleteDiaryAction] mySession 반환값 : " + mySession);
} else {
	System.out.println("[deleteDiaryAction] Session 반환 실패");
}
// session값에 따른 리다이렉트
if (mySession.equals("OFF")) {
	String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인을 먼저 해주세요", "utf-8");
	response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
	return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return 사용
}
////
String diaryDate = request.getParameter("diaryDate");
System.out.println("[deleteDiaryAction] request-param diaryDate : " + diaryDate);

//
String findDiaryQuery = "DELETE FROM diary WHERE diary_date = ?;";
PreparedStatement removeDiaryPsmt = null;
ResultSet diaryResultSet = null;
removeDiaryPsmt = con.prepareStatement(findDiaryQuery);
removeDiaryPsmt.setString(1, diaryDate);
System.out.println("[deleteDiaryAction] delete query : " + removeDiaryPsmt);
int row = removeDiaryPsmt.executeUpdate();

if(row == 1) {
	System.out.println("[deleteDiaryAction] diary 삭제 성공");
	response.sendRedirect("/diary/diaryCalendar.jsp");
} else {
	System.out.println("[deleteDiaryAction] diary 삭제 실패");
	response.sendRedirect("/diary/diaryOne.jsp?diaryDate" + diaryDate);
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