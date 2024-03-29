<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
System.out.println("=============== diaryCalendar ===============");
	//  1. 요청 분석
	// 출력하고자하는 달력의 년과 월값을 넘겨받음
	String targetYear = request.getParameter("targetYear");
	String targetMonth = request.getParameter("targetMonth");
	
	Calendar target = Calendar.getInstance();
	
	if (targetYear != null && targetMonth != null) {
		target.set(Calendar.YEAR, Integer.parseInt(targetYear));
		target.set(Calendar.MONTH, Integer.parseInt(targetMonth));
	}
	// 시작공백의 개수 -> 1일의 요일이 필요 -> 요일에 맵핑된 숫자 -> 타겟 날짜를 1일로 변경
	target.set(Calendar.DATE, 1);
	
	// 달력 타이틀로 출력할 변수
	int tYear = target.get(Calendar.YEAR);
	int tMonth = target.get(Calendar.MONTH);
	
	int yoNum = target.get(Calendar.DAY_OF_WEEK); // 일:1, 월:2, /// 토:7
	System.out.println(yoNum);
	// 시작공백의 개수 : 일요일 공백이 없고, 월요일은 1칸, 화요일은 2칸,.. yoNUm - 1이 공백의 개수
	int startBlank = yoNum - 1;
	int lastDate = target.getActualMaximum(Calendar.DATE); // target달의 마지막 날짜 반환
	
	int countDiv = startBlank + lastDate;
	
	String imgUrl = "";
	String season = "";
	if (3 <= tMonth+1 && tMonth+1 <= 5) {
		imgUrl = "'./img/spring.png'";
		season = "봄";
	} else if (6 <= tMonth+1 && tMonth+1 <= 8){
		imgUrl = "'./img/summer.png'";
		season = "여름";
	} else if (9 <= tMonth+1 && tMonth+1 <= 11){
		imgUrl = "'./img/autumn.jpg'";
		season = "가을";
	} else {
		imgUrl = "'./img/winter.png'";
		season = "겨울";
	}
	
	// DB
	Connection con = null;
	PreparedStatement findSessionPsmt = null;
	ResultSet sessionResultSet = null;
	Class.forName("org.mariadb.jdbc.Driver");
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	System.out.println("[diaryCalendar] DB 연결 성공");
	// findSessionQuery 실행 및 결과 반환
	String findSessionQuery = "SELECT feeling, diary_date diaryDate, LEFT(title, 5) title, DAY(diary_date) day FROM diary WHERE YEAR(diary_date) = ? AND MONTH(diary_date) = ?";
	findSessionPsmt = con.prepareStatement(findSessionQuery);
	findSessionPsmt.setInt(1, tYear);
	findSessionPsmt.setInt(2, tMonth + 1);
	System.out.println("[diaryCalendar] findSessionQuery : " + findSessionPsmt);
	sessionResultSet = findSessionPsmt.executeQuery();
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>달력</title>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="./main.css"/>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>

	<style>
		.calendar {
			display: flex;
			padding:none;
			width: 900px;
/* 			border-top: 1px solid black;
			border-left: 1px solid black; */
			background-color: rgba(255,255,255,0);
			flex-wrap: wrap;
			box-sizing: border-box;			
		}
		.calendar .cell {
			font-family: 'Poppins', sans-serif;
			font-size:30px;
			width: calc(100%/7);
			height: 128px;
			line-height: 128px;
/*  			border-right: 1px solid black;
			border-bottom: 1px solid black; */
			box-sizing: border-box;
			text-align: center;	
			font-weight: 400;
			overflow: auto;
			
		}
		.yo {font-weight: 700; color:#fff;}
		.sun {color: red;} /* #ff685d; */
		.calendar div.yo {
			border-bottom : none;
		}
		/* .calendar div.number {color:#fff;} */
		.calendar div.number:hover {
			background: #000;
			color:#fff;
			font-weight: 700;
			cursor:pointer;
		}
		.calendar div.number:nth-child(7n + 1) {
			color: red;
		}
		.align-p {
			position :relative;
			margin-left: -50px;
		}
		.align-right {
			position: absolute;
			top:50%; left:calc(100% + 120px)
		}
		.align-left {
			position: absolute;
			top:50%; right:calc(100% + 120px)
		}
		i {
    		font-size: 3rem;
    		color: #fff;
		}
		i:hover {
			color:blue;
			background-color: none;
			background-size: cover;
		}
		.arrow-right {
			background: url(/diary/img/angles-right-solid.svg) no-repeat;
			display:inline-block;
		}
		.arrow-left {
			background: url(/diary/img/angles-left-solid.svg) no-repeat;
			display:inline-block;
		}
		#title {
			color:white;
			font-size: 40px;
		}
		.custom-btn {
		  width: 120px;
		  height: 35px;
		  color: #fff;
		  border-radius: 5px;
		  padding: 5px 15px;
		  font-family: 'Lato', sans-serif;
		  font-size: 16px;
		  font-weight: 900;
		  font-style: normal;
		  text-shadow: 0px -1px 0px rgba(0,0,0,0.4);
		    text-decoration: none;
		  background: transparent;
		  cursor: pointer;
		  position: relative;
		  display: inline-block;
		  box-shadow: inset 0px 1px 0px rgba(255,255,255,1),0px 1px 3px rgba(0,0,0,0.3);
		  outline: none;
		  border: 1px solid #ba6;
		  line-height:1;
			}

		.title-font-size{
			font-size: 17px;
		}
		a {
			display: block;
			color: white;
		}
		a:hover {color: #fff; background-color: #070705;}
	<svg style="position: absolute; width: 0; height: 0;" width="0" height="0" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" class="svg-sprite">
	    <defs>
	        <filter id="filter">
            <feTurbulence type="fractalNoise" baseFrequency="0.000001 0.000001" numOctaves="1" result="warp" seed="1"></feTurbulence>
            <feDisplacementMap xChannelSelector="R" yChannelSelector="G" scale="30" in="SourceGraphic" in2="warp"></feDisplacementMap>
	        </filter>
	    </defs>
	</svg>
	</style>

</head>
<body class="bg-body">
	<header>
        <sub-a></sub-a>
        <sub-b></sub-b>
        <div>
        	<a href="/diary/diaryCalendar.jsp">go to calendar</a>
        	<a href="/diary/diaryList.jsp">go to list</a>
        	<a href="/diary/startLunch.jsp">go to startLunch</a>
        </div>
        <!-- 이미지를 src로 넣으면 화면 크기에 따라 다르게 보이는 배경이미지 불가능. css background 배경으로 넣어줘야함 -->
        <h1></h1>
        <h2>A Cloudy Day's Diary</h2> <!-- 날씨정보 연동-->
        <p>about things you don't usually write.</p>
    </header>
    <main class="content">
    	<div class="align-p">
		<h3 id="title"><%=tYear%>년 <%=tMonth+1%>월 <%=season%></h3>
		<div class="align-left">
			<a href="./diaryCalendar.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth - 1%>" class="button">
				<i class="fa-solid fa-angles-left"></i>
			</a>
		</div>
		<div class="align-right">
			<a href="./diaryCalendar.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth + 1%>" class="button">
				<i class="fa-solid fa-angles-right"></i>
			</a>
		</div>
		<div class="calendar">
			<div class="cell yo sun">Sun</div>
			<div class="cell yo">Mon</div>
			<div class="cell yo">Tus</div>
			<div class="cell yo">Wen</div>
			<div class="cell yo">Thu</div>
			<div class="cell yo">Fri</div>
			<div class="cell yo">Sat</div>
		</div>
	
		<!-- DATE값이 들어갈 DIV -->
	 	<div class="calendar"> 		
		<%
			for(int i = 1; i <= countDiv; i = i + 1) {
				
				if(i - startBlank > 0) {
		%>
					
					<div class="number cell"><%=i - startBlank%><br>
		<%
					// 현재날짜(i - startBlank)의 일기가 ResultSet 목록에 있는지 비교
					while(sessionResultSet.next()) {
						if(sessionResultSet.getInt("day") == (i-startBlank)) {
		%>
					<%= sessionResultSet.getString("feeling")%>
					<a class="title-font-size" href='/diary/diaryOne.jsp?diaryDate=<%=sessionResultSet.getString("diaryDate")%>'>
					<%=sessionResultSet.getString("title")%>...</a>
		<%					
							break;
						}
					}
					sessionResultSet.beforeFirst();
					%>
					</div>
					<%
				} else {
		%>
					<div class="number cell">&nbsp;</div>
		<%
				}
			}
		%>	
		
		</div>
		<form method="post" action="./logoutAction.jsp">
			<input class="btn custom-btn btn-8" type="submit" value="Logout">
		</form>
	</main>
</body>
</html>