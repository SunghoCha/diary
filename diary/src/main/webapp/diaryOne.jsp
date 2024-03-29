<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>

<%
	System.out.println("=============== diaryOne ===============");

	// 로그인 (인증) 분기
	// diary.login.my.session (db -> table -> col)
	// diary.login.my.session => 'OFF' => redirect(loginForm.jsp);
		// session값에 따른 리다이렉트
	System.out.println("[diaryOne] session-param loginMember : " + session.getAttribute("loginMember"));
	if (session.getAttribute("loginMember") == null) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인을 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return 사용
	}
	// DB 연결
	Connection con = null;
	PreparedStatement findSessionPsmt = null;
	ResultSet sessionResultSet = null;
	Class.forName("org.mariadb.jdbc.Driver");
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	System.out.println("[diaryOne] DB 연결 성공");
	
	
	/* // findSessionQuery 실행 및 결과 반환
	String findSessionQuery = "SELECT my_session mySession FROM login";
	findSessionPsmt = con.prepareStatement(findSessionQuery);
	System.out.println("[diaryOne] findSessionQuery : " + findSessionPsmt);
	sessionResultSet = findSessionPsmt.executeQuery();


	// sessionResultSet 값 유무 체크
	String mySession = "null";
	if (sessionResultSet.next()) {
		mySession = sessionResultSet.getString("mySession");
		System.out.println("[diaryOne] mySession 반환값 : " + mySession);
	} else {
		System.out.println("[diaryOne] Session 반환 실패");
	} */


	////
	String diaryDate = request.getParameter("diaryDate");
	System.out.println("[diaryOne] request-param diaryDate : " + diaryDate);
	
	//
	String findDiaryQuery = "SELECT diary_date diaryDate, title, weather, content FROM diary WHERE diary_date = ?";
	PreparedStatement findDiaryPsmt = null;
	ResultSet diaryResultSet = null;
	findDiaryPsmt =  con.prepareStatement(findDiaryQuery);
	findDiaryPsmt.setString(1, diaryDate);
	diaryResultSet = findDiaryPsmt.executeQuery();
	
	if(diaryResultSet.next()) {
		System.out.println("[diaryOne] diary 조회 성공");
	} else {
		System.out.println("[diaryOne] diary 조회 실패");
		response.sendRedirect("/diary/diaryCalendar.jsp");
	}
	
	
	
	// DB 연결 해제

	con.close();

	
	String imgUrl = "";
	String weatherStr = "";
	if (diaryResultSet.getString("weather").equals("맑음")) {
		imgUrl = "'./img/spring.png'";
		weatherStr = "Sunny";
	} else if (diaryResultSet.getString("weather").equals("흐림")){
		imgUrl = "'./img/summer.png'";
		weatherStr = "Cloudy";
	} else if (diaryResultSet.getString("weather").equals("비")){
		imgUrl = "'./img/autumn.jpg'";
		weatherStr = "Rainy";
	} else {
		imgUrl = "'./img/winter.png'";
		weatherStr = "Snowy";
	}
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="./main.css"/>
    <style>
    	main {
    		color: #fff;
    		font-size: 22px;
    	}
    	.nav-bottom {
			display: flex;
    	}
    	ul {
    		width: 800px;
			margin: auto 0;
			background-size: 100%;
    	}
    	ul.nav-bottom li {
    		width : 25%;
    		border: 1px solid;
   			text-align: center;
    	}
    	ul.nav-bottom li a {
			display: block;
    	}
    	.title-p{
    		
    		font-size: 14px;
		    font-weight: 500;
		    text-transform: uppercase;
		    text-align: center;
		    letter-spacing: 0.08em;
		    line-height: 14px;
		    margin: 20px 0 50px;
		    color: white;
    	}
    	#contentID {
    		color: white;
    		margin: 0 auto;
    	}
    </style>
</head>
<body>
    <header>
        <sub-a></sub-a>
        <sub-b></sub-b>
        <!-- 이미지를 src로 넣으면 화면 크기에 따라 다르게 보이는 배경이미지 불가능. css background 배경으로 넣어줘야함 -->
        <a href="/diary/lunchForm.jsp?lunchDate=<%=diaryDate%>">go to addLunch</a>
        <h1></h1>
        <h2>A <%=weatherStr%> Day's Diary</h2> <!-- 날씨정보 연동-->
        <p class="">about things you don't usually write.</p>
    </header>
    <main class="content">
        
            <h2><%=diaryResultSet.getString("title") %></h2>
            <h3 class="title-p"><%=diaryResultSet.getString("diaryDate")%></h3> <!-- 오늘 날짜 연동-->
            <p id="contentID">
            	<%=diaryResultSet.getString("content")%>
            </p> 
			<ul class="nav-bottom">
		        <li>Menu</li>
		        <li><a href="">Write</a></li>
		        <li><a href="/diary/updateDiaryForm.jsp?diaryDate=<%=diaryDate%>">Update</a></li>
		        <li><a href="/diary/deleteDiaryAction.jsp?diaryDate=<%=diaryDate%>">Delete</a></li>
       		</ul>
    </main>
    <footer>
        <p>2024 &copy; Copyrights My blog. All rights reserved.</p>
    </footer>
</body>

</html>
