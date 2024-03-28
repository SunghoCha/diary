<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	System.out.println("=============== logoutAction ===============");

	Connection con = null;
	PreparedStatement findSessionPsmt = null;
	ResultSet sessionResultSet = null;
	Class.forName("org.mariadb.jdbc.Driver");
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	System.out.println("[logoutAction] DB 연결 성공");
	// findSessionQuery 실행 및 결과 반환
	String findSessionQuery = "SELECT my_session mySession FROM login";
	findSessionPsmt = con.prepareStatement(findSessionQuery);
	System.out.println("[logoutAction] findSessionQuery : " + findSessionPsmt);
	sessionResultSet = findSessionPsmt.executeQuery();
	
	
	// sessionResultSet 값 유무 체크
	String mySession = null;
	if (sessionResultSet.next()) {
		mySession = sessionResultSet.getString("mySession");
		System.out.println("[logoutAction] mySession 반환값 : " + mySession);
	} else {
		System.out.println("[logoutAction] mySession 반환 실패");
	}
	// session값에 따른 리다이렉트
	if (mySession.equals("OFF")) {
		// DB 연결 해제
		sessionResultSet.close();
		findSessionPsmt.close();
		con.close();
		System.out.println("[logoutAction] DB 연결 해제");
		String errMsg = URLEncoder.encode("로그인을 먼저 진행해 주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return 사용
	}

	Connection con1 = null;
	PreparedStatement updateSessionPsmt = null;
	Class.forName("org.mariadb.jdbc.Driver");
	con1 = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	System.out.println("[logoutAction] DB 연결 성공");
	// updateSessionQuery 실행 및 결과 반환
	String updateSessionQuery = "UPDATE login SET my_session = 'OFF', off_date = NOW() WHERE my_session = 'ON'";
	updateSessionPsmt = con.prepareStatement(updateSessionQuery);
	System.out.println("[logoutAction] updateSessionQuery : " + updateSessionPsmt);
	int updateSessionResult = updateSessionPsmt.executeUpdate();
	System.out.println("[logoutAction] updateSessionResult : " + updateSessionResult);
	if (updateSessionResult == 1) {
		// DB 연결 해제
		updateSessionPsmt.close();
		con.close();
		System.out.println("[logoutAction] DB 연결 해제");
		// 로그아웃 성공 리다이렉트
		System.out.println("[logoutAction] update my_session 성공");
		response.sendRedirect("./loginForm.jsp");
	} else {
		// DB 연결 해제
		updateSessionPsmt.close();
		con1.close();
		System.out.println("[logoutAction] DB 연결 해제");
		// 로그인 실패 리다이렉트
		System.out.println("[logoutAction] update my_session 실패");
		String errMsg = URLEncoder.encode("DB 업데이트 오류로 인한 로그아웃 실패", "utf-8");
		response.sendRedirect("./loginForm.jsp?errMsg=" + errMsg);
	}
%>