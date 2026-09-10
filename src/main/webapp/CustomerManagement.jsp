<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, com.org.Customer"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
ArrayList<Customer> customers = (ArrayList<Customer>) request.getAttribute("customers");
Integer totalCustomers = (Integer) request.getAttribute("totalCustomers");
if (totalCustomers == null) totalCustomers = 0;
String errorMsg = (String) request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Management</title>
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
.top { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; flex-wrap:wrap; gap:15px; }
.top h2 { color:#273340; }
.btn-add { background:#E3123D; color:white; padding:12px 22px; border-radius:8px; text-decoration:none; font-weight:600; transition:0.3s; display:inline-flex; align-items:center; gap:10px; }
.btn-add:hover { background:#c50d34; }
.stats { display:grid; grid-template-columns:repeat(4,1fr); gap:20px; margin-bottom:25px; }
.stat-card { background:white; padding:25px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,0.08); display:flex; align-items:center; gap:20px; transition:0.3s; }
.stat-card:hover { transform:translateY(-5px); }
.stat-icon { width:55px; height:55px; border-radius:12px; display:flex; align-items:center; justify-content:center; font-size:26px; color:white; }
.stat-icon.blue { background:#3498db; }
.stat-icon.green { background:#2ecc71; }
.stat-icon.purple { background:#9b59b6; }
.stat-icon.orange { background:#f39c12; }
.stat-content h3 { font-size:32px; color:#273340; line-height:1.2; }
.stat-content p { color:#777; font-size:14px; }
.alert-success { background:#d4edda; color:#155724; padding:12px 18px; border-radius:8px; border-left:6px solid #28a745; margin-bottom:20px; }
.alert-error { background:#f8d7da; color:#721c24; padding:12px 18px; border-radius:8px; border-left:6px solid #dc3545; margin-bottom:20px; }
.table-wrapper { overflow-x:auto; -webkit-overflow-scrolling:touch; }
table { width:100%; background:white; border-collapse:collapse; border-radius:12px; overflow:hidden; box-shadow:0 5px 15px rgba(0,0,0,0.08); min-width:600px; }
th { background:#34495e; color:white; padding:15px; text-align:left; }
td { padding:15px; border-bottom:1px solid #eee; color:#333; }
tr:hover { background:#f8f9fb; }
.btn-edit { background:#17a2b8; color:white; padding:8px 14px; border-radius:6px; text-decoration:none; font-size:13px; display:inline-block; margin-right:5px; }
.btn-edit:hover { background:#138496; }
.btn-delete { background:#dc3545; color:white; padding:8px 14px; border-radius:6px; text-decoration:none; font-size:13px; display:inline-block; }
.btn-delete:hover { background:#c82333; }
.empty-row td { text-align:center; padding:40px; color:#999; font-style:italic; }
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:998; cursor:pointer; }
@media(max-width:992px){ .stats{ grid-template-columns:repeat(2,1fr); } }
@media(max-width:768px){
.sidebar{ transform:translateX(-100%); width:280px; }
.main{ margin-left:0; }
.navbar .hamburger{ display:block; }
.navbar{ padding:0 15px; height:60px; flex-wrap:wrap; }
.content{ padding:15px; }
.stats{ grid-template-columns:1fr 1fr; }
.top{ flex-direction:column; align-items:stretch; }
.btn-add{ justify-content:center; }
#sidebar-toggle:checked ~ .sidebar{ transform:translateX(0); }
#sidebar-toggle:checked ~ .sidebar-overlay{ display:block; }
}
@media(max-width:480px){
.sidebar{ width:100%; }
.navbar{ flex-direction:column; height:auto; padding:15px; gap:10px; }
.stats{ grid-template-columns:1fr; }
table{ min-width:400px; font-size:13px; }
th, td{ padding:10px 8px; }
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
<a class="active" href="CustomerManagementServlet">👥 Customers</a>
<a href="BookingManagementServlet">📅 Bookings</a>
<a href="PaymentManagementServlet">💳 Payments</a>
<a href="LogoutServlet">🚪 Logout</a>
</div>
<label for="sidebar-toggle" class="sidebar-overlay"></label>
<div class="main">
<div class="navbar">
<div style="display:flex;align-items:center;gap:15px;">
<label for="sidebar-toggle" class="hamburger">☰</label>
<h2 style="margin:0;font-size:20px;color:#273340;"><i class="fa-solid fa-users"></i> Customer Management</h2>
</div>
<div><i class="fa-regular fa-user"></i> Welcome, <b><%= session.getAttribute("username") %></b></div>
</div>
<div class="content">
<%
if (errorMsg != null) { %><div class="alert-error"><i class="fa-solid fa-exclamation-circle"></i> <%= errorMsg %></div><% }
String msg = request.getParameter("msg");
if (msg != null) {
if ("success".equals(msg) || "updated".equals(msg) || "deleted".equals(msg)) { %><div class="alert-success"><i class="fa-solid fa-check-circle"></i> Operation successful!</div><% }
else if ("error".equals(msg)) { %><div class="alert-error"><i class="fa-solid fa-exclamation-circle"></i> Something went wrong. Please try again.</div><% }
else if ("notfound".equals(msg)) { %><div class="alert-error"><i class="fa-solid fa-exclamation-circle"></i> Customer not found.</div><% }
}
%>
<div class="top"><h2>All Customers</h2><a href="AddCustomer.jsp" class="btn-add"><i class="fa-solid fa-user-plus"></i> Add Customer</a></div>
<div class="stats">
<div class="stat-card"><div class="stat-icon blue"><i class="fa-solid fa-users"></i></div><div class="stat-content"><h3><%= totalCustomers %></h3><p>Total Customers</p></div></div>
<div class="stat-card"><div class="stat-icon green"><i class="fa-solid fa-user-check"></i></div><div class="stat-content"><h3><%= (customers != null) ? customers.size() : 0 %></h3><p>Active</p></div></div>
<div class="stat-card"><div class="stat-icon purple"><i class="fa-solid fa-envelope"></i></div><div class="stat-content"><h3>✉️</h3><p>Email Records</p></div></div>
<div class="stat-card"><div class="stat-icon orange"><i class="fa-solid fa-phone"></i></div><div class="stat-content"><h3>📞</h3><p>Phone Contacts</p></div></div>
</div>
<div class="table-wrapper">
<table id="customerTable">
<thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Address</th><th style="text-align:center;">Action</th></tr></thead>
<tbody>
<%
if (customers != null && !customers.isEmpty()) {
for (Customer c : customers) {
%>
<tr>
<td><%= c.getCustomerId() %></td>
<td><%= c.getName() %></td>
<td><%= c.getEmail() %></td>
<td><%= c.getPhone() %></td>
<td><%= c.getAddress() %></td>
<td style="text-align:center;">
<a class="btn-edit" href="EditCustomerServlet?id=<%= c.getCustomerId() %>"><i class="fa-solid fa-pen"></i> Edit</a>
<a class="btn-delete" href="DeleteCustomerServlet?id=<%= c.getCustomerId() %>" onclick="return confirm('Are you sure you want to delete this customer?');"><i class="fa-solid fa-trash"></i> Delete</a>
</td>
</tr>
<%
}
} else { %><tr class="empty-row"><td colspan="6">No customers found</td></tr><% }
%>
</tbody>
</table>
</div>
</div>
</div>
</body>
</html>