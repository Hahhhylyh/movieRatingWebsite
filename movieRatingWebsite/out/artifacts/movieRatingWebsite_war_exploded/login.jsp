<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%


	Cookie[] cookies = request.getCookies();

	for(int i = 0; i < cookies.length; ++i)
	{
		if (cookies[i].getName() == "c_username")
		{
			session.setAttribute("username", cookies[i].getValue());
		}
		else if (cookies[i].getName() == "c_uid")
		{
			session.setAttribute("uid", cookies[i].getValue());
		}
	}

	if(session.getAttribute("uid") != null)
	{
		response.sendRedirect("index.jsp");
	}

%>

<html>
<head>
	<style>

		body{
			margin:0;
			padding:0;
			font-family:sans-serif;
			background-image:url("bg.jpg");
			background-size:cover;
			text-align:center;
		}

		input:-webkit-autofill,
		input:-webkit-autofill:hover,
		input:-webkit-autofill:focus,
		input:-webkit-autofill:active {
			-webkit-transition: background-color 9999s ease-out;
			-webkit-transition-delay: 9999s;
			-webkit-text-fill-color: white !important;
		}

		.login-box{
			width: 280px;
			position: absolute;
			top: 50%;
			left: 50%;
			transform: translate(-50%,-50%);
			color: white;
		}
		.login-box h1{
			font-size: 40px;
			border-bottom:6px solid #4caf50;
			margin-bottom:40px;
			padding:13px 0;
		}
		.text_box{
			width:100%;
			overflow:hidden;
			font-size:20px;
			padding:15px 0;
			margin:8px 0;
			border-bottom:1px solid #4caf50;
			letter-spacing: 0.1em;
		}

		.text_box input{
			border: none;
			outline: none;
			background: none;
			color: white;
			font-size: 18px;
			width: 80%;
			float: left;
			margin: 0 15px;
		}

		.login_btn {
			background-color: black;
			text-align: center;
			padding: 7px;
			margin: 0 auto;
			margin-bottom:15px;
			width: 120px;
			font-size: 1.2em;
			color: white;
			cursor: pointer;
		}

		.login_btn:hover {
			opacity: 0.7;
		}

	</style>
</head>


<body>

<audio id="myAudio" autoplay loop >
	<source src="login.mp3" type="audio/mpeg">
</audio>
<div class="login-box">

	<h1>Login</h1>



	<form id="lg" method="post" action="LoginServlet">
		<div class="text_box">
			<input type="text" placeholder="username" name="username" style="width:250px; height: 25px" required>
		</div>
		<div class="text_box">
			<input type="password" placeholder="password" name="password" style="width:250px; height: 25px" required>
		</div>

		<div style="margin-top: 30px;">
			<input type="submit" class="login_btn" value="Log In" onclick="document.getElementById('lg').submit();" />
		</div>
		<div><a href="register.jsp" style="color:white"> No Account? Create One! </a></div>
	</form>
</div>


</body>
</html>