<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.org.Room"%>

<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
List<Room> rooms = (List<Room>) request.getAttribute("rooms");
Integer availableRooms = (Integer) request.getAttribute("availableRooms");
Integer bookedRooms = (Integer) request.getAttribute("bookedRooms");
Integer maintenanceRooms = (Integer) request.getAttribute("maintenanceRooms");
if (availableRooms == null) availableRooms = 0;
if (bookedRooms == null) bookedRooms = 0;
if (maintenanceRooms == null) maintenanceRooms = 0;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Room Management</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
html, body { height:100%; background:#eef2f7; }

.sidebar {
    position:fixed; left:0; top:0; width:250px; height:100%;
    background:#273340; overflow-y:auto; z-index:1000;
    transition:transform 0.3s ease;
}
.logo {
    padding:25px; font-size:28px; font-weight:bold; text-align:center;
    color:#E3123D; border-bottom:1px solid rgba(255,255,255,0.1);
}
.logo span { color:white; }
.sidebar a {
    display:block; padding:16px 25px; text-decoration:none;
    color:white; transition:0.3s;
}
.sidebar a:hover, .sidebar .active { background:#E3123D; }

.main {
    margin-left:250px;
    min-height:100vh;  
    display:flex;
    flex-direction:column;
}

.navbar {
    height:70px; background:white; display:flex; justify-content:space-between;
    align-items:center; padding:0 30px; box-shadow:0 2px 10px rgba(0,0,0,0.08);
    position:sticky; top:0; z-index:999; flex-shrink:0; /* ✅ navbar compress nahi hogi */
}
.navbar .hamburger { display:none; cursor:pointer; font-size:28px; color:#273340; }

.content {
    padding:30px;
    flex:1; 
    overflow-y:auto; 
}

.top {
    display:flex; justify-content:space-between; align-items:center;
    margin-bottom:20px; flex-wrap:wrap; gap:15px;
}
.top h2 { color:#273340; }

.btn {
    background:#E3123D; color:white; padding:12px 22px;
    border-radius:8px; text-decoration:none; font-weight:600;
    transition:0.3s; display:inline-block;
}
.btn:hover { background:#c50d34; }

.cards {
    display:grid; grid-template-columns:repeat(4,1fr);
    gap:20px; margin-bottom:25px;
}
.card {
    background:white; padding:25px; border-radius:12px;
    box-shadow:0 5px 15px rgba(0,0,0,0.08);
}
.card h3 { font-size:32px; color:#273340; }
.card p { margin-top:8px; color:#777; }


.table-wrapper {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
    margin-bottom:30px; /* ✅ footer ke liye space */
}

table {
    width:100%; background:white; border-collapse:collapse;
    border-radius:12px; overflow:hidden;
    box-shadow:0 5px 15px rgba(0,0,0,0.08);
    min-width:600px;
}
th {
    background:#34495e; color:white; padding:15px; text-align:left;
}
td {
    padding:15px; text-align:center; border-bottom:1px solid #eee;
}
tr:hover { background:#f8f9fb; }

.available { color:#28a745; font-weight:bold; }
.booked { color:#dc3545; font-weight:bold; }
.maintenance { color:#f39c12; font-weight:bold; }

.edit {
    background:#17a2b8; color:white; padding:8px 14px;
    border-radius:6px; text-decoration:none; display:inline-block;
}
.edit:hover { background:#138496; }
.delete {
    background:#dc3545; color:white; padding:8px 14px;
    border-radius:6px; text-decoration:none; margin-left:5px; display:inline-block;
}
.delete:hover { background:#c82333; }

.alert-success {
    background:#d4edda; color:#155724; padding:12px;
    border-radius:8px; margin-bottom:20px;
}
.alert-error {
    background:#f8d7da; color:#721c24; padding:12px;
    border-radius:8px; margin-bottom:20px;
}


.footer {
    margin-top:20px;
    padding:15px 20px;
    background:#36454F;
    color:white;
    text-align:center;
    border-radius:10px;
    font-size:14px;
    flex-shrink:0;
}

#sidebar-toggle { display:none; }
.sidebar-overlay {
    display:none; position:fixed; top:0; left:0;
    width:100%; height:100%; background:rgba(0,0,0,0.5);
    z-index:998; cursor:pointer;
}

@media (max-width: 992px) {
    .cards { grid-template-columns:repeat(2,1fr); }
}

@media (max-width: 768px) {
    .sidebar {
        transform: translateX(-100%);
        width: 280px;
    }
    .main { margin-left:0; }

    .navbar .hamburger { display:block; }
    .navbar { padding:0 15px; height:60px; flex-wrap:wrap; }

    .content { padding:15px; }

    .cards { grid-template-columns:1fr 1fr; }

    .top { flex-direction:column; align-items:stretch; }
    .btn { text-align:center; }

    #sidebar-toggle:checked ~ .sidebar { transform:translateX(0); }
    #sidebar-toggle:checked ~ .sidebar-overlay { display:block; }

    table { min-width:500px; font-size:14px; }
    th, td { padding:10px 8px; }

    .footer { font-size:12px; padding:12px; }
}

@media (max-width: 480px) {
    .sidebar { width:100%; }

    .navbar {
        flex-direction:column; height:auto; padding:15px; gap:10px;
    }
    .navbar h2 { font-size:18px !important; }

    .cards { grid-template-columns:1fr; }

    .card { padding:18px; }
    .card h3 { font-size:26px; }

    table { min-width:400px; font-size:13px; }
    th, td { padding:8px 6px; }

    .edit, .delete { font-size:12px; padding:6px 10px; }

    .footer { font-size:11px; padding:10px; }
}
</style>
</head>

<body>

<input type="checkbox" id="sidebar-toggle">


<div class="sidebar">
    <div class="logo">🏨 <span>Royal Palace</span></div>
    <a href="DashboardServlet">🏠 Dashboard</a>
    <a class="active" href="RoomManagementServlet">🛏 Room Management</a>
    <a href="CustomerManagementServlet">👥 Customers</a>
    <a href="BookingManagementServlet">📅 Bookings</a>
    <a href="Payment.jsp">💳 Payments</a>
    <a href="LogoutServlet">🚪 Logout</a>
</div>

<label for="sidebar-toggle" class="sidebar-overlay"></label>


<div class="main">

    <div class="navbar">
        <div style="display:flex;align-items:center;gap:15px;">
            <label for="sidebar-toggle" class="hamburger">☰</label>
            <h2 style="margin:0;font-size:20px;color:#273340;">Room Management</h2>
        </div>
        <div>Welcome, <b><%= session.getAttribute("username") %></b></div>
    </div>

    <div class="content">

        <%
            String msg = request.getParameter("msg");
            if (msg != null) {
                if ("success".equals(msg) || "updated".equals(msg) || "deleted".equals(msg)) {
        %>
            <div class="alert-success"><i class="fa-solid fa-check-circle"></i> Operation successful!</div>
        <%
                } else if ("error".equals(msg)) {
        %>
            <div class="alert-error"><i class="fa-solid fa-exclamation-circle"></i> Something went wrong. Please try again.</div>
        <%
                }
            }
        %>

        <div class="top">
            <h2>All Rooms</h2>
            <a href="AddRoom.jsp" class="btn"><i class="fa-solid fa-plus"></i> Add Room</a>
        </div>

   
        <div class="cards">
            <div class="card">
                <h3><%= (rooms == null) ? 0 : rooms.size() %></h3>
                <p>Total Rooms</p>
            </div>
            <div class="card">
                <h3><%= availableRooms %></h3>
                <p>Available</p>
            </div>
            <div class="card">
                <h3><%= bookedRooms %></h3>
                <p>Booked</p>
            </div>
            <div class="card">
                <h3><%= maintenanceRooms %></h3>
                <p>Maintenance</p>
            </div>
        </div>

  
        <div class="table-wrapper">
            <table id="roomTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Room No</th>
                        <th>Type</th>
                        <th>Floor</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (rooms != null && !rooms.isEmpty()) {
                            for (Room r : rooms) {
                                String status = r.getStatus();
                                String cssClass = "";
                                if ("Available".equalsIgnoreCase(status)) cssClass = "available";
                                else if ("Booked".equalsIgnoreCase(status)) cssClass = "booked";
                                else if ("Maintenance".equalsIgnoreCase(status)) cssClass = "maintenance";
                    %>
                    <tr>
                        <td><%= r.getRoomId() %></td>
                        <td><%= r.getRoomNo() %></td>
                        <td><%= r.getRoomType() %></td>
                        <td><%= r.getFloor() %></td>
                        <td>₹ <%= r.getPrice() %></td>
                        <td><span class="<%= cssClass %>"><%= status %></span></td>
                        <td>
                            <a class="edit" href="EditRoomServlet?id=<%= r.getRoomId() %>">
                                <i class="fa-solid fa-pen"></i> Edit
                            </a>
                            <a class="delete" href="DeleteRoomServlet?id=<%= r.getRoomId() %>"
                               onclick="return confirm('Are you sure you want to delete this room?');">
                                <i class="fa-solid fa-trash"></i> Delete
                            </a>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="7" style="padding:30px;text-align:center;color:#999;font-size:16px;">
                            <i class="fa-solid fa-bed" style="font-size:24px;display:block;margin-bottom:10px;color:#ccc;"></i>
                            No Rooms Found
                            <br><small style="color:#bbb;">Click "Add Room" to create your first room.</small>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>


        <div class="footer">
            <p>© 2026 Royal Palace Hotel Management System</p>
        </div>

    </div>
</div>

</body>
</html>