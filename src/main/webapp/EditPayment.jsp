<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.org.Payment"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
Payment p = (Payment) request.getAttribute("payment");
if (p == null) { response.sendRedirect("PaymentManagementServlet"); return; }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Payment</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; display:flex; justify-content:center; align-items:center; min-height:100vh; padding:20px; }
.container { width:100%; max-width:700px; background:white; padding:35px; border-radius:15px; box-shadow:0 8px 20px rgba(0,0,0,0.12); }
h2 { text-align:center; margin-bottom:30px; color:#2c3e50; }
.form-group { margin-bottom:18px; }
label { display:block; margin-bottom:8px; font-weight:600; color:#444; }
input, select { width:100%; padding:12px; border:1px solid #ccc; border-radius:8px; outline:none; font-size:15px; }
input:focus, select:focus { border-color:#E3123D; }
.buttons { display:flex; justify-content:space-between; margin-top:25px; gap:15px; flex-wrap:wrap; }
.update { background:#17a2b8; color:white; border:none; padding:12px 25px; border-radius:8px; cursor:pointer; font-size:15px; }
.update:hover { background:#138496; }
.cancel { background:#dc3545; color:white; padding:12px 25px; border-radius:8px; text-decoration:none; }
.cancel:hover { background:#c82333; }
.error { background:#f8d7da; color:#721c24; padding:10px; border-radius:5px; margin-bottom:15px; text-align:center; }
@media(max-width:480px){ .container { padding:20px; } .buttons { flex-direction:column; } .buttons .update, .buttons .cancel { width:100%; text-align:center; } h2 { font-size:22px; } }
</style>
</head>
<body>
<div class="container">
<h2><i class="fa-solid fa-pen-to-square"></i> Edit Payment</h2>
<%
String err = request.getParameter("msg");
if ("error".equals(err)) { %><div class="error">Unable to update payment. Please try again.</div><% } %>
<form action="UpdatePaymentServlet" method="post">
<input type="hidden" name="paymentId" value="<%= p.getPaymentId() %>">
<div class="form-group"><label>Booking ID</label><input type="number" name="bookingId" value="<%= p.getBookingId() %>" required></div>
<div class="form-group"><label>Amount (₹)</label><input type="number" step="0.01" name="amount" value="<%= p.getAmount() %>" required></div>
<div class="form-group"><label>Payment Method</label><select name="paymentMethod">
<option value="Cash" <%= "Cash".equals(p.getPaymentMethod()) ? "selected" : "" %>>Cash</option>
<option value="Credit Card" <%= "Credit Card".equals(p.getPaymentMethod()) ? "selected" : "" %>>Credit Card</option>
<option value="Debit Card" <%= "Debit Card".equals(p.getPaymentMethod()) ? "selected" : "" %>>Debit Card</option>
<option value="Online" <%= "Online".equals(p.getPaymentMethod()) ? "selected" : "" %>>Online</option>
</select></div>
<div class="form-group"><label>Payment Date</label><input type="date" name="paymentDate" value="<%= p.getPaymentDate() %>" required></div>
<div class="form-group"><label>Status</label><select name="status">
<option value="Paid" <%= "Paid".equals(p.getStatus()) ? "selected" : "" %>>Paid</option>
<option value="Pending" <%= "Pending".equals(p.getStatus()) ? "selected" : "" %>>Pending</option>
<option value="Failed" <%= "Failed".equals(p.getStatus()) ? "selected" : "" %>>Failed</option>
</select></div>
<div class="buttons"><button class="update" type="submit"><i class="fa-solid fa-floppy-disk"></i> Update Payment</button><a href="PaymentManagementServlet" class="cancel">Cancel</a></div>
</form>
</div>
</body>
</html>