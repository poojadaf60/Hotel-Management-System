<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Login – Royal Palace</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
        body { background:#eef2f7; display:flex; justify-content:center; align-items:center; min-height:100vh; padding:20px; }
        .container { width:100%; max-width:420px; }
        .login-box { background:#fff; padding:35px; border-radius:15px; box-shadow:0 10px 25px rgba(0,0,0,.12); border-top:6px solid #E3123D; }
        h1 { text-align:center; color:#273340; margin-bottom:10px; }
        .subtitle { text-align:center; font-size:14px; color:#666; margin-bottom:20px; }
        .error { background:#f8d7da; color:#721c24; padding:10px; border-radius:6px; text-align:center; margin-bottom:15px; }
        .success { background:#d4edda; color:#155724; padding:10px; border-radius:6px; text-align:center; margin-bottom:15px; border-left:6px solid #28a745; }
        label { display:block; margin-top:15px; margin-bottom:6px; font-weight:600; color:#273340; }
        input { width:100%; padding:13px; border:1px solid #ccc; border-radius:8px; outline:none; font-size:14px; transition:.3s; }
        input:focus { border-color:#E3123D; box-shadow:0 0 8px rgba(227,18,61,.25); }
        button { width:100%; margin-top:25px; padding:14px; background:#E3123D; color:white; border:none; border-radius:8px; font-size:16px; font-weight:600; cursor:pointer; transition:.3s; }
        button:hover { background:#c50f35; }
        .footer { text-align:center; margin-top:20px; color:#666; }
        .footer a { color:#E3123D; text-decoration:none; font-weight:600; }
        .footer a:hover { text-decoration:underline; }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-box">
            <h1><i class="fa-regular fa-user"></i> Customer Login</h1>
            <p class="subtitle">Login to complete your booking</p>

            <!-- ✅ Registration success message -->
            <%
                String msg = request.getParameter("msg");
                if ("registered".equals(msg)) {
            %>
                <div class="success">
                    <i class="fa-solid fa-check-circle"></i> Registration successful! Please login to continue.
                </div>
            <%
                }
            %>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error"><i class="fa-solid fa-exclamation-circle"></i> <%= request.getAttribute("error") %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/CustomerLoginServlet" method="post">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="Enter your email" required>
                <label>Password</label>
                <input type="password" name="password" placeholder="Enter your password" required>
                <button type="submit"><i class="fa-solid fa-arrow-right-to-bracket"></i> Login & Continue</button>
            </form>

            <div class="footer">
                Don't have an account? <a href="<%= request.getContextPath() %>/CustomerRegister.jsp">Register Now</a>
            </div>
        </div>
    </div>
</body>
</html>