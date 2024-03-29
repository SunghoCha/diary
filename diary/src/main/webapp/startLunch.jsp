<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
System.out.println("=============== startLunch ===============");
// 0. 로그인(인증) 분기
// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")

	String sql1 = "select my_session mySession from login";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	System.out.println("[startLunch] DB 연결 성공");
	// findSessionQuery 실행 및 결과 반환
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	String mySession = null;
	if(rs1.next()) {
		mySession = rs1.getString("mySession");
	}
	// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
	if(mySession.equals("OFF")) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용
	}
%>
<%
	/* 
		SELECT COUNT(*) 
		FROM lunch
		GROUP BY menu
		ORDER BY COUNT(*) DESC;
	*/
	String sql2 = "SELECT COUNT(*) cnt, menu FROM lunch GROUP BY menu";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	System.out.println("[startLunch] binding query : " + stmt2);
	rs2 = stmt2.executeQuery();
	
	String[] c = {"#FF0000", "#FF5E00", "#FFE400", "#1DDB16", "#0054FF"};
		
	double maxHeight = 300;
	double totalCnt = 0;
	while(rs2.next()) {
		totalCnt = totalCnt + rs2.getInt("cnt");	
	}
	rs2.beforeFirst();	

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<style>
		table tbody,td {
			vertical-align:bottom;
			text-align:center;
			margin: 0 auto;
		}
		#div {
			vertical-align:bottom;
			margin: 0 auto;
		}
		#align-table {
			margin: 0 auto;
			text-align: center;
		}
	</style>
	<head>
	<meta charset="UTF-8">
	<title></title>
	<link rel="stylesheet" href="./main.css"/>
	<link href="https://fonts.googleapis.com/css2?family=Lato&display=swap" rel="stylesheet">
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
</head>
<body>
	<header>
        <sub-a></sub-a>
        <sub-b></sub-b>
        <div>
        	<a href="/diary/diaryCalendar.jsp">go to calendar</a>
        	<a href="/diary/diaryList.jsp">go to list</a>
        	<a href="/diary/startLunch.jsp">go to startLunch</a>
        	<a href="/diary/lunchForm.jsp">go to addLunch</a>
        </div>
        <!-- 이미지를 src로 넣으면 화면 크기에 따라 다르게 보이는 배경이미지 불가능. css background 배경으로 넣어줘야함 -->
        <h1></h1>
        <h2>A Cloudy Day's Diary</h2> <!-- 날씨정보 연동-->
        <p>about things you don't usually write.</p>
	</header>
	<main class="content">
	<div style="text-align: center">
		전체 투표수 : <%=(int)totalCnt%>
	</div>
	<div id="align-table">	
	<table id="align-table" border="1">
		<tr>
			<%
				int i = 0;
			
				while (rs2.next()) {
					int h = (int)(maxHeight * (rs2.getInt("cnt")/totalCnt));
			%>	
			<td id="div">
				<div id="div" style="height: <%=h*1.5%>px; background-color: <%=c[i]%>;">
				<%=rs2.getInt("cnt")%>
				</div>
			</td>
			<% 
					i = i + 1;
				}
			%>
		</tr>
		<tr>
			<%
				// 커서 위치 초기화
				rs2.beforeFirst();
				while (rs2.next()) {
			%>
			<td><%=rs2.getString("menu")%></td>
			<% 	
			}
			%>
		</tr>
	</table>
	</div>
	</main>
</body>
</html>