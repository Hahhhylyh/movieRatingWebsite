<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
			width: 1000px;
		}

		.table_content {
			border-collapse: collapse;
			white-space: nowrap;
			text-overflow: ellipsis;
			overflow: hidden;
		}

		a { color: black; }

		a:link, a:visited { text-decoration: none; }

		a:hover { opacity: 0.7; }
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
	
	<div class="header" style="margin: 20px auto; font-size: 3.0em; font-weight: 900; text-align: center;">
		Admin Page
	</div>

	<div style="margin: 30px auto; width: 1200px; text-align: left; font-size: 0.9em;">
		<table width="100%" style="border-spacing: 20px;">
			<tr style="vertical-align: super;">
				<td width="33%">
					<%
						Class.forName("com.mysql.jdbc.Driver");
						Connection conn =
								DriverManager.getConnection(
										"jdbc:mysql://localhost:3306/rating_website",
										"root", "admin");
						Statement stm = conn.createStatement();
						ResultSet rs1 = stm.executeQuery(
								"select user_id, username, email, status, date_format(registered_date, \"%M %e %Y %T\") as rd\n" +
										"from users\n" +
										"where user_id mod 3 = 1");
						while(rs1.next())
						{
					%>
					<div style="padding: 10px 20px ; border: 2px solid grey; margin-bottom: 20px;">
						<div style="text-align: center;">
							<a href="user_profile.jsp?uid=<%=rs1.getString("user_id")%>">
								<img src="<%=rs1.getString("user_id")%>.png" onerror="defaultImg(this)" width="128px" height="128px">
								<script>
									function defaultImg(img){
										img.src = "avatar.png";
										return true;
									}
								</script>
							</a>
						</div>
						<table cellpadding="5px" width="100%" style="table-layout: fixed;">
							<tr>
								<th width="40%">Username: </th>
								<td width="60%" class="table_content"><%=rs1.getString("username")%></td>
							</tr>
							<tr>
								<th>Email: </th>
								<td class="table_content"><%=rs1.getString("email")%></td>
							</tr>
							<tr>
								<th>Creation Date: </th>
								<td class="table_content"><%=rs1.getString("rd")%></td>
							</tr>
							<tr>
								<th>Status: </th>
								<td class="table_content">
									<%
										if(rs1.getInt("status") == 1)
											out.print("User");
										else if(rs1.getInt("status") == 2)
											out.print("Admin");
										else
											out.print("Forbidden");
									%>
								</td>
							</tr>
						</table>
						<div style="text-align: center; padding: 5px;">
							<button><a href="PCServlet?action=2&uid=<%=rs1.getString("user_id")%>">Promote</a></button>
							<button><a href="PCServlet?action=1&uid=<%=rs1.getString("user_id")%>">Degrade</a></button>
							<button><a href="PCServlet?action=3&uid=<%=rs1.getString("user_id")%>">Forbidden</a></button>
						</div>
					</div>
					<%
						}
					%>
				</td>
				
				<td width="34%">
					<%
						ResultSet rs2 = stm.executeQuery(
								"select user_id, username, email, status, date_format(registered_date, \"%M %e %Y %T\") as rd\n" +
										"from users\n" +
										"where user_id mod 3 = 2");
						while(rs2.next())
						{
					%>
					<div style="padding: 10px 20px ; border: 2px solid grey; margin-bottom: 20px;">
						<div style="text-align: center;">
							<a href="user_profile.jsp?uid=<%=rs2.getString("user_id")%>">
								<img src="<%=rs2.getString("user_id")%>.png" onerror="defaultImg(this)" width="128px" height="128px">
								<script>
									function defaultImg(img){
										img.src = "avatar.png";
										return true;
									}
								</script>
							</a>
						</div>
						<table cellpadding="5px" width="100%" style="table-layout: fixed;">
							<tr>
								<th width="40%">Username: </th>
								<td width="60%" class="table_content"><%=rs2.getString("username")%></td>
							</tr>
							<tr>
								<th>Email: </th>
								<td class="table_content"><%=rs2.getString("email")%></td>
							</tr>
							<tr>
								<th>Creation Date: </th>
								<td class="table_content"><%=rs2.getString("rd")%></td>
							</tr>
							<tr>
								<th>Status: </th>
								<td class="table_content">
									<%
										if(rs2.getInt("status") == 1)
											out.print("User");
										else if(rs2.getInt("status") == 2)
											out.print("Admin");
										else
											out.print("Forbidden");
									%>
								</td>
							</tr>
						</table>
						<div style="text-align: center; padding: 5px;">
							<button><a href="PCServlet?action=2&uid=<%=rs2.getString("user_id")%>">Promote</a></button>
							<button><a href="PCServlet?action=1&uid=<%=rs2.getString("user_id")%>">Degrade</a></button>
							<button><a href="PCServlet?action=3&uid=<%=rs2.getString("user_id")%>">Forbidden</a></button>
						</div>
					</div>
					<%
						}
					%>
				</td>

				<td width="33%">
					<%
						ResultSet rs3 = stm.executeQuery(
								"select user_id, username, email, status, date_format(registered_date, \"%M %e %Y %T\") as rd\n" +
										"from users\n" +
										"where user_id mod 3 = 0");
						while(rs3.next())
						{
					%>
					<div style="padding: 10px 20px ; border: 2px solid grey; margin-bottom: 20px;">
						<div style="text-align: center;">
							<a href="user_profile.jsp?uid=<%=rs3.getString("user_id")%>">
								<img src="<%=rs3.getString("user_id")%>.png" onerror="defaultImg(this)" width="128px" height="128px">
								<script>
									function defaultImg(img){
										img.src = "avatar.png";
										return true;
									}
								</script>
							</a>
						</div>
						<table cellpadding="5px" width="100%" style="table-layout: fixed;">
							<tr>
								<th width="40%">Username: </th>
								<td width="60%" class="table_content"><%=rs3.getString("username")%></td>
							</tr>
							<tr>
								<th>Email: </th>
								<td class="table_content"><%=rs3.getString("email")%></td>
							</tr>
							<tr>
								<th>Creation Date: </th>
								<td class="table_content"><%=rs3.getString("rd")%></td>
							</tr>
							<tr>
								<th>Status: </th>
								<td class="table_content">
									<%
										if(rs3.getInt("status") == 1)
											out.print("User");
										else if(rs3.getInt("status") == 2)
											out.print("Admin");
										else
											out.print("Forbidden");
									%>
								</td>
							</tr>
						</table>
						<div style="text-align: center; padding: 5px;">
							<button><a href="PCServlet?action=2&uid=<%=rs3.getString("user_id")%>">Promote</a></button>
							<button><a href="PCServlet?action=1&uid=<%=rs3.getString("user_id")%>">Degrade</a></button>
							<button><a href="PCServlet?action=3&uid=<%=rs3.getString("user_id")%>">Forbidden</a></button>
						</div>
					</div>
					<%
						}
					%>
				</td>
			</tr>
		</table>
	</div>

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