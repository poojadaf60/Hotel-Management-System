<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, com.org.Payment"%>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("Loginindex.jsp");
        return;
    }
    ArrayList<Payment> payments = (ArrayList<Payment>) request.getAttribute("payments");
    if (payments == null) payments = new ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Payment Management</title>
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
}


.top {
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:20px;
    flex-wrap:wrap;
    gap:15px;
}
.top h2 { color:#273340; }

.btn-add {
    background:#E3123D;
    color:white;
    padding:12px 22px;
    border-radius:8px;
    text-decoration:none;
    font-weight:600;
    transition:0.3s;
    display:inline-flex;
    align-items:center;
    gap:10px;
}
.btn-add:hover { background:#c50d34; }


.alert-success {
    background:#d4edda;
    color:#155724;
    padding:12px 18px;
    border-radius:8px;
    border-left:6px solid #28a745;
    margin-bottom:20px;
}
.alert-error {
    background:#f8d7da;
    color:#721c24;
    padding:12px 18px;
    border-radius:8px;
    border-left:6px solid #dc3545;
    margin-bottom:20px;
}


.table-wrapper {
    overflow-x:auto;
    -webkit-overflow-scrolling:touch;
    flex:1;
}
table {
    width:100%;
    background:white;
    border-collapse:collapse;
    border-radius:12px;
    overflow:hidden;
    box-shadow:0 5px 15px rgba(0,0,0,0.08);
    min-width:600px;
}
th {
    background:#34495e;
    color:white;
    padding:15px;
    text-align:center;
}
td {
    padding:15px;
    text-align:center;
    border-bottom:1px solid #eee;
}
tr:hover { background:#f8f9fb; }


.status-paid { color:#28a745; font-weight:bold; }
.status-pending { color:#f39c12; font-weight:bold; }
.status-failed { color:#dc3545; font-weight:bold; }


.btn-edit {
    background:#17a2b8;
    color:white;
    padding:8px 14px;
    border-radius:6px;
    text-decoration:none;
    font-size:13px;
    display:inline-block;
    margin-right:5px;
}
.btn-edit:hover { background:#138496; }

.btn-delete {
    background:#dc3545;
    color:white;
    padding:8px 14px;
    border-radius:6px;
    text-decoration:none;
    font-size:13px;
    display:inline-block;
}
.btn-delete:hover { background:#c82333; }

.empty-row td {
    text-align:center;
    padding:40px;
    color:#999;
    font-style:italic;
}


.footer {
    margin-top:30px;
    padding:15px 20px;
    background:#36454F;
    color:white;
    text-align:center;
    border-radius:10px;
    font-size:14px;
    flex-shrink:0;
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


@media (max-width: 992px) {
    .table-wrapper table { min-width:500px; }
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

    .top { flex-direction:column; align-items:stretch; }
    .btn-add { justify-content:center; }

    .table-wrapper table { min-width:500px; font-size:14px; }
    th, td { padding:10px 8px; }

    .btn-edit, .btn-delete { font-size:12px; padding:6px 10px; }

    #sidebar-toggle:checked ~ .sidebar { transform:translateX(0); }
    #sidebar-toggle:checked ~ .sidebar-overlay { display:block; }

    .footer { font-size:12px; padding:12px; }
}

@media (max-width: 480px) {
    .sidebar { width:100%; }

    .navbar {
        flex-direction:column; 
        height:auto; 
        padding:15px; 
        gap:10px;
    }

    .table-wrapper table { min-width:400px; font-size:13px; }
    th, td { padding:8px 6px; }

    .btn-edit, .btn-delete { 
        font-size:11px; 
        padding:5px 8px; 
        margin:2px 0;
        display:inline-block;
    }

    .footer { font-size:11px; padding:10px; }
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
    <a class="active" href="PaymentManagementServlet">💳 Payments</a>
    <a href="LogoutServlet">🚪 Logout</a>
</div>


<label for="sidebar-toggle" class="sidebar-overlay"></label>

<div class="main">

  
    <div class="navbar">
        <div style="display:flex;align-items:center;gap:15px;">
            <label for="sidebar-toggle" class="hamburger" aria-label="Toggle menu">☰</label>
            <h2 style="margin:0;font-size:20px;color:#273340;">Payment Management</h2>
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
            <div class="alert-error"><i class="fa-solid fa-exclamation-circle"></i> Something went wrong.</div>
        <%
                }
            }
        %>

        <div class="top">
            <h2>All Payments</h2>
            <a href="AddPayment.jsp" class="btn-add"><i class="fa-solid fa-plus"></i> Add Payment</a>
        </div>


        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Booking ID</th>
                        <th>Amount</th>
                        <th>Method</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (payments != null && !payments.isEmpty()) {
                            for (Payment p : payments) {
                                String statusClass = "";
                                if ("Paid".equalsIgnoreCase(p.getStatus())) statusClass = "status-paid";
                                else if ("Pending".equalsIgnoreCase(p.getStatus())) statusClass = "status-pending";
                                else if ("Failed".equalsIgnoreCase(p.getStatus())) statusClass = "status-failed";
                    %>
                    <tr>
                        <td><%= p.getPaymentId() %></td>
                        <td><%= p.getBookingId() %></td>
                        <td>₹ <%= p.getAmount() %></td>
                        <td><%= p.getPaymentMethod() %></td>
                        <td><%= p.getPaymentDate() %></td>
                        <td class="<%= statusClass %>"><%= p.getStatus() %></td>
                        <td>
                            <a class="btn-edit" href="EditPaymentServlet?id=<%= p.getPaymentId() %>">
                                <i class="fa-solid fa-pen"></i> Edit
                            </a>
                            <a class="btn-delete" href="DeletePaymentServlet?id=<%= p.getPaymentId() %>"
                               onclick="return confirm('Are you sure you want to delete this payment?');">
                                <i class="fa-solid fa-trash"></i> Delete
                            </a>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr class="empty-row">
                        <td colspan="7">
                            <i class="fa-regular fa-credit-card" style="font-size:24px;display:block;margin-bottom:10px;color:#ccc;"></i>
                            No Payments Found
                            <br><small style="color:#bbb;">Click "Add Payment" to create your first payment.</small>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>


        <div class="footer">
            <p>© 2026 Royal Palace Hotel Management System | Developed using JSP, Servlet & MySQL</p>
        </div>

    </div>
</div>

</body>
</html>