<%@ page import="java.util.ConcurrentModificationException" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	if (session.getAttribute("username") == null)
		response.sendRedirect("login.jsp");
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

		.link-button {
		  font: inherit;
		  background: none;
		}

		.item5 {
			margin: 10px auto 20px auto;
			text-align: center;
			width:175px; 
			word-wrap: break-word;
			font-family: Verdana, "Microsoft YaHei", serif;
			font-size: 16px;
			cursor: pointer;
		}

		.movie_container {
			position: relative;
			font-family: Comic Sans MS;
		}

		.movie_caption {
			position: absolute; 
			top: 20px;
			left: 20px;
			right:20px;
			background-color: black;
			color: white;
			padding: 20px;
			opacity: 0.9;
			font-size: 20px;
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

		.movie_properties {
			font-size: 1.1em;
			font-family: Arial, Helvetica, sans-serif;
		}

		.movie_properties th {
			text-align: left;
			vertical-align: top;
			width: 130px;
			color: #666666;
		}

		.header {
			font-family: SimHei;
			font-weight: bold;
			width: 1000px;
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

		a { color: #1588C8; }

		a:link, a:visited { text-decoration: none; }

		a:hover { opacity: 0.7 }
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
	
	<div class="header" style="margin: 20px auto; font-size: 3.0em; font-weight: 900;">
		User Profile
	</div>

	<div style="margin: 30px auto; width: 800px;">
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
						<img src="<%=request.getParameter("uid")%>.png" onerror="defaultImg(this)" width="200px" height="200px">
						<script>
							function defaultImg(img){
								img.src = "avatar.png";
								return true;
							}
						</script>
					</div>
				</td>
				<td width="50%" style="padding: 0 30px 20px 10px; border-left: 2px dotted silver;">
					<%
						if(session.getAttribute("uid").equals(request.getParameter("uid")))
						{
					%>
					<div style="text-align: right; font-size: 1.2em;"><a href="edit_profile.jsp?uid=<%=rs.getString("user_id")%>" class="fa fa-pencil-square-o"></a></div>
					<%
						}
					%>
					<table class="movie_properties" cellpadding="5px">
						<tr>
							<th>Username: </th>
							<td><%=rs.getString("username")%></td>
						</tr>
						<tr>
							<th>Gender: </th>
							<td>
								<%
									if (rs.getInt("gender") == 1)
										out.print("Male");
									else if (rs.getInt("gender") == 2)
										out.print("Female");
									else
										out.print("null");
								%>
							</td>
						</tr>
						<tr>
							<th>Date of Birth: </th>
							<td><%=rs.getString("dob")%></td>
						</tr>
						<tr>
							<th>Email: </th>
							<td><%=rs.getString("email")%></td>
						</tr>
						<tr>
							<th>Location: </th>
							<td><%=rs.getString("location")%></td>
						</tr>
						<tr>
							<th>Quote: </th>
							<td>"<%=rs.getString("quote")%>"</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>

	<%
		Statement stm_comment = conn.createStatement();
		String sql_comment = "select date_format(mu.last_modified, \"%Y-%m-%d %T\") as lm, mu.*, m.movie_name, m.year, m.img\n" +
				"from movie_user as mu join movie as m using(movie_id)\n" +
				"where user_id = " + request.getParameter("uid") + "\n" +
				"order by last_modified desc";
		ResultSet rs_comment = stm_comment.executeQuery(sql_comment);
		rs_comment.last();
		int row_count = rs_comment.getRow();
		rs_comment.beforeFirst();
	%>

	<%
		if(request.getParameter("uid").equals(session.getAttribute("uid")))
		{
	%>

	<div class="header" style="margin: 40px auto; font-size: 1.6em; font-weight: bold;">
		My reviews · · · · · · (<%=row_count%>)
	</div>

	<%
		}
		else
		{
	%>

	<div class="header" style="margin: 40px auto; font-size: 1.6em; font-weight: bold;">
		<%=rs.getString("username")%> 的 reviews · · · · · · (<%=row_count%>)
	</div>

	<%
		}
	%>

	<%
		while(rs_comment.next())
		{
	%>
	<div style="margin: 30px auto; width: 1000px;">
		<table width="100%" style="padding-bottom: 20px; border-bottom: 1.5px dashed grey;">
			<tr style="float: left; vertical-align: top;">
				<td>
					<div style="margin: 0 auto; text-align: left; padding-right: 10px;">
						<a href="movie_profile.jsp?mid=<%=rs_comment.getString("movie_id")%>">
							<img src="<%=rs_comment.getString("img")%>" width="80px" height="120px">
						</a>
					</div>
				</td>
				<td>
					<table cellpadding="3px;">
						<tr>
							<th></th>
							<td style="font-size: 1.1em; font-weight: bold;">
								<a href="movie_profile.jsp?mid=<%=rs_comment.getString("movie_id")%>"><%=rs_comment.getString("movie_name")%> (<%=rs_comment.getString("year")%>)</a>
							</td>
						</tr>
						<tr>
							<th></th>
							<td>
								<div class="fa fa-star <%if(rs_comment.getInt("star") >= 1) {%> checked <%}%>"></div>
								<div class="fa fa-star <%if(rs_comment.getInt("star") >= 2) {%> checked <%}%>"></div>
								<div class="fa fa-star <%if(rs_comment.getInt("star") >= 3) {%> checked <%}%>"></div>
								<div class="fa fa-star <%if(rs_comment.getInt("star") >= 4) {%> checked <%}%>"></div>
								<div class="fa fa-star <%if(rs_comment.getInt("star") == 5) {%> checked <%}%>"></div>
								<div style="display: inline-block; padding-left: 8px;"><%=rs_comment.getString("lm")%></div>
							</td>
						</tr>
						<tr>
							<th></th>
							<td style="font-size: 1.05em; font-weight: bold;"><%=rs_comment.getString("title")%></td>
						</tr>
						<tr>
							<th></th>
							<td>
								 <%=rs_comment.getString("content")%>
							</td>
						</tr>
						<%
							if(session.getAttribute("uid").equals(request.getParameter("uid")))
							{
						%>
						<tr>
							<th></th>
							<td>
								<button><a href="movie_profile.jsp?mid=<%=rs_comment.getString("movie_id")%>">Edit</a></button>
								<button><a href="DelCommentServlet?mid=<%=rs_comment.getString("movie_id")%>&uid=<%=request.getParameter("uid")%>">Delete</a></button>
							</td>
						</tr>
						<%
							}
						%>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<%
		}
	%>

	<div style="bottom:0px; width:100%; line-height:25px; margin-top:20px; text-align:center; padding:15px;">
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

<!--
	<div>Rating Analysis</div>
						<div style="font-size: 2.0em; padding: 10px 10px 15px 0px; display: inline-block;">10.0</div>
						<div style="margin: 0 auto; vertical-align: center; display: inline-block;">
							<div class="fa fa-star checked"></div>
							<div class="fa fa-star"></div>
							<div class="fa fa-star"></div>
							<div class="fa fa-star"></div>
							<div class="fa fa-star"></div>	
						</div>
						<div>based on 123 reviews</div>

-->