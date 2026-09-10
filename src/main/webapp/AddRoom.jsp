<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
if (session.getAttribute("username") == null) {
    response.sendRedirect("Loginindex.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Room</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

<style>
/* (Your existing CSS – keep unchanged) */
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
html, body { height:100%; background:#eef2f7; overflow-x:hidden; }
.sidebar { position:fixed; left:0; top:0; width:250px; height:100%; background:#273340; overflow-y:auto; z-index:1000; transition:transform 0.3s ease; }
.logo { padding:25px; font-size:28px; font-weight:bold; text-align:center; color:#E3123D; border-bottom:1px solid rgba(255,255,255,0.1); }
.logo span { color:white; }
.sidebar a { display:block; padding:16px 25px; text-decoration:none; color:white; transition:0.2s; }
.sidebar a:hover, .sidebar .active { background:#E3123D; }
.main { margin-left:250px; min-height:100vh; display:flex; flex-direction:column; }
.navbar { height:70px; background:white; display:flex; justify-content:space-between; align-items:center; padding:0 30px; box-shadow:0 2px 10px rgba(0,0,0,0.08); position:sticky; top:0; z-index:999; flex-shrink:0; }
.navbar .hamburger { display:none; cursor:pointer; font-size:28px; color:#273340; background:none; border:none; padding:5px; line-height:1; }
.content { padding:30px; flex:1; overflow-y:auto; display:flex; flex-direction:column; align-items:center; justify-content:center; }
.form-box { width:100%; max-width:700px; background:#fff; padding:35px; border-radius:15px; box-shadow:0 8px 20px rgba(0,0,0,0.12); }
.form-box h2 { text-align:center; margin-bottom:25px; color:#273340; }
.row { display:flex; gap:20px; margin-bottom:20px; }
.col { flex:1; }
label { display:block; margin-bottom:8px; font-weight:600; color:#333; }
input, select { width:100%; padding:12px; border:1px solid #ddd; border-radius:8px; font-size:15px; outline:none; transition:0.3s; }
input:focus, select:focus { border-color:#E3123D; box-shadow:0 0 8px rgba(227,18,61,0.1); }
.btn-add { width:100%; padding:14px; background:#E3123D; color:#fff; font-size:17px; border:none; border-radius:8px; cursor:pointer; transition:0.3s; margin-top:10px; }
.btn-add:hover { background:#c20f33; }
.alert-success { background:#d4edda; color:#155724; padding:12px; border-radius:8px; margin-bottom:20px; text-align:center; border-left:6px solid #28a745; }
.alert-error { background:#f8d7da; color:#721c24; padding:12px; border-radius:8px; margin-bottom:20px; text-align:center; border-left:6px solid #dc3545; }
.alert-duplicate { background:#fff3cd; color:#856404; padding:12px; border-radius:8px; margin-bottom:20px; text-align:center; border-left:6px solid #ffc107; }
.footer { margin-top:30px; padding:15px 20px; background:#36454F; color:white; text-align:center; border-radius:10px; font-size:14px; flex-shrink:0; width:100%; max-width:700px; }
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.4); z-index:998; cursor:pointer; }
@media (max-width: 768px) {
    .sidebar { transform: translateX(-100%); width: 280px; }
    .main { margin-left:0; }
    .navbar .hamburger { display:block; }
    .navbar { padding:0 15px; height:60px; flex-wrap:wrap; }
    .content { padding:15px; }
    .form-box { padding:20px; }
    .row { flex-direction:column; gap:15px; }
    #sidebar-toggle:checked ~ .sidebar { transform:translateX(0); }
    #sidebar-toggle:checked ~ .sidebar-overlay { display:block; }
}
@media (max-width: 480px) {
    .sidebar { width:100%; }
    .navbar { flex-direction:column; height:auto; padding:15px; gap:10px; }
    .form-box { padding:15px; }
    .form-box h2 { font-size:22px; margin-bottom:20px; }
    input, select { padding:10px; font-size:13px; }
    .btn-add { padding:12px; font-size:15px; }
    .footer { font-size:11px; padding:12px; }
}
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
            <label for="sidebar-toggle" class="hamburger" aria-label="Toggle menu">☰</label>
            <h2 style="margin:0;font-size:20px;color:#273340;"><i class="fa-regular fa-bed"></i> Add Room</h2>
        </div>
        <div>Welcome, <b><%= session.getAttribute("username") %></b></div>
    </div>

    <div class="content">

        <div class="form-box">

            <h2>🛏️ Add New Room</h2>

            <!-- Display messages from the servlet -->
            <%
                String msg = request.getParameter("msg");
                if ("success".equals(msg)) {
            %>
                <div class="alert-success"><i class="fa-solid fa-check-circle"></i> Room Added Successfully.</div>
            <%
                } else if ("error".equals(msg)) {
            %>
                <div class="alert-error"><i class="fa-solid fa-exclamation-circle"></i> Unable to Add Room. Please check input and try again.</div>
            <%
                } else if ("duplicate".equals(msg)) {
            %>
                <div class="alert-duplicate"><i class="fa-solid fa-triangle-exclamation"></i> Room number already exists. Please use a unique number.</div>
            <%
                }
            %>

            <!-- ✅ Use absolute action path to avoid issues -->
            <form action="${pageContext.request.contextPath}/AddRoomServlet" method="post">

                <div class="row">
                    <div class="col">
                        <label><i class="fa-regular fa-hashtag"></i> Room Number</label>
                        <input type="text" name="room_no" placeholder="e.g., 101" required>
                    </div>
                    <div class="col">
                        <label><i class="fa-regular fa-layer-group"></i> Room Type</label>
                        <select name="room_type">
                            <option>Single</option>
                            <option>Double</option>
                            <option>Deluxe</option>
                            <option>Suite</option>
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="col">
                        <label><i class="fa-regular fa-stairs"></i> Floor</label>
                        <input type="number" name="floor" placeholder="e.g., 1" required>
                    </div>
                    <div class="col">
                        <label><i class="fa-regular fa-money-bill-1"></i> Price (₹)</label>
                        <input type="number" step="0.01" name="price" placeholder="e.g., 2500" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col">
                        <label><i class="fa-regular fa-circle-check"></i> Status</label>
                        <select name="status">
                            <option>Available</option>
                            <option>Booked</option>
                            <option>Maintenance</option>
                        </select>
                    </div>
                </div>

                <button class="btn-add" type="submit">
                    <i class="fa-solid fa-plus"></i> Add Room
                </button>

            </form>
        </div>

        <div class="footer">
            <p>© 2026 Royal Palace Hotel Management System</p>
        </div>

    </div>
</div>

</body>
</html>