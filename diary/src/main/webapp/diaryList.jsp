<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
System.out.println("=============== diaryList ===============");
// 로그인 (인증) 분기
// diary.login.my.session (db -> table -> col)
// diary.login.my.session => 'OFF' => redirect(loginForm.jsp);

// DB 연결
Connection con = null;
PreparedStatement findSessionPsmt = null;
ResultSet sessionResultSet = null;
Class.forName("org.mariadb.jdbc.Driver");
con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
System.out.println("[diaryOne] DB 연결 성공");
// findSessionQuery 실행 및 결과 반환
String findSessionQuery = "SELECT my_session mySession FROM login";
findSessionPsmt = con.prepareStatement(findSessionQuery);
System.out.println("[diaryOne] findSessionQuery : " + findSessionPsmt);
sessionResultSet = findSessionPsmt.executeQuery();

System.out.println("[diaryOne] DB 연결 해제");
// sessionResultSet 값 유무 체크
String mySession = "null";
if (sessionResultSet.next()) {
	mySession = sessionResultSet.getString("mySession");
	System.out.println("[diaryOne] mySession 반환값 : " + mySession);
} else {
	System.out.println("[diaryOne] Session 반환 실패");
}
// session값에 따른 리다이렉트
if (mySession.equals("OFF")) {
	String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인을 먼저 해주세요", "utf-8");
	response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
	return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return 사용
}
////
%>

<%
	String currentPageStr = request.getParameter("currentPage");
	int currentPage = 1;
	if(currentPageStr != null && !currentPageStr.equals("")) {
		currentPage = Integer.parseInt(currentPageStr);
	}
	
	String rowPerPageStr = request.getParameter("rowPerPage");
	int rowPerPage = 10;
	if(rowPerPageStr != null && !rowPerPageStr.equals("")) {
		rowPerPage = Integer.parseInt(rowPerPageStr);
	}
		
	int startRow = (currentPage - 1 ) * rowPerPage;
	
	String searchWord = "";
	if(request.getParameter("searchWord") != null) {
		searchWord = request.getParameter("searchWord");
	}

	/* 
	SELECT diary_date diaryDate, title
	FROM diary
	WHERE title LIKE '%%'
	ORDER BY diary_date DESC
	LIMIT ?, ?*/
			
	String sql2 = "	SELECT diary_date diaryDate, title FROM diary WHERE title LIKE ? ORDER BY diary_date DESC LIMIT ?, ?";
	PreparedStatement psmt2 = null;
	ResultSet rs2 = null;
	psmt2 = con.prepareStatement(sql2);
	psmt2.setString(1,"%" + searchWord + "%");
	psmt2.setInt(2, startRow);
	psmt2.setInt(3, rowPerPage);
	rs2 = psmt2.executeQuery();
	
	String sql3 = "SELECT COUNT(*) cnt from diary where title like ?";
	PreparedStatement psmt3 = null;
	ResultSet rs3 = null;
	psmt3 = con.prepareStatement(sql3);
	psmt3.setString(1,"%" + searchWord + "%");
	rs3 = psmt3.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
		<link rel="stylesheet" href="./main.css"/>
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
	<style>
		table {
			text-align: center;
			margin:0 auto;
		}
		table th {
			padding : 25px 30px; 
		}
		table td {
			padding : 10px 30px; 
		}
		a {
			text-align: center;
		}
		.button-margin {
			text-align: center;
			margin:0 auto;
			padding: 0;
			vertical-align : middle;+
			line-height: 1;
		}
		.align-p {
			position:relative;
		}
		#align-c {
			color : #5D5D5D;
		 	position: absolute;
		 	margin-top: 20px;
		 	line-height: 32px;
		 	letter-spacing: 0.2em;
		 	font-size: 20px;
		}
		a {
			display: block;
			color: white;
		}
		.input-line{
			font-size: 25px;
			border-width:0 0 3px;;
			background-color: rgba(0,0,0,0);
			color: #000;
			margin-bottom: 20px;
		}
		form {
			text-align: center;
		}
	</style>
</head>
<body>
	<header>
        <sub-a></sub-a>
        <sub-b></sub-b>
        <div>
        	<a href="/diary/diaryCalendar.jsp">go to calendar</a>
        	<a href="/diary/diaryList.jsp">go to list</a>
        </div>
        <!-- 이미지를 src로 넣으면 화면 크기에 따라 다르게 보이는 배경이미지 불가능. css background 배경으로 넣어줘야함 -->
        <h1></h1>
        <h2>A Cloudy Day's Diary</h2> <!-- 날씨정보 연동-->
        <p>about things you don't usually write.</p>
    </header>
    <main class="content">
	<h2>일기 목록</h2>
	<form class="" action="/diary/diaryList.jsp?searchWord=<%=searchWord%>">
			<input class="input-line" type="text">
			<i class="fa-solid fa-magnifying-glass"></i>
		
	</form>	
	<div class="align-p">
	<table>
		<tr>
			<th>날짜</th>
			<th>제목</th>
		</tr>
		<%
			while(rs2.next()) {
		%>
			<tr>
				<td><%=rs2.getString("diaryDate")%></td>
				<td><a href="/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>"><%=rs2.getString("title")%></a></td>
			<tr>
		<%
			}
		%>				
	</table>
	</div>
	<div class="button-margin">
		<a href="/diary/addDiaryForm.jsp" class="custom-btn btn-8" id="align-c" type="submit">write</a>
	</div>
	<div>
	
	</div>
	</main>
</body>
</html>