<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	//session.removeAttribute("loginMember");
// session값에 따른 리다이렉트
if (session.getAttribute("loginMember") == null) {
	System.out.println("[logoutAction] DB 연결 해제");
	String errMsg = URLEncoder.encode("로그인을 먼저 진행해 주세요", "utf-8");
	response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
	return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return 사용
}
%>

<%
	System.out.println("=============== logoutAction ===============");

	session.invalidate(); // 세션 공간 초기화(포맷)

	response.sendRedirect("/diary/loginForm.jsp");
%>