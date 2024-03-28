<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	System.out.println("=============== loginForm ===============");
	// 로그인 (인증) 분기
	// diary.login.my.session (db -> table -> col)
	// diary.login.my.session => 'OFF' => redirect(loginForm.jsp);
	String errMsg = request.getParameter("errMsg");
	System.out.println("[loginForm] errMsg : " + errMsg);
	//=============== include isLoggedIn.jsp start==========================
	// DB 연결
	Connection con = null;
	PreparedStatement findSessionPsmt = null;
	ResultSet sessionResultSet = null;
	Class.forName("org.mariadb.jdbc.Driver");
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	System.out.println("[loginForm] DB 연결 성공");
	// findSessionQuery 실행 및 결과 반환
	String findSessionQuery = "SELECT my_session mySession FROM login";
	findSessionPsmt = con.prepareStatement(findSessionQuery);
	System.out.println("[loginForm] findSessionQuery : " + findSessionPsmt);
	sessionResultSet = findSessionPsmt.executeQuery();
	// DB 연결 해제
	sessionResultSet.close();
	findSessionPsmt.close();
	con.close();
	System.out.println("[loginForm] DB 연결 해제");
	// sessionResultSet 값 유무 체크
	String mySession = "null";
	if (sessionResultSet.next()) {
		mySession = sessionResultSet.getString("mySession");
		System.out.println("[loginForm] mySession 반환값 : " + mySession);
	} else {
		System.out.println("[loginForm] mySession 반환 실패");
	}
	// session값에 따른 리다이렉트
	if (mySession.equals("ON")) {
		response.sendRedirect("/diary/diary.jsp");
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return 사용
	}
	//=============== isLoggedIn.jsp end==========================
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>loginForm</title>
	<link rel="stylesheet" href="./main.css"/>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
	
	<style>
		.login-common{
			font-weight: 700;
			text-align: center;
			margin-right: 10px;	
		}
		.login-string1{
			font-size: 29px;
			letter-spacing: 0.16em;
			margin-left: 4px;
		}
		.login-string2{
			font-size: 25px;
		}
		.login{
			font-size: 25px;
			border-width:0 0 3px;;
			
			background-color: rgba(0,0,0,0);
			color: white;
		}
		main > h2 {
			font-style: italic;
		}
		table{
			border-collapse: separate;
			border-spacing: 20px; 20px;
			text-align: center;
			margin-top: 100px;
		}
		input:focus {
	  		outline: none;
		}
		
	</style>
</head>
<body>
	<%
		if (errMsg != null) {
	%>
		<div><%=errMsg%></div>
	<% 
		}
	%>
	<header>
        <sub-a></sub-a>
        <sub-b></sub-b>
        <!-- 이미지를 src로 넣으면 화면 크기에 따라 다르게 보이는 배경이미지 불가능. css background 배경으로 넣어줘야함 -->
        <h1></h1>
        <h2>A Cloudy Day's Diary</h2> <!-- 날씨정보 연동-->
        <p>about things you don't usually write.</p>
    </header>
    <main class="content">
		<h2>Log in</h2>
		<form method="post" action="./loginAction.jsp">
		<table>
				<tr>
					<td>
					<div class="login-common login-string1">I.D</div>  
					</td>
					<td>
					<input class="login" name=memberId type="text">
					</td>
					<td>
					</td>
				</tr>
				<tr>
					<td>
					<div class="login-common login-string2">P.W</div> 
					</td>
					<td>
					<input class="login" name= memberPw type="password">
					</td>
					<td>
					<input class="btn" type="submit" value="submit">
					</td>
				</tr>
		</table>		
		</form>
	</main>
</body>
</html>