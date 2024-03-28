<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
System.out.println("=============== addDiaryForm ===============");
// 0. 로그인(인증) 분기
// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")

	String sql1 = "select my_session mySession from login";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	System.out.println("[addDiaryForm] DB 연결 성공");
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
	String checkDate = request.getParameter("checkDate");
	if(checkDate == null) {
		checkDate = "";
	}
	String ck = request.getParameter("ck");
	if(ck == null) {
		ck = "";
	}
	
	String msg = "";
	if(ck.equals("T")) {
		msg = "입력이 가능한 날짜입니다";
	} else if(ck.equals("F")){
		msg = "일기가 이미 존재하는 날짜입니다";
	}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>addDiaryForm</title>
	<link rel="stylesheet" href="./main.css"/>
	<link href="https://fonts.googleapis.com/css2?family=Lato&display=swap" rel="stylesheet">
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
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
			color: #000;
			margin-bottom: 20px;
		}
		main > h2 {
			font-style: italic;
		}
		table{
			border-collapse: separate;
			border-spacing: 20px;
			text-align: center;
			margin-top: 100px;
		}
		input:focus {
	  		outline: none;
		}
		.bg-note{
		    width: 800px; 
		    height: 1052px; 
   	 		margin: 100px auto 0;
    		background-size: 100%;
			background:url(/diary/img/content_bg01.png) no-repeat center top / cover;
		}
		main {
			color: white;
		}

		<svg style="position: absolute; width: 0; height: 0;" width="0" height="0" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" class="svg-sprite">
		    <defs>
		        <filter id="filter">
		            <feTurbulence type="fractalNoise" baseFrequency="0.000001 0.000001" numOctaves="1" result="warp" seed="1"></feTurbulence>
		            <feDisplacementMap xChannelSelector="R" yChannelSelector="G" scale="30" in="SourceGraphic" in2="warp"></feDisplacementMap>
		        </filter>
		    </defs>
		</svg>
body {
  background: #e0e5ec;
}
/* h1 {
  position: relative;
  text-align: center;
  color: #353535;
  font-size: 50px;
  font-family: "Cormorant Garamond", serif;
}
h1:before{
  position: absolute;
  content: "";
  bottom: -10px;
  width: 35%;
  height: 2px;
  background-color: #98d9e1;
background-image: linear-gradient(315deg, #fea 0%, #a95 74%);
} */

p {
  font-family: 'Lato', sans-serif;
  font-weight: 300;
  text-align: center;
  font-size: 18px;
  color: #676767;
}

.title-p{
	color: white;
}
.frame {
  width: 90%;
  margin: 40px auto;
  text-align: center;
}
button {
  margin: 20px;
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
.custom-btn:active{
  -webkit-transform: translateY(2px);
  transform: translateY(2px);
}

/* 1 */
.btn-1{
  backface-visibility: hidden;
  position: relative;
  cursor: pointer;
  display: inline-block;
  white-space: nowrap;
  background: linear-gradient(180deg,#fea 0%,#dc8 49%,#a95 51%,#dc8 100%);
  border-radius: 5px;
}

/* 2 */
.btn-2{
  background: linear-gradient(top, #a95, #f2f2f2 25%, #ffffff 38%, #c5c5c5 63%, #f7f7f7 87%, #a95);
  background: -webkit-linear-gradient(top, #a95, #fea 25%, #ffffff 38%, #dc8  63%, #fea 87%, #a95);
}

/* 3 */
.btn-3{
  background: -webkit-gradient(linear, left top, left bottom, from(#a95), to(#fea));
}

/* 4 */
.btn-4{
   color: #fff;
 background-image: -webkit-repeating-linear-gradient(left, rgba(255, 238, 170, 0) 0%, rgba(255, 238, 170, 0) 3%, rgba(255, 238, 170, .1) 3.75%),
    -webkit-repeating-linear-gradient(left, rgba(170, 153, 85, 0) 0%, rgba(170, 153, 85, 0) 2%, rgba(170, 153, 85, .03) 2.25%),
    -webkit-repeating-linear-gradient(left, rgba(255, 238, 170, 0) 0%, rgba(255, 238, 170, 0) .6%, rgba(255, 238, 170, .15) 1.2%),
    
    linear-gradient(180deg, #a95 0%, 
    #fea 47%, 
    #dc8 53%,
    #fea 100%);
  
}

/* 5 */
.btn-5{
  backface-visibility: hidden;
  position: relative;
  cursor: pointer;
  display: inline-block;
  white-space: nowrap;
  border-color: #7c7c7c;
  background: linear-gradient(180deg,#e6e6e6 0%,rgba(0, 0, 0, 0.25) 49%, rgba(38, 38, 38, 0.6) 51%,rgba(0, 0, 0, 0.25) 100%);
  border-radius: 5px;
}

/* 6 */
.btn-6{
  border-color: #7c7c7c;
  background: linear-gradient(top, rgba(38, 38, 38, 0.8), #e6e6e6 25%, #ffffff 38%, #c5c5c5 63%, #f7f7f7 87%, rgba(38, 38, 38, 0.8));
  background: -webkit-linear-gradient(top, rgba(38, 38, 38, 0.5), #e6e6e6 25%, #ffffff 38%, rgba(0, 0, 0, 0.25)  63%, #e6e6e6 87%, rgba(38, 38, 38, 0.4));
}

/* 7 */
.btn-7{
  border-color: #7c7c7c;
  background: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, 0.25)), to(#e6e6e6));
}

/* 8 */
/* .btn-8{
 border-color: #7c7c7c;
background-image: -webkit-repeating-linear-gradient(left, hsla(0,0%,100%,0) 0%, hsla(0,0%,100%,0)   6%, hsla(0,0%,100%, .1) 7.5%),
    -webkit-repeating-linear-gradient(left, hsla(0,0%,  0%,0) 0%, hsla(0,0%,  0%,0)   4%, hsla(0,0%,  0%,.03) 4.5%),
    -webkit-repeating-linear-gradient(left, hsla(0,0%,100%,0) 0%, hsla(0,0%,100%,0) 1.2%, hsla(0,0%,100%,.15) 2.2%),
    
    linear-gradient(180deg, hsl(0,0%,78%)  0%, 
    hsl(0,0%,90%) 47%, 
    hsl(0,0%,78%) 53%,
    hsl(0,0%,70%)100%);
} */

/* 9 */
.btn-9{
  backface-visibility: hidden;
  position: relative;
  cursor: pointer;
  display: inline-block;
  white-space: nowrap;
  border-color: #D9A3A9;
  background: linear-gradient(180deg,#FFE6E9 0%,#DDA6AE 49%, #B76E79 51%,#DDA6AE 100%);
  border-radius: 5px;
}

/* 10 */
.btn-10{
  border-color: #D9A3A9;
} 

 
.title-font {
	font-style: italic;
	font-size: 500px;
}
.title-margin {
	margin-bottom: 30px;
} 
.button-margin {
	margin-left: 0;
}
	</style>
</head>
<body>
	<header>
        <sub-a></sub-a>
        <sub-b></sub-b>
        <!-- 이미지를 src로 넣으면 화면 크기에 따라 다르게 보이는 배경이미지 불가능. css background 배경으로 넣어줘야함 -->
        <h1></h1>
        <h2>A Cloudy Day's Diary</h2> <!-- 날씨정보 연동-->
        <p class="title-p">about things you don't usually write.</p>
    </header>
    <main class="content">
	<div class="form-one">
<%-- 	checkDate : <%=checkDate%><br>
	ck : <%=ck%> --%>
	
	<h2 class="title-font">Writing</h2>
		<hr class="title-margin">
	
	<form method="post" action="/diary/checkDateAction.jsp">	
		<div>
			CheckDate : <input class="login custom-btn btn-8 button-margin" placeholder="YYYY-MM-DD" type="date" name="checkDate" value="<%=checkDate%>">
			<span><%=msg%></span>
			
		</div>
		<div>
			<button class="custom-btn btn-8" type="submit">checkDate</button>
		</div>
	</form>
	</div>
	
	
	
	<div class="form-two">
	<form method="post" action="/diary/addDiaryAction.jsp">
		<div>
			date : 
			<% 
				if(ck.equals("T")) {
			%>
					<input class="login" value="<%=checkDate%>" type="text" name="diaryDate" readonly="readonly">
			<%		
				} else {
			%>
					<input class="login" value="" type="text" name="diaryDate" readonly="readonly">				
			<%		
				}
			%>	
		</div>
		<div>
			feeling : 
			<input type="radio" name="feeling" value="&#128512">&#128512;
			<input type="radio" name="feeling" value="&#128545">&#128545;
			<input type="radio" name="feeling" value="&#128557">&#128557;
			<input type="radio" name="feeling" value="&#128524">&#128524;;
		</div>
		
		<div>
			title : <input class="login" type="text" name="title">
		</div>
		<div>
			<select class="login custom-btn btn-8" name="weather">
				<option value="맑음">sunny</option>
				<option value="흐림">cloudy</option>
				<option value="비">rainy</option>
				<option value="눈">snowy</option>
			</select>
		</div>
		<div>
			<textarea class="login" rows="7" cols="50" name="content"></textarea>
		</div>
		<div>
			<button class="custom-btn btn-8 button-margin" type="submit">submit</button>
		</div>
	</form>
	</div>

	</main>
	    <footer class="align">
        <p>2024 &copy; Copyrights My blog. All rights reserved.</p>
    </footer>
</body>
</html>
