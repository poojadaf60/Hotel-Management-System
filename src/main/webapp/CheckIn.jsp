<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Check-In</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; }
.sidebar { position:fixed; left:0; top:0; width:250px; height:100%; background:#273340; overflow-y:auto; z-index:1000; transition:transform 0.3s ease; }
.logo { padding:25px; font-size:28px; font-weight:bold; text-align:center; color:#E3123D; border-bottom:1px solid rgba(255,255,255,0.1); }
.logo span { color:white; }
.sidebar a { display:block; padding:16px 25px; text-decoration:none; color:white; transition:0.3s; font-weight:500; }
.sidebar a:hover, .sidebar .active { background:#E3123D; }
.main { margin-left:250px; min-height:100vh; }
.navbar { height:70px; background:white; display:flex; justify-content:space-between; align-items:center; padding:0 30px; box-shadow:0 2px 10px rgba(0,0,0,0.08); position:sticky; top:0; z-index:999; }
.navbar .hamburger { display:none; cursor:pointer; font-size:28px; color:#273340; }
.content { padding:30px; max-width:700px; margin:auto; }
.card { background:white; padding:35px; border-radius:15px; box-shadow:0 8px 20px rgba(0,0,0,0.12); border-top:6px solid #2ecc71; }
.card h2 { color:#273340; margin-bottom:25px; text-align:center; }
.form-group { margin-bottom:20px; }
label { display:block; margin-bottom:8px; font-weight:600; color:#444; }
input { width:100%; padding:14px; border:1px solid #ddd; border-radius:8px; font-size:16px; outline:none; transition:0.3s; }
input:focus { border-color:#2ecc71; box-shadow:0 0 8px rgba(46,204,113,0.2); }
.btn-checkin { width:100%; padding:14px; background:#2ecc71; color:white; border:none; border-radius:8px; font-size:17px; font-weight:600; cursor:pointer; transition:0.3s; display:flex; align-items:center; justify-content:center; gap:10px; }
.btn-checkin:hover { background:#27ae60; }
.error { background:#f8d7da; color:#721c24; padding:12px 18px; border-radius:8px; margin-bottom:20px; border-left:6px solid #dc3545; }
.info { background:#d1ecf1; color:#0c5460; padding:12px 18px; border-radius:8px; margin-bottom:20px; border-left:6px solid #17a2b8; }
.back-link { display:inline-block; margin-top:15px; color:#17a2b8; text-decoration:none; }
.back-link:hover { text-decoration:underline; }
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:998; cursor:pointer; }
@media(max-width:768px){
.sidebar { transform:translateX(-100%); width:280px; }
.main { margin-left:0; }
.navbar .hamburger { display:block; }
.navbar { padding:0 15px; height:60px; flex-wrap:wrap; }
.content { padding:15px; }
.card { padding:20px; }
#sidebar-toggle:checked ~ .sidebar { transform:translateX(0); }
#sidebar-toggle:checked ~ .sidebar-overlay { display:block; }
}
@media(max-width:480px){ .sidebar { width:100%; } .navbar { flex-direction:column; height:auto; padding:15px; gap:10px; } .navbar h2 { font-size:18px !important; } }
</style>
</head>
<body>
<input type="checkbox" id="sidebar-toggle">
<div class="sidebar">
<div class="logo">🏨 <span>Royal Palace</span></div>
<a href="DashboardServlet">🏠 Dashboard</a>
<a href="RoomManagementServlet">🛏 Room Management</a>
<a href="CustomerManagementServlet">👥 Customers</a>
<a href="BookingManagementServlet">📅 Bookings</a>
<a class="active" href="CheckInServlet">✅ Check In</a>
<a href="CheckOut.jsp">🚪 Check Out</a>
<a href="PaymentManagementServlet">💳 Payments</a>
<a href="LogoutServlet">🚪 Logout</a>
</div>
<label for="sidebar-toggle" class="sidebar-overlay"></label>
<div class="main">
<div class="navbar">
<div style="display:flex;align-items:center;gap:15px;">
<label for="sidebar-toggle" class="hamburger">☰</label>
<h2 style="margin:0;font-size:20px;color:#273340;"><i class="fa-solid fa-check-circle"></i> Check-In</h2>
</div>
<div><i class="fa-regular fa-user"></i> Welcome, <b><%= session.getAttribute("username") %></b></div>
</div>
<div class="content">
<div class="card">
<h2><i class="fa-solid fa-key"></i> Guest Check-In</h2>
<%
String error = (String) request.getAttribute("error");
if (error != null) { %><div class="error"><i class="fa-solid fa-exclamation-circle"></i> <%= error %></div><% }
String info = (String) request.getAttribute("info");
if (info != null) { %><div class="info"><i class="fa-solid fa-info-circle"></i> <%= info %></div><% }
%>
<form action="CheckInServlet" method="post">
<div class="form-group"><label for="bookingId">Enter Booking ID</label><input type="number" id="bookingId" name="bookingId" placeholder="e.g., 101" required></div>
<button type="submit" class="btn-checkin"><i class="fa-solid fa-check"></i> Check In</button>
</form>
<a href="DashboardServlet" class="back-link"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</div>
</div>
</div>
</body>
</html>