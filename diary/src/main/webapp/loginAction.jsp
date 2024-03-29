<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	System.out.println("=============== loginAction ===============");
// session값에 따른 리다이렉트
if (session.getAttribute("loginMember") != null) {
	System.out.println("[logoutAction] DB 연결 해제");
	String errMsg = URLEncoder.encode("로그인을 먼저 진행해 주세요", "utf-8");
	response.sendRedirect("/diary/diaryCalendar.jsp");
	return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return 사용
}
	// 로그인 (인증) 분기
	// diary.login.my.session (db -> table -> col)
	// diary.login.my.session => 'OFF' => redirect(loginForm.jsp);
	//=============== include isLoggedIn.jsp start ==========================
	// DB 연결
/* 	Connection con = null;
	PreparedStatement findSessionPsmt = null;
	ResultSet sessionResultSet = null;
	Class.forName("org.mariadb.jdbc.Driver");
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	System.out.println("[loginAction] DB 연결 성공");
	// findSessionQuery 실행 및 결과 반환
	String findSessionQuery = "SELECT my_session mySession FROM login";
	findSessionPsmt = con.prepareStatement(findSessionQuery);
	System.out.println("[loginAction] findSessionQuery : " + findSessionPsmt);
	sessionResultSet = findSessionPsmt.executeQuery();

	
	// sessionResultSet 값 유무 체크
	String mySession = null;
	if (sessionResultSet.next()) {
		mySession = sessionResultSet.getString("mySession");
		System.out.println("[loginAction] mySession 반환값 : " + mySession);
	} else {
		System.out.println("[loginAction] mySession 반환 실패");
	}
	// session값에 따른 리다이렉트
	if (mySession.equals("ON")) {
		// DB 연결 해제
		sessionResultSet.close();
		findSessionPsmt.close();
		con.close();
		System.out.println("[loginAction] DB 연결 해제");
		
		response.sendRedirect("/diary/diaryCalendar.jsp");
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return 사용
	} */
	//=============== isLoggedIn.jsp end ==========================
	// 0.로그인 (인증) 분기
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection con = null;
	PreparedStatement findSessionPsmt = null;
	ResultSet sessionResultSet = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	System.out.println("[loginAction] DB 연결 성공");
	String loginMember = (String)(session.getAttribute("loginMember"));
	

	// 1. 요청값 분석
	request.setCharacterEncoding("utf-8");
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	// find memberId query 준비 및 실행
	PreparedStatement findMemberIdPsmt = null;
	ResultSet memberIdResultSet = null;
	
	String findMemberIdQuery = "SELECT member_id memberId FROM MEMBER WHERE member_id = ? and member_pw = ?";
	findMemberIdPsmt = con.prepareStatement(findMemberIdQuery);
	findMemberIdPsmt.setString(1, memberId);
	findMemberIdPsmt.setString(2, memberPw);
	System.out.println("[loginAction] findMemberIdQuery : " + findMemberIdPsmt);
	
	memberIdResultSet = findMemberIdPsmt.executeQuery();
	

	
	// DB로 session 모의 구현 로직 포함된 것 주석처리

	if (memberIdResultSet.next()) {
		// diary.login.my_session -> "ON" 변경
		/* PreparedStatement updateSessionPsmt = null;
		String updateSessionQuery = "UPDATE login SET my_session = 'ON', on_date = NOW()";
		updateSessionPsmt = con.prepareStatement(updateSessionQuery);
		int updateSessionResult =  updateSessionPsmt.executeUpdate();
		System.out.println("[loginAction] updateSessionResult : " + updateSessionResult); */

		// 로그인 성공 리다이렉트
		session.setAttribute("loginMember", memberIdResultSet.getString("memberId"));
		System.out.println("[loginAction] session-param loginMember : " + session.getAttribute("loginMember"));
		System.out.println("[loginAction] 로그인 성공");
		response.sendRedirect("./diaryCalendar.jsp");

		// DB 연결 해제
		memberIdResultSet.close();
		con.close();
		System.out.println("[loginAction] DB 연결 해제");		
	} else {
		// DB 연결 해제
		memberIdResultSet.close();
		findSessionPsmt.close();
		con.close();
		System.out.println("[loginAction] DB 연결 해제");
		// 로그인 실패 리다이렉트
		System.out.println("[loginAction] session-param loginMember : " + session.getAttribute("loginMember"));
		System.out.println("[loginAction] 로그인 실패");
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
	}
	//

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>

	<h1>로그인</h1>
	
	<form method="post" action="./logoutAction.jsp">
		<input type="submit" value = "로그아웃">
	</form>
</body>
</html>