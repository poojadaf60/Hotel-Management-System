<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.org.Booking"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
if (bookings == null) bookings = new java.util.ArrayList<>();
Double totalRevenueObj = (Double) request.getAttribute("totalRevenue");
double totalRevenue = (totalRevenueObj != null) ? totalRevenueObj : 0.0;
Integer totalBookingsObj = (Integer) request.getAttribute("totalBookings");
int totalBookings = (totalBookingsObj != null) ? totalBookingsObj : 0;
Integer totalCustomersObj = (Integer) request.getAttribute("totalCustomers");
int totalCustomers = (totalCustomersObj != null) ? totalCustomersObj : 0;
Integer totalRoomsObj = (Integer) request.getAttribute("totalRooms");
int totalRooms = (totalRoomsObj != null) ? totalRoomsObj : 0;
Integer availableRoomsObj = (Integer) request.getAttribute("availableRooms");
int availableRooms = (availableRoomsObj != null) ? availableRoomsObj : 0;
Integer bookedRoomsObj = (Integer) request.getAttribute("bookedRooms");
int bookedRooms = (bookedRoomsObj != null) ? bookedRoomsObj : 0;
String fromDate = (String) request.getAttribute("fromDate");
if (fromDate == null) fromDate = "";
String toDate = (String) request.getAttribute("toDate");
if (toDate == null) toDate = "";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reports – Royal Palace Hotel</title>
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
.content { padding:30px; }
.filter-box { background:white; padding:25px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,0.08); margin-bottom:30px; }
.filter-box form { display:flex; flex-wrap:wrap; gap:20px; align-items:flex-end; width:100%; }
.filter-group { display:flex; flex-direction:column; gap:5px; flex:1; min-width:150px; }
.filter-group label { font-weight:600; color:#555; font-size:14px; }
.filter-group input { padding:10px 14px; border:1px solid #ddd; border-radius:8px; font-size:15px; outline:none; }
.filter-group input:focus { border-color:#E3123D; }
.btn-filter { background:#E3123D; color:white; border:none; padding:10px 30px; border-radius:8px; font-size:15px; cursor:pointer; font-weight:600; transition:0.3s; }
.btn-filter:hover { background:#c50d34; }
.stats { display:grid; grid-template-columns:repeat(auto-fit,minmax(150px,1fr)); gap:20px; margin-bottom:30px; }
.stat-card { background:white; padding:20px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,0.08); text-align:center; }
.stat-card h3 { font-size:32px; color:#273340; }
.stat-card p { color:#777; font-size:14px; margin-top:5px; }
.table-container { background:white; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,0.08); padding:20px; }
.table-container h3 { color:#273340; margin-bottom:15px; }
.table-wrapper { overflow-x:auto; -webkit-overflow-scrolling:touch; }
table { width:100%; background:white; border-collapse:collapse; border-radius:12px; overflow:hidden; box-shadow:0 5px 15px rgba(0,0,0,0.08); min-width:600px; }
th { background:#34495e; color:white; padding:12px; text-align:left; }
td { padding:12px; border-bottom:1px solid #eee; }
tr:hover { background:#f8f9fb; }
.status-badge { padding:4px 12px; border-radius:20px; font-size:13px; font-weight:600; display:inline-block; }
.status-badge.confirmed { background:#d4edda; color:#155724; }
.status-badge.pending { background:#fff3cd; color:#856404; }
.status-badge.cancelled { background:#f8d7da; color:#721c24; }
.status-badge.checked-in { background:#cce5ff; color:#004085; }
.status-badge.checked-out { background:#e2e3e5; color:#383d41; }
.empty { text-align:center; padding:30px; color:#999; }
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:998; cursor:pointer; }
@media(max-width:768px){
.sidebar{ transform:translateX(-100%); width:280px; }
.main{ margin-left:0; }
.navbar .hamburger{ display:block; }
.navbar{ padding:0 15px; height:60px; flex-wrap:wrap; }
.content{ padding:15px; }
.filter-box form{ flex-direction:column; align-items:stretch; }
.filter-group{ min-width:100%; }
#sidebar-toggle:checked ~ .sidebar{ transform:translateX(0); }
#sidebar-toggle:checked ~ .sidebar-overlay{ display:block; }
}
@media(max-width:480px){
.sidebar{ width:100%; }
.navbar{ flex-direction:column; height:auto; padding:15px; gap:10px; }
.stats{ grid-template-columns:1fr; }
table{ min-width:400px; font-size:13px; }
th, td{ padding:8px 6px; }
.navbar h2{ font-size:18px !important; }
}
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
<a class="active" href="ReportServlet">📊 Reports</a>
<a href="PaymentManagementServlet">💳 Payments</a>
<a href="LogoutServlet">🚪 Logout</a>
</div>
<label for="sidebar-toggle" class="sidebar-overlay"></label>
<div class="main">
<div class="navbar">
<div style="display:flex;align-items:center;gap:15px;">
<label for="sidebar-toggle" class="hamburger">☰</label>
<h2 style="margin:0;font-size:20px;color:#273340;"><i class="fa-solid fa-chart-bar"></i> Reports</h2>
</div>
<div><i class="fa-regular fa-user"></i> Welcome, <b><%= session.getAttribute("username") %></b></div>
</div>
<div class="content">
<div class="filter-box">
<form action="ReportServlet" method="get">
<div class="filter-group"><label><i class="fa-regular fa-calendar"></i> From Date</label><input type="date" name="fromDate" value="<%= fromDate %>"></div>
<div class="filter-group"><label><i class="fa-regular fa-calendar"></i> To Date</label><input type="date" name="toDate" value="<%= toDate %>"></div>
<button type="submit" class="btn-filter"><i class="fa-solid fa-filter"></i> Generate Report</button>
</form>
</div>
<div class="stats">
<div class="stat-card"><h3>₹ <%= String.format("%.2f", totalRevenue) %></h3><p>Total Revenue</p></div>
<div class="stat-card"><h3><%= totalBookings %></h3><p>Total Bookings</p></div>
<div class="stat-card"><h3><%= totalCustomers %></h3><p>Total Customers</p></div>
<div class="stat-card"><h3><%= totalRooms %></h3><p>Total Rooms</p></div>
<div class="stat-card"><h3><%= availableRooms %></h3><p>Available Rooms</p></div>
<div class="stat-card"><h3><%= bookedRooms %></h3><p>Booked Rooms</p></div>
</div>
<div class="table-container">
<h3>Bookings (<%= fromDate %> to <%= toDate %>)</h3>
<div class="table-wrapper">
<table>
<thead><tr><th>Booking ID</th><th>Customer ID</th><th>Room ID</th><th>Check In</th><th>Check Out</th><th>Amount</th><th>Status</th></tr></thead>
<tbody>
<%
if (bookings.isEmpty()) { %><tr><td colspan="7" class="empty">No bookings found in this date range.</td></tr><%
} else {
for (Booking b : bookings) {
String badgeClass = "";
String status = b.getStatus();
if ("Confirmed".equalsIgnoreCase(status)) badgeClass = "confirmed";
else if ("Pending".equalsIgnoreCase(status)) badgeClass = "pending";
else if ("Cancelled".equalsIgnoreCase(status)) badgeClass = "cancelled";
else if ("Checked-In".equalsIgnoreCase(status)) badgeClass = "checked-in";
else if ("Checked-Out".equalsIgnoreCase(status)) badgeClass = "checked-out";
%>
<tr>
<td><%= b.getBookingId() %></td>
<td><%= b.getCustomerId() %></td>
<td><%= b.getRoomId() %></td>
<td><%= b.getCheckIn() %></td>
<td><%= b.getCheckOut() %></td>
<td>₹ <%= String.format("%.2f", b.getTotalAmount()) %></td>
<td><span class="status-badge <%= badgeClass %>"><%= status %></span></td>
</tr>
<%
}
}
%>
</tbody>
</table>
</div>
</div>
</div>
</div>
</body>
</html>