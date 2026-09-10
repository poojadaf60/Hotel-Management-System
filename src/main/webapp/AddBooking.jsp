<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.org.Customer, com.org.Room" %>

<%
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    if (customers == null) customers = new ArrayList<>();
    if (rooms == null) rooms = new ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Booking</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

<style>

* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
html, body { 
    height:100%; 
    background:#eef2f7; 
    overflow-x:hidden; 
    -webkit-overflow-scrolling:touch;
}


.sidebar {
    position:fixed; 
    left:0; 
    top:0; 
    width:250px; 
    height:100%; 
    background:#273340; 
    overflow-y:auto; 
    z-index:1000; 
    transition:transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    -webkit-overflow-scrolling:touch;
    will-change:transform;
}
.logo {
    padding:25px; 
    font-size:28px; 
    font-weight:bold; 
    text-align:center;
    color:#E3123D; 
    border-bottom:1px solid rgba(255,255,255,0.1);
}
.logo span { color:white; }
.sidebar a {
    display:block; 
    padding:16px 25px; 
    text-decoration:none;
    color:white; 
    transition:0.2s;
}
.sidebar a:hover, .sidebar .active { background:#E3123D; }


.main {
    margin-left:250px;
    min-height:100vh;
    display:flex;
    flex-direction:column;
    transition:margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}


.navbar {
    height:70px; 
    background:white; 
    display:flex; 
    justify-content:space-between;
    align-items:center; 
    padding:0 30px; 
    box-shadow:0 2px 10px rgba(0,0,0,0.08);
    position:sticky; 
    top:0; 
    z-index:999; 
    flex-shrink:0;
}
.navbar .hamburger { 
    display:none; 
    cursor:pointer; 
    font-size:28px; 
    color:#273340;
    background:none; 
    border:none;
    padding:5px;
    line-height:1;
}


.content {
    padding:30px;
    flex:1;
    overflow-y:auto;
    -webkit-overflow-scrolling:touch;
    display:flex;
    flex-direction:column;
    align-items:center;
}


.container {
    width:100%;
    max-width:700px;
    background:#fff;
    padding:35px;
    border-radius:15px;
    box-shadow:0 8px 20px rgba(0,0,0,0.12);
}

h2 {
    text-align:center;
    margin-bottom:25px;
    color:#2c3e50;
}

.error-box {
    background:#f8d7da;
    color:#721c24;
    padding:12px 18px;
    border-radius:8px;
    margin-bottom:20px;
    border-left:6px solid #dc3545;
    font-weight:500;
}

.form-group {
    margin-bottom:18px;
}

label {
    display:block;
    margin-bottom:8px;
    font-weight:600;
    color:#555;
}

input, select {
    width:100%;
    padding:12px;
    border:1px solid #ddd;
    border-radius:8px;
    font-size:15px;
    outline:none;
    transition:0.3s;
}
input:focus, select:focus {
    border-color:#3498db;
    box-shadow:0 0 8px rgba(52,152,219,0.1);
}

.buttons {
    margin-top:25px;
    display:flex;
    justify-content:space-between;
    gap:15px;
    flex-wrap:wrap;
}

.btn-save {
    background:#28a745;
    color:white;
    border:none;
    padding:12px 25px;
    border-radius:8px;
    cursor:pointer;
    font-size:15px;
    transition:0.3s;
}
.btn-save:hover { background:#218838; }

.btn-cancel {
    background:#dc3545;
    color:white;
    padding:12px 25px;
    border-radius:8px;
    text-decoration:none;
    transition:0.3s;
}
.btn-cancel:hover { background:#c82333; }


.footer {
    margin-top:30px;
    padding:15px 20px;
    background:#36454F;
    color:white;
    text-align:center;
    border-radius:10px;
    font-size:14px;
    flex-shrink:0;
    width:100%;
    max-width:700px;
}


#sidebar-toggle { 
    display:none; 
    position:absolute; 
    opacity:0; 
    width:0; 
    height:0;
}
.sidebar-overlay {
    display:none; 
    position:fixed; 
    top:0; 
    left:0;
    width:100%; 
    height:100%; 
    background:rgba(0,0,0,0.4);
    z-index:998; 
    cursor:pointer;
    transition:opacity 0.3s ease;
}


@media (max-width: 768px) {
    .sidebar {
        transform: translateX(-100%);
        width: 280px;
    }
    .main { margin-left:0; }

    .navbar .hamburger { display:block; }
    .navbar { padding:0 15px; height:60px; flex-wrap:wrap; }
    .navbar h2 { font-size:18px !important; }

    .content { padding:15px; }

    .container { padding:20px; }

    .buttons { flex-direction:column; }
    .buttons .btn-save, .buttons .btn-cancel { 
        width:100%; 
        text-align:center; 
        justify-content:center;
    }

    #sidebar-toggle:checked ~ .sidebar { transform:translateX(0); }
    #sidebar-toggle:checked ~ .sidebar-overlay { display:block; }
}

@media (max-width: 480px) {
    .sidebar { width:100%; }

    .navbar {
        flex-direction:column; 
        height:auto; 
        padding:15px; 
        gap:10px;
    }

    .container { padding:15px; }
    h2 { font-size:22px; margin-bottom:20px; }

    input, select { padding:10px; font-size:13px; }

    .btn-save, .btn-cancel { 
        padding:12px; 
        font-size:14px; 
    }

    .footer { font-size:11px; padding:12px; }
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
    <a class="active" href="BookingManagementServlet">📅 Bookings</a>
    <a href="PaymentManagementServlet">💳 Payments</a>
    <a href="LogoutServlet">🚪 Logout</a>
</div>


<label for="sidebar-toggle" class="sidebar-overlay"></label>


<div class="main">


    <div class="navbar">
        <div style="display:flex;align-items:center;gap:15px;">
            <label for="sidebar-toggle" class="hamburger" aria-label="Toggle menu">☰</label>
            <h2 style="margin:0;font-size:20px;color:#273340;"><i class="fa-regular fa-calendar-check"></i> Add Booking</h2>
        </div>
        <div>Welcome, <b><%= session.getAttribute("username") %></b></div>
    </div>


    <div class="content">

        <div class="container">
            <h2><i class="fa-solid fa-calendar-plus"></i> Add New Booking</h2>

            <%
                String errorMsg = (String) request.getAttribute("errorMessage");
                if (errorMsg != null) {
            %>
                <div class="error-box"><i class="fa-solid fa-exclamation-circle"></i> <%= errorMsg %></div>
            <% } %>

            <form action="BookingServlet" method="post">

                <div class="form-group">
                    <label><i class="fa-regular fa-user"></i> Customer</label>
                    <select name="customerId" required>
                        <option value="">-- Select Customer --</option>
                        <%
                            for (Customer c : customers) {
                        %>
                            <option value="<%= c.getCustomerId() %>"><%= c.getName() %></option>
                        <%
                            }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label><i class="fa-regular fa-bed"></i> Room</label>
                    <select name="roomId" required>
                        <option value="">-- Select Room --</option>
                        <%
                            for (Room r : rooms) {
                                String display = r.getRoomNo() + " (" + r.getRoomType() + ") - " + r.getStatus();
                        %>
                            <option value="<%= r.getRoomId() %>"><%= display %></option>
                        <%
                            }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label><i class="fa-regular fa-calendar"></i> Check In Date</label>
                    <input type="date" name="checkIn" required>
                </div>

                <div class="form-group">
                    <label><i class="fa-regular fa-calendar"></i> Check Out Date</label>
                    <input type="date" name="checkOut" required>
                </div>

                <div class="form-group">
                    <label><i class="fa-regular fa-money-bill-1"></i> Total Amount (₹)</label>
                    <input type="number" step="0.01" name="totalAmount" placeholder="Enter total amount" required>
                </div>

                <div class="form-group">
                    <label><i class="fa-regular fa-circle-check"></i> Status</label>
                    <select name="status" required>
                        <option value="">Select Status</option>
                        <option value="Confirmed">Confirmed</option>
                        <option value="Pending">Pending</option>
                        <option value="Cancelled">Cancelled</option>
                    </select>
                </div>

                <div class="buttons">
                    <button class="btn-save" type="submit"><i class="fa-solid fa-floppy-disk"></i> Save Booking</button>
                    <a href="BookingManagementServlet" class="btn-cancel"><i class="fa-solid fa-xmark"></i> Cancel</a>
                </div>

            </form>
        </div>


        <div class="footer">
            <p>© 2026 Royal Palace Hotel Management System</p>
        </div>

    </div>
</div>

</body>
</html>