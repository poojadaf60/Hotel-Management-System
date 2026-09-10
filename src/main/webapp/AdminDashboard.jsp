<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if(session.getAttribute("username")==null){ 
    response.sendRedirect("Loginindex.jsp"); 
    return; 
}


String profilePic = (String) session.getAttribute("profilePic");
String username = (String) session.getAttribute("username");

if (profilePic == null || profilePic.isEmpty()) {

    profilePic = "https://ui-avatars.com/api/?name=" + username + "&background=E3123D&color=fff&size=100";
} else {

    if (!profilePic.startsWith("http") && !profilePic.startsWith("uploads/")) {
        profilePic = request.getContextPath() + "/" + profilePic;
    } else if (profilePic.startsWith("uploads/")) {
        profilePic = request.getContextPath() + "/" + profilePic;
    }
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hotel Management System | Admin Dashboard</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; }
.sidebar { position:fixed; left:0; top:0; width:260px; height:100%; background:linear-gradient(180deg,#36454F,#1F2B33); overflow:auto; z-index:1000; transition:transform 0.3s ease; }
.logo { padding:25px; text-align:center; font-size:28px; font-weight:bold; color:#DC143C; border-bottom:1px solid rgba(255,255,255,.15); }
.logo span { color:#fff; }
.sidebar a { display:block; padding:16px 25px; text-decoration:none; color:white; font-size:15px; transition:.3s; }
.sidebar a:hover, .sidebar .active { background:#DC143C; padding-left:35px; }
.main { margin-left:260px; min-height:100vh; }
.navbar { height:75px; background:white; display:flex; justify-content:space-between; align-items:center; padding:0 30px; box-shadow:0 2px 15px rgba(0,0,0,.1); position:sticky; top:0; z-index:999; }
.navbar .hamburger { display:none; cursor:pointer; font-size:28px; color:#36454F; }
.navbar .search input { width:350px; padding:12px; border:1px solid #ccc; border-radius:30px; outline:none; }
.navbar .right { display:flex; align-items:center; gap:20px; }
.navbar .profile { display:flex; align-items:center; gap:10px; }
.navbar .profile img { width:45px; height:45px; border-radius:50%; object-fit:cover; border:2px solid #DC143C; }
.navbar .profile h4 { color:#36454F; }
.navbar .profile p { font-size:12px; color:gray; }
.navbar .icon { font-size:22px; cursor:pointer; }
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:998; cursor:pointer; }
.content { padding:30px; }
.content h1 { color:#36454F; margin-bottom:10px; }
.content p { color:#777; }
.cards { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:20px; margin-top:30px; }
.card { background:#fff; padding:25px; border-radius:15px; box-shadow:0 5px 15px rgba(0,0,0,.1); display:flex; justify-content:space-between; align-items:center; transition:.3s; }
.card:hover { transform:translateY(-5px); }
.card h2 { font-size:32px; color:#36454F; }
.card p { margin-top:8px; color:#777; }
.card .icon { font-size:45px; }
.blue { border-left:6px solid #3498db; }
.green { border-left:6px solid #2ecc71; }
.red { border-left:6px solid #e74c3c; }
.orange { border-left:6px solid #f39c12; }
.purple { border-left:6px solid #9b59b6; }
.teal { border-left:6px solid #1abc9c; }
.dark { border-left:6px solid #34495e; }
.footer { margin-top:40px; padding:20px; background:#36454F; color:white; text-align:center; border-radius:10px; font-size:14px; }
@media(max-width:992px){ .sidebar{ width:220px; } .main{ margin-left:220px; } .cards{ grid-template-columns:repeat(2,1fr); } .navbar .search input{ width:250px; } }
@media(max-width:768px){
.sidebar{ transform:translateX(-100%); width:280px; }
.main{ margin-left:0; }
.navbar .hamburger{ display:block; }
.navbar{ padding:0 15px; height:60px; flex-wrap:wrap; }
.navbar .search input{ width:150px; }
.navbar .right .icon{ font-size:20px; }
.content{ padding:15px; }
.cards{ grid-template-columns:1fr; }
#sidebar-toggle:checked ~ .sidebar{ transform:translateX(0); }
#sidebar-toggle:checked ~ .sidebar-overlay{ display:block; }
.footer{ font-size:12px; padding:15px; }
}
@media(max-width:480px){
.sidebar{ width:100%; }
.navbar .search input{ width:120px; font-size:13px; padding:8px; }
.navbar .profile p{ display:none; }
.navbar .profile h4{ font-size:14px; }
.cards{ grid-template-columns:1fr; }
.card h2{ font-size:24px; }
h1{ font-size:28px !important; } h2{ font-size:22px !important; } h3{ font-size:18px !important; }
.navbar h2{ font-size:18px !important; }
}
</style>
</head>
<body>
<input type="checkbox" id="sidebar-toggle">
<div class="sidebar">
<div class="logo">🏨 <span>Royal Palace</span></div>
<a class="active" href="DashboardServlet">🏠 Dashboard</a>
<a href="RoomManagementServlet">🛏 Room Management</a>
<a href="CustomerManagementServlet">👥 Customers</a>
<a href="BookingManagementServlet">📅 Booking</a>
<a href="CheckIn.jsp">✅ Check In</a>
<a href="CheckOut.jsp">🚪 Check Out</a>
<a href="PaymentManagementServlet">💳 Payments</a>
<a href="ReportServlet">📊 Reports</a>
<a href="Setting.jsp">⚙ Settings</a>
<a href="LogoutServlet">🚪 Logout</a>
</div>
<label for="sidebar-toggle" class="sidebar-overlay"></label>
<div class="main">
<div class="navbar">
<div style="display:flex;align-items:center;gap:15px;">
<label for="sidebar-toggle" class="hamburger">☰</label>
<h2 style="margin:0;font-size:20px;color:#36454F;">Dashboard</h2>
</div>
<div class="search"><input type="text" placeholder="Search Here..."></div>
<div class="right">
<div class="icon">🔔</div>
<div class="icon">📧</div>

<div class="profile">
    <img src="<%= profilePic %>" alt="Profile">
    <div>
        <h4><%= session.getAttribute("username") %></h4>
        <p>Administrator</p>
    </div>
</div>
</div>
</div>
<div class="content">
<h1>Welcome <%= session.getAttribute("username") %> 👋</h1>
<p>Manage your Hotel Management System from one dashboard.</p>
<div class="cards">
<div class="card blue"><div><h2>${totalRooms}</h2><p>Total Rooms</p></div><div class="icon">🛏️</div></div>
<div class="card green"><div><h2>${availableRooms}</h2><p>Available Rooms</p></div><div class="icon">✅</div></div>
<div class="card red"><div><h2>${bookedRooms}</h2><p>Booked Rooms</p></div><div class="icon">📅</div></div>
<div class="card orange"><div><h2>${maintenanceRooms}</h2><p>Maintenance</p></div><div class="icon">🔧</div></div>
<div class="card purple"><div><h2>${totalCustomers}</h2><p>Total Customers</p></div><div class="icon">👥</div></div>
<div class="card teal"><div><h2>${totalBookings}</h2><p>Total Bookings</p></div><div class="icon">🏨</div></div>
<div class="card dark"><div><h2>₹ ${totalRevenue}</h2><p>Total Revenue</p></div><div class="icon">💰</div></div>
</div>
<br><br>
<h2 style="color:#36454F;">Dashboard Overview</h2>
<p style="margin-bottom:20px;">Welcome to the Hotel Management Dashboard. Here you can monitor rooms, bookings, customers, and revenue in real time.</p>
<h2 style="margin-top:30px;color:#36454F;">Quick Actions</h2>
<div class="cards">
<div class="card blue">
<div><h3>Add Room</h3><p>Create New Room</p><br><a href="AddRoom.jsp" style="text-decoration:none;background:#3498db;color:white;padding:10px 20px;border-radius:5px;display:inline-block;">Open</a></div>
<div class="icon">🛏️</div>
</div>
<div class="card green">
<div><h3>New Booking</h3><p>Create Booking</p><br><a href="BookingServlet" style="text-decoration:none;background:#2ecc71;color:white;padding:10px 20px;border-radius:5px;display:inline-block;">Open</a></div>
<div class="icon">📅</div>
</div>
<div class="card purple">
<div><h3>Customers</h3><p>Manage Customers</p><br><a href="CustomerManagementServlet" style="text-decoration:none;background:#9b59b6;color:white;padding:10px 20px;border-radius:5px;display:inline-block;">Open</a></div>
<div class="icon">👥</div>
</div>
</div>
<br><br>
<div class="footer"><p>© 2026 Royal Palace Hotel Management System</p></div>
</div>
</div>
</body>
</html>