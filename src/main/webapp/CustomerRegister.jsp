<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Register – Royal Palace</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
        body { background:#eef2f7; display:flex; justify-content:center; align-items:center; min-height:100vh; padding:20px; }
        .container { width:100%; max-width:430px; }
        .form-box { background:#fff; padding:35px; border-radius:15px; box-shadow:0 10px 25px rgba(0,0,0,.12); border-top:6px solid #E3123D; }
        h1 { text-align:center; color:#273340; margin-bottom:10px; }
        .subtitle { text-align:center; color:#666; margin-bottom:25px; }
        .subtitle a { color:#E3123D; text-decoration:none; font-weight:600; }
        .subtitle a:hover { text-decoration:underline; }
        .error { background:#f8d7da; color:#721c24; padding:10px; border-radius:5px; margin-bottom:15px; text-align:center; }
        label { display:block; margin-top:15px; margin-bottom:6px; font-weight:600; color:#273340; }
        input { width:100%; padding:13px; border:1px solid #ccc; border-radius:8px; outline:none; font-size:14px; transition:.3s; }
        input:focus { border-color:#E3123D; box-shadow:0 0 8px rgba(227,18,61,.25); }
        button { width:100%; margin-top:25px; padding:14px; background:#E3123D; color:white; border:none; border-radius:8px; font-size:16px; font-weight:600; cursor:pointer; transition:.3s; }
        button:hover { background:#c50f35; }
        .footer { text-align:center; margin-top:20px; color:#666; }
        .footer a { color:#E3123D; text-decoration:none; font-weight:600; }
        .footer a:hover { text-decoration:underline; }
        .info-msg { text-align:center; color:#E3123D; font-weight:500; margin-bottom:15px; }
    </style>
    <script>
        function validateForm() {
            var pwd = document.getElementById("password").value;
            var confirm = document.getElementById("confirmPassword").value;
            if (pwd !== confirm) {
                alert("Passwords do not match.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="form-box">
            <h1><i class="fa-regular fa-user-plus"></i> Create Account</h1>
            <p class="subtitle">Already have an account? <a href="CustomerLogin.jsp">Login here</a></p>

            <div class="info-msg">
                <i class="fa-solid fa-circle-info"></i> Register to complete your booking
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error"><i class="fa-solid fa-exclamation-circle"></i> <%= request.getAttribute("error") %></div>
            <% } %>

            <form action="CustomerRegisterServlet" method="post" onsubmit="return validateForm()">
                <label>Full Name</label>
                <input type="text" name="name" placeholder="Enter your name" required>
                <label>Email Address</label>
                <input type="email" name="email" placeholder="Enter your email" required>
                <label>Phone Number</label>
                <input type="text" name="phone" placeholder="Enter phone number" required>
                <label>Address</label>
                <input type="text" name="address" placeholder="Enter your address" required>
                <label>Password</label>
                <input type="password" id="password" name="password" placeholder="Set password (min 6 chars)" minlength="6" required>
                <label>Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required>
                <button type="submit"><i class="fa-solid fa-user-check"></i> Register & Complete Booking</button>
            </form>

            <div class="footer">
                Already have an account? <a href="CustomerLogin.jsp">Login here</a>
            </div>
        </div>
    </div>
</body>
</html>