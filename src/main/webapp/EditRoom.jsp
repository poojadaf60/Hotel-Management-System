<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if(session.getAttribute("username")==null){ response.sendRedirect("Loginindex.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Room</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; }
.sidebar { position:fixed; left:0; top:0; width:250px; height:100%; background:#273340; overflow-y:auto; z-index:1000; transition:transform 0.3s ease; }
.logo { padding:25px; font-size:26px; font-weight:bold; text-align:center; color:#E3123D; border-bottom:1px solid rgba(255,255,255,.1); }
.logo span { color:#fff; }
.sidebar a { display:block; padding:16px 25px; color:#fff; text-decoration:none; transition:.3s; }
.sidebar a:hover, .sidebar .active { background:#E3123D; }
.main { margin-left:250px; padding:30px; min-height:100vh; }
.navbar { background:#fff; padding:15px 25px; border-radius:10px; box-shadow:0 5px 15px rgba(0,0,0,.1); margin-bottom:30px; display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:10px; }
.navbar .hamburger { display:none; cursor:pointer; font-size:28px; color:#273340; }
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:998; cursor:pointer; }
.form-box { background:#fff; max-width:700px; margin:auto; padding:30px; border-radius:10px; box-shadow:0 5px 15px rgba(0,0,0,.1); }
.form-box h2 { text-align:center; margin-bottom:25px; color:#273340; }
.row { display:flex; gap:20px; margin-bottom:20px; }
.col { flex:1; }
label { display:block; margin-bottom:8px; font-weight:600; }
input, select { width:100%; padding:12px; border:1px solid #ccc; border-radius:8px; outline:none; }
input:focus, select:focus { border-color:#E3123D; }
.btn { width:100%; padding:14px; background:#E3123D; color:#fff; border:none; border-radius:8px; cursor:pointer; font-size:16px; margin-top:20px; }
.btn:hover { background:#c20f33; }
.back { display:block; text-align:center; margin-top:15px; text-decoration:none; font-weight:bold; color:#273340; }
@media(max-width:768px){
.sidebar { transform:translateX(-100%); width:280px; }
.main { margin-left:0; }
.navbar .hamburger { display:block; }
.navbar { padding:15px; }
.row { flex-direction:column; gap:15px; }
.form-box { padding:20px; }
#sidebar-toggle:checked ~ .sidebar { transform:translateX(0); }
#sidebar-toggle:checked ~ .sidebar-overlay { display:block; }
}
@media(max-width:480px){ .sidebar { width:100%; } .navbar h2 { font-size:18px; } .form-box { padding:15px; } }
</style>
</head>
<body>
<input type="checkbox" id="sidebar-toggle">
<div class="sidebar">
<div class="logo">🏨 <span>Royal Palace</span></div>
<a href="DashboardServlet">🏠 Dashboard</a>
<a class="active" href="RoomManagementServlet">🛏 Room Management</a>
<a href="LogoutServlet">🚪 Logout</a>
</div>
<label for="sidebar-toggle" class="sidebar-overlay"></label>
<div class="main">
<div class="navbar">
<div style="display:flex;align-items:center;gap:15px;">
<label for="sidebar-toggle" class="hamburger">☰</label>
<h2 style="margin:0;font-size:20px;color:#273340;">Edit Room</h2>
</div>
<div>Welcome, <b><%=session.getAttribute("username")%></b></div>
</div>
<div class="form-box">
<h2>Edit Room</h2>
<form action="EditRoomServlet" method="post">
<input type="hidden" name="id" value="<%=request.getAttribute("id")%>">
<div class="row">
<div class="col"><label>Room Number</label><input type="text" name="roomNo" value="<%=request.getAttribute("roomNo")%>" required></div>
<div class="col"><label>Room Type</label>
<% String roomType=(String)request.getAttribute("roomType"); %>
<select name="roomType">
<option value="Single" <%= "Single".equals(roomType)?"selected":"" %>>Single</option>
<option value="Double" <%= "Double".equals(roomType)?"selected":"" %>>Double</option>
<option value="Deluxe" <%= "Deluxe".equals(roomType)?"selected":"" %>>Deluxe</option>
<option value="Suite" <%= "Suite".equals(roomType)?"selected":"" %>>Suite</option>
</select>
</div>
</div>
<div class="row">
<div class="col"><label>Floor</label><input type="text" name="floor" value="<%=request.getAttribute("floor")%>" required></div>
<div class="col"><label>Price</label><input type="number" name="price" value="<%=request.getAttribute("price")%>" required></div>
</div>
<div class="row">
<div class="col"><label>Status</label>
<% String status=(String)request.getAttribute("status"); %>
<select name="status">
<option value="Available" <%= "Available".equals(status)?"selected":"" %>>Available</option>
<option value="Booked" <%= "Booked".equals(status)?"selected":"" %>>Booked</option>
<option value="Maintenance" <%= "Maintenance".equals(status)?"selected":"" %>>Maintenance</option>
</select>
</div>
</div>
<button class="btn" type="submit">Update Room</button>
</form>
<a class="back" href="RoomManagementServlet">← Back to Room Management</a>
</div>
</div>
</body>
</html>