<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%
	if (session.getAttribute("username") == null)
		response.sendRedirect("login.jsp");

	String userid = (session.getAttribute("uid").toString());

	if (!userid.equals(request.getParameter("uid")))
	{
		response.getWriter().println("<script type=\"text/javascript\">");
		response.getWriter().println("alert('You are not allowed to edit other's profile.');");
		response.getWriter().println("</script>");
		response.sendRedirect("user_profile.jsp?uid=" + userid);
	}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title></title>
	<!-- CSS -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<style type="text/css">
		.nav_item
		{
			display: inline-block;
			font-size: 26px;
			font-weight: bold;
			padding: 15px 5px;
		}

		* { box-sizing: border-box; }

		body { 
			font-family: Tahoma, Verdana, Arial, sans-serif;
			background-color:  white;
			color: black;
		}

		strong {
			color: #e09015;
		}

		.btn {
			background: transparent;
			color: black;
			border: none;
			padding: 6px;
  			font-size: 26px;
  			font-family: "Courier New", "KaiTi", monospace;
  			font-weight: bold;
			cursor: pointer;
		}

		.btn:hover {
			background-color: #EEEEEE;
		}

		.dropdown {
			display: inline-block;
			font-size: 26px;
			font-weight: bold;
			padding: 10px;
		}

		.dropdown-content {
		  	display: none;
		  	position: absolute;
		  	background-color: #f9f9f9;
		  	min-width: 160px;
		  	box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
		  	z-index: 1;
		  	font-size: 18px;
		  	font-family: "Courier New", Courier, monospace;
		  	font-weight: normal;
		}

		.dropdown-content a {
		  	float: none;
		  	color: black;
		  	padding: 12px 16px;
		  	text-decoration: none;
		  	display: block;
		  	text-align: left;
		}

		.dropdown-content a:hover {
		  	background-color: #DDDDDD;
		}

		.dropdown:hover .dropdown-content {
			display: block;
		}

		.text-overflow-ellipsis {
		  border: 1px solid black;
		  padding: 10px;
		  width: 250px;
		  overflow: hidden;
		  text-overflow: ellipsis;
		  white-space: nowrap;
		}

		#topBtn {
			display: none;
			position: fixed;
			bottom: 25px;
			right: 30px;
			z-index: 99;
			font-size: 40px;
			background-color: transparent;
			color: white;
			cursor: pointer;
			border: none;
		}

		.header {
			font-family: SimHei;
			font-weight: bold;
			width: 800px;
		}

		.checked {
			color: orange;
		}

		.bar-5 {width: 4%; height: 18px; background-color: #4CAF50;}
		.bar-4 {width: 60%; height: 18px; background-color: #2196F3;}
		.bar-3 {width: 21%; height: 18px; background-color: #00bcd4;}
		.bar-2 {width: 10%; height: 18px; background-color: #ff9800;}
		.bar-1 {width: 5%; height: 18px; background-color: #f44336;}

		.bar-container {
			width: 100%;
		}

		/* Taken from (the star input): https://codepen.io/hesguru/pen/BaybqXv */

		.rate {
		    float: left;
		    height: 46px;
		    padding: 0 10px;
		}
		.rate:not(:checked) > input {
		    position:absolute;
		    top:-9999px;
		}
		.rate:not(:checked) > label {
		    float:right;
		    width:1em;
		    overflow:hidden;
		    white-space:nowrap;
		    cursor:pointer;
		    font-size:30px;
		    color:#ccc;
		}
		.rate:not(:checked) > label:before {
		    content: '★ ';
		}
		.rate > input:checked ~ label {
		    color: #ffc700;    
		}
		.rate:not(:checked) > label:hover,
		.rate:not(:checked) > label:hover ~ label {
		    color: #deb217;  
		}
		.rate > input:checked + label:hover,
		.rate > input:checked + label:hover ~ label,
		.rate > input:checked ~ label:hover,
		.rate > input:checked ~ label:hover ~ label,
		.rate > label:hover ~ input:checked ~ label {
		    color: #c59b08;
		}

		.myInput {
			width: 500px;
			padding: 5px;
			letter-spacing: 0.1em;
		}

		.myInput {
			width: 300px;
			padding: 5px;
			letter-spacing: 0.1em;
		}
	</style>
</head>
<body>
	<div style="margin: 0 auto; width: 1200px;">
		<div style="display: inline-block;">
			<div class="nav_item">
				<a href="index.jsp"><button class="btn" id="home"><i class="fa fa-home"></i> Home</button></a>
			</div>
			<div class="dropdown">
				<button class="btn" id="dmenu"><i class="fa fa-bars"></i> Menu</button>
				<div class="dropdown-content">
					<%
						if(session.getAttribute("isAdmin") != null)
						{
					%>
					<a href="add_movie.jsp">Add Movie</a>
					<a href="admin.jsp">Manage Users</a>
					<%
						}
					%>
					<a href="sorting_page.jsp?genre=0&language=0&sorting=0">Movie Sorting</a>
				</div>
			</div>
			<div style="display: inline-block; margin-left: 20px">
				<form method="get" action="search_result.jsp">
					<input type="text" placeholder="Search.." name="search" style="font-size: 20px; padding:6px; border: none; text-indent: 10px; width: 550px;">
					<button type="submit" style="position: absolute; overflow:hidden; background: white; border: none; cursor: pointer;"><i class="fa fa-search" style="margin:6.6px; font-size: 20px;"></i></button>
				</form>
			</div>
		</div>
		<div style="float: right; width: 300px;">
			<div class="nav_item" style="width: 250px; text-align: center;">
				<a href="user_profile.jsp?uid=<%=session.getAttribute("uid")%>"> <button class="btn" id="user" style="width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-size: 24px;"><i class="fa fa-user"></i> <%=session.getAttribute("username")%></button> </a>
			</div>
			<div class="nav_item" style="float: right;">
				<a href="LogoutServlet"> <button class="btn"><i class="fa fa-sign-out" aria-hidden="true"></i></button></a>
			</div>
		</div>
	</div>

	<div style="margin: 30px auto; width: 800px;">
		<div class="header" style="margin: 30px auto 50px auto; font-size: 3.0em; text-align: center;">
			Editing Profile...
		</div>
		<table width="100%">
			<tr>
				<td width="30%">
					<div style="margin: 0 auto; text-align: left;">
						<%
							Class.forName("com.mysql.jdbc.Driver");
							Connection conn =
									DriverManager.getConnection(
											"jdbc:mysql://localhost:3306/rating_website",
											"root", "admin");
							Statement stm = conn.createStatement();
							ResultSet rs = stm.executeQuery("select * from users where user_id = " + request.getParameter("uid"));
							rs.next();
						%>
						<img src="<%=session.getAttribute("uid")%>.png" width="200px" height="200px">
						<form style="padding: 5px;" method="post" action="EditUserProfileServlet" enctype="multipart/form-data" >
							<input type="hidden" name="doWhat" value="picture" />
							<input type="file" name="avatar" style="margin-bottom: 10px;" /><br/>
							<input type="submit">
						</form>
					</div>
				</td>
				<td width="50%" style="padding: 0 30px 20px 10px; border-left: 2px dotted silver;">
					<form method="post" action="EditUserProfileServlet">
						<input type="hidden" name="doWhat" value="info" />
						<table class="movie_properties" cellpadding="5px" style="text-align: left;">
							<tr>
								<th>Username: </th>
								<td style="padding-left: 10px"><%=rs.getString("username")%></td>
							</tr>
							<tr>
								<th>Gender: </th>
								<%
									String gd;
									if(rs.getInt("gender") == 1)
										gd = "Male";
									else if(rs.getInt("gender") == 2)
										gd = "Female";
									else
										gd = "null";
								%>
								<td><input type="text" name="gender" class="myInput" value="<%=gd%>" /></td>
							</tr>
							<tr>
								<th>Date of Birth: </th>
								<td><input type="text" name="dob" class="myInput" value="<%=rs.getString("dob")%>" /></td>
							</tr>
							<tr>
								<th>Email: </th>
								<td><input type="text" name="email" class="myInput" value="<%=rs.getString("email")%>" /></td>
							</tr>
							<tr>
								<th>Location: </th>
								<td><input type="text" name="location" class="myInput" value="<%=rs.getString("location")%>" /></td>
							</tr>
							<tr>
								<th>Quote: </th>
								<td><input type="text" name="quote" class="myInput" value="<%=rs.getString("quote")%>" /></td>
							</tr>
							<tr>
								<th></th>
								<td style="text-align: right; padding-right: 37px;"> 
									<input type="submit"  style="margin-right: 10px;" />
									<input type="Reset" />
								</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
		</table>
	</div>

	<div style="position: fixed; bottom:0px; width:100%; line-height:25px; margin-top:20px; text-align:center; padding:15px;">
		Copyright 2017 - 2020, Xiamen University <br/>
		Bookman Development Team
	</div>

	<button id="topBtn"><a href="#"><i class="fa fa-chevron-circle-up"></a></i></button>

	<script type="text/javascript">
		//Get the button
		var mybutton = document.getElementById("topBtn");
		console.log(mybutton);

		// When the user scrolls down 20px from the top of the document, show the button
		window.onscroll = function() {scrollFunction()};

		function scrollFunction() {
		  	if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
		    	mybutton.style.display = "block";
		  	} else {
		    	mybutton.style.display = "none";
		  	}
		}
	</script>
</body>
</html>