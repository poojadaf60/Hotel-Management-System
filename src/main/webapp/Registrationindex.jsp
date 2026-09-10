<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Registration</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }

body {
    background:#eef2f7;
    display:flex;
    justify-content:center;
    align-items:center;
    min-height:100vh;
    padding:20px;
}
.container { width:100%; max-width:430px; }

.form-box {
    background:#fff;
    padding:35px;
    border-radius:15px;
    box-shadow:0 10px 25px rgba(0,0,0,.12);
    border-top:6px solid #E3123D;
}
h1 { text-align:center; color:#273340; margin-bottom:10px; }
.subtitle { text-align:center; color:#666; margin-bottom:25px; }
.subtitle a { color:#E3123D; text-decoration:none; font-weight:600; }
.subtitle a:hover { text-decoration:underline; }

label { display:block; margin-top:15px; margin-bottom:6px; font-weight:600; color:#273340; }
input {
    width:100%;
    padding:13px;
    border:1px solid #ccc;
    border-radius:8px;
    outline:none;
    font-size:14px;
    transition:.3s;
}
input:focus { border-color:#E3123D; box-shadow:0 0 8px rgba(227,18,61,.25); }

button {
    width:100%;
    margin-top:25px;
    padding:14px;
    background:#E3123D;
    border:none;
    border-radius:8px;
    color:white;
    font-size:16px;
    font-weight:600;
    cursor:pointer;
    transition:.3s;
}
button:hover { background:#c50f35; }

.footer { margin-top:20px; text-align:center; color:#666; }
.footer a { color:#E3123D; font-weight:600; text-decoration:none; }
.footer a:hover { text-decoration:underline; }

.success { background:#d4edda; color:#155724; padding:10px; border-radius:5px; margin-bottom:15px; text-align:center; }
.error { background:#f8d7da; color:#721c24; padding:10px; border-radius:5px; margin-bottom:15px; text-align:center; }

@media(max-width:480px){
    .form-box { padding:25px; }
    h1 { font-size:24px; }
}

function validateForm(){
    var password=document.getElementById("password").value;
    var confirm=document.getElementById("confirmPassword").value;
    if(password!=confirm){
        alert("Password and Confirm Password do not match.");
        return false;
    }
    return true;
}
</style>
<script>
function validateForm(){
    var password=document.getElementById("password").value;
    var confirm=document.getElementById("confirmPassword").value;
    if(password!=confirm){
        alert("Password and Confirm Password do not match.");
        return false;
    }
    return true;
}
</script>
</head>
<body>

<div class="container">
    <div class="form-box">

        <h1>Create Account</h1>
        <p class="subtitle">Already have an account? <a href="Loginindex.jsp">Login Now</a></p>

        <%
        String msg=request.getParameter("msg");
        if("success".equals(msg)){ %>
            <div class="success">Registration Successful! Please Login.</div>
        <% }else if("exists".equals(msg)){ %>
            <div class="error">Email already registered.</div>
        <% }else if("error".equals(msg)){ %>
            <div class="error">Registration Failed.</div>
        <% }
        %>

        <form action="RegisterServlet" method="post" onsubmit="return validateForm()">

            <label>Full Name</label>
            <input type="text" name="username" placeholder="Enter your full name" required>

            <label>Email Address</label>
            <input type="email" name="email" placeholder="example@gmail.com" required>

            <label>Password</label>
            <input type="password" id="password" name="password" placeholder="Enter password" minlength="6" required>

            <label>Confirm Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required>

            <button type="submit">Register</button>

        </form>

        <div class="footer">
            Already Registered? <a href="Loginindex.jsp">Sign In</a>
        </div>

    </div>
</div>

</body>
</html>