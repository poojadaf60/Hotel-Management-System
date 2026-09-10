<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, com.org.Payment" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("Loginindex.jsp");
        return;
    }
    ArrayList<Payment> payments = (ArrayList<Payment>) request.getAttribute("payments");
    if (payments == null) payments = new ArrayList<>();
    Double totalPaid = (Double) request.getAttribute("totalPaid");
    if (totalPaid == null) totalPaid = 0.0;
    Integer bookingId = (Integer) request.getAttribute("bookingId");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payments – Booking #<%= bookingId %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
        body { background:#eef2f7; display:flex; justify-content:center; align-items:center; min-height:100vh; padding:20px; }
        .container { max-width:900px; width:100%; background:white; padding:30px; border-radius:15px; box-shadow:0 8px 20px rgba(0,0,0,0.12); }
        .header { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; flex-wrap:wrap; gap:15px; }
        .header h2 { color:#273340; }
        .header a { background:#34495e; color:white; padding:10px 20px; border-radius:8px; text-decoration:none; transition:0.3s; }
        .header a:hover { background:#2c3e50; }
        .total-box { background:#d4edda; padding:15px; border-radius:10px; margin-bottom:20px; border-left:6px solid #28a745; }
        .total-box strong { font-size:20px; color:#155724; }
        .no-data { text-align:center; padding:40px; color:#999; font-size:16px; }
        .table-wrapper { overflow-x:auto; }
        table { width:100%; border-collapse:collapse; }
        th { background:#273340; color:white; padding:12px; text-align:left; }
        td { padding:12px; border-bottom:1px solid #eee; }
        tr:hover { background:#f8f9fb; }
        .status-paid { color:#28a745; font-weight:bold; }
        .status-pending { color:#f39c12; font-weight:bold; }
        .status-failed { color:#dc3545; font-weight:bold; }
        @media(max-width:480px) { .container { padding:15px; } th, td { padding:8px; font-size:14px; } }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2><i class="fa-regular fa-credit-card"></i> Payments – Booking #<%= bookingId %></h2>
        <a href="BookingManagementServlet"><i class="fa-solid fa-arrow-left"></i> Back to Bookings</a>
    </div>

    <div class="total-box">
        <i class="fa-solid fa-circle-check"></i> <strong>Total Paid: ₹ <%= String.format("%.2f", totalPaid) %></strong>
    </div>

    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>Payment ID</th>
                    <th>Amount</th>
                    <th>Method</th>
                    <th>Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
            <%
                if (!payments.isEmpty()) {
                    for (Payment p : payments) {
                        String statusClass = "";
                        if ("Paid".equalsIgnoreCase(p.getStatus())) statusClass = "status-paid";
                        else if ("Pending".equalsIgnoreCase(p.getStatus())) statusClass = "status-pending";
                        else if ("Failed".equalsIgnoreCase(p.getStatus())) statusClass = "status-failed";
            %>
                <tr>
                    <td>#<%= p.getPaymentId() %></td>
                    <td>₹ <%= String.format("%.2f", p.getAmount()) %></td>
                    <td><%= p.getPaymentMethod() %></td>
                    <td><%= p.getPaymentDate() %></td>
                    <td class="<%= statusClass %>"><%= p.getStatus() %></td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr><td colspan="5" class="no-data"><i class="fa-regular fa-circle-info"></i> No payments found for this booking.</td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>