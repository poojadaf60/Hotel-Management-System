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
    <title>Check-Out Successful</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
        body { background:#eef2f7; display:flex; justify-content:center; align-items:center; min-height:100vh; }
        .container {
            background: white;
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.12);
            text-align: center;
            max-width: 500px;
            border-top: 8px solid #f39c12;
        }
        .icon {
            font-size: 72px;
            color: #f39c12;
            margin-bottom: 20px;
        }
        h2 {
            color: #273340;
            margin-bottom: 15px;
        }
        .details {
            text-align: left;
            margin: 25px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
        }
        .details p {
            margin: 8px 0;
        }
        .btn {
            display: inline-block;
            padding: 12px 25px;
            background: #f39c12;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: 0.3s;
        }
        .btn:hover {
            background: #e08e0b;
        }
        .btn-secondary {
            background: #17a2b8;
            margin-left: 10px;
        }
        .btn-secondary:hover {
            background: #138496;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon"><i class="fa-solid fa-check-circle"></i></div>
        <h2>✅ Check-Out Successful!</h2>
        <p style="color:#555;">Guest has been checked out. Room is now available.</p>

        <div class="details">
            <p><b>Booking ID:</b> <%= request.getAttribute("bookingId") %></p>
            <p><b>Customer ID:</b> <%= request.getAttribute("customerId") %></p>
            <p><b>Room ID:</b> <%= request.getAttribute("roomId") %></p>
            <p><b>Check-In Date:</b> <%= request.getAttribute("checkInDate") %></p>
            <p><b>Check-Out Date:</b> <%= request.getAttribute("checkOutDate") %></p>
        </div>

        <div>
            <a href="DashboardServlet" class="btn"><i class="fa-solid fa-home"></i> Dashboard</a>
            <a href="CheckOutServlet" class="btn btn-secondary"><i class="fa-solid fa-plus"></i> Another Check-Out</a>
        </div>
    </div>
</body>
</html>