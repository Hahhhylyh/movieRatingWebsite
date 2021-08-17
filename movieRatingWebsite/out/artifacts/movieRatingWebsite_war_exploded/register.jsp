<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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

		.register-box{
			width: 280px;
			position: absolute;
			top: 50%;
			left: 50%;
			transform: translate(-50%,-50%);
			color: white;
		}
		.register-box h1{
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

		.register_btn {
			background-color: black;
			text-align: center;
			padding: 7px;
			margin:0 auto;
			margin-bottom:15px;
			width: 120px;
			font-size: 1.2em;
			color: white;
			cursor: pointer;
		}

		.register_btn:hover {
			opacity: 0.7;
		}
	</style>
</head>

<body>

	<audio id="myAudio" autoplay loop >
		<source src="register.mp3" type="audio/mpeg">
	</audio>

	<div class="register-box">
		<h1>Register</h1>

		<form id="rg" method="post" action="RegisterServlet">
			<div class="text_box">
				<input type="text" name="username" placeholder="username" style="width:250px; height: 25px;" required/>
			</div>

			<div class="text_box">
				<input type="password" id="pw" name="password" placeholder="password" style="width:250px; height: 25px" required />
			</div>

			<div class="text_box">
				<input type="password" id="c_pw" name="confirm_password" placeholder="confirm password" style="width:250px; height: 25px" required />
			</div>

			<div style="margin-top: 30px;">
				<input type="submit" class="register_btn" value="Sign Up" onclick="return check_pass()" />
			</div>

			<script type="text/javascript">
				function check_pass() {
					var pw = document.getElementById('pw').value;
					var c_pw = document.getElementById('c_pw').value
					if (pw != c_pw) {
						alert("Password not matching.");
						return false
					}
					return true;
				}
			</script>

			<div><a href="login.jsp" style="color:white"> Already have account? Login in now. </a></div>
		</form>
	</div>

</body>
</html>