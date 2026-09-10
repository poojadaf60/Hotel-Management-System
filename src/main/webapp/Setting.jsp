<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("Loginindex.jsp");
        return;
    }
    String userId = String.valueOf(session.getAttribute("userid"));
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");
    String profilePic = (String) session.getAttribute("profilePic");
    if (profilePic == null || profilePic.isEmpty()) {
        profilePic = "https://ui-avatars.com/api/?name=" + username + "&background=E3123D&color=fff&size=100";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Settings – Royal Palace Hotel</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
        body { background:#eef2f7; }
        .sidebar {
            position: fixed; left: 0; top: 0; width: 250px; height: 100%;
            background: #273340; overflow-y: auto; z-index: 1000;
            transition: transform 0.3s ease;
        }
        .logo { padding: 25px; font-size: 28px; font-weight: bold; text-align: center; color: #E3123D; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .logo span { color: white; }
        .sidebar a { display: block; padding: 16px 25px; text-decoration: none; color: white; transition: 0.3s; font-weight: 500; }
        .sidebar a:hover, .sidebar .active { background: #E3123D; }
        .main { margin-left: 250px; min-height: 100vh; }
        .navbar {
            height: 70px; background: white; display: flex; justify-content: space-between;
            align-items: center; padding: 0 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            position: sticky; top: 0; z-index: 999;
        }
        .navbar .hamburger { display: none; cursor: pointer; font-size: 28px; color: #273340; }
        .content { padding: 30px; max-width: 900px; margin: auto; }
        .card {
            background: white; border-radius: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            padding: 30px; margin-bottom: 30px;
        }
        .card h3 { color: #273340; margin-bottom: 20px; border-bottom: 2px solid #eef2f7; padding-bottom: 10px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 6px; font-weight: 600; color: #555; }
        input[type="text"], input[type="email"], input[type="password"], input[type="file"] {
            width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px;
            outline: none; font-size: 15px; transition: 0.3s;
        }
        input:focus { border-color: #E3123D; box-shadow: 0 0 8px rgba(227,18,61,0.1); }
        .profile-pic-container {
            display: flex; align-items: center; gap: 20px; margin-bottom: 15px; flex-wrap: wrap;
        }
        .profile-pic-container img {
            width: 100px; height: 100px; border-radius: 50%; object-fit: cover;
            border: 4px solid #E3123D; box-shadow: 0 5px 15px rgba(0,0,0,0.15);
        }
        .profile-pic-container .upload-hint { font-size: 14px; color: #777; }
        .btn { background: #E3123D; color: white; border: none; padding: 12px 30px; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: 0.3s; }
        .btn:hover { background: #c50d34; }
        .btn-secondary { background: #17a2b8; }
        .btn-secondary:hover { background: #138496; }
        .msg-success { background:#d4edda; color:#155724; padding:12px 18px; border-radius:8px; border-left:6px solid #28a745; margin-bottom:20px; display:flex; align-items:center; gap:10px; }
        .msg-error { background:#f8d7da; color:#721c24; padding:12px 18px; border-radius:8px; border-left:6px solid #dc3545; margin-bottom:20px; display:flex; align-items:center; gap:10px; }
        .row { display: flex; gap: 20px; }
        .row .col { flex: 1; }
        #sidebar-toggle { display: none; }
        .sidebar-overlay {
            display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5); z-index: 998; cursor: pointer;
        }
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); width: 280px; }
            .main { margin-left: 0; }
            .navbar .hamburger { display: block; }
            .navbar { padding: 0 15px; height: 60px; flex-wrap: wrap; }
            .content { padding: 15px; }
            .row { flex-direction: column; }
            .card { padding: 20px; }
            .profile-pic-container { flex-direction: column; text-align: center; }
            #sidebar-toggle:checked ~ .sidebar { transform: translateX(0); }
            #sidebar-toggle:checked ~ .sidebar-overlay { display: block; }
        }
        @media (max-width: 480px) {
            .sidebar { width: 100%; }
            .navbar { flex-direction: column; height: auto; padding: 15px; gap: 10px; }
            .navbar h2 { font-size: 18px !important; }
            .profile-pic-container img { width: 80px; height: 80px; }
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
    <a class="active" href="Setting.jsp">⚙ Settings</a>
    <a href="PaymentManagementServlet">💳 Payments</a>
    <a href="LogoutServlet">🚪 Logout</a>
</div>
<label for="sidebar-toggle" class="sidebar-overlay"></label>
<div class="main">
    <div class="navbar">
        <div style="display:flex;align-items:center;gap:15px;">
            <label for="sidebar-toggle" class="hamburger">☰</label>
            <h2 style="margin:0;font-size:20px;color:#273340;"><i class="fa-solid fa-gear"></i> Settings</h2>
        </div>
        <div style="display:flex;align-items:center;gap:10px;">
            <img src="<%= profilePic %>" alt="Profile" style="width:40px;height:40px;border-radius:50%;object-fit:cover;border:2px solid #E3123D;">
            <span>Welcome, <b><%= session.getAttribute("username") %></b></span>
        </div>
    </div>
    <div class="content">
        <%
            String profileMsg = request.getParameter("profileMsg");
            if (profileMsg != null) {
                if ("success".equals(profileMsg)) {
        %>
            <div class="msg-success"><i class="fa-solid fa-check-circle"></i> Profile updated successfully!</div>
        <%
                } else if ("error".equals(profileMsg)) {
        %>
            <div class="msg-error"><i class="fa-solid fa-exclamation-circle"></i> Failed to update profile. Please try again.</div>
        <%
                }
            }
            String pwdMsg = request.getParameter("pwdMsg");
            if (pwdMsg != null) {
                if ("success".equals(pwdMsg)) {
        %>
            <div class="msg-success"><i class="fa-solid fa-check-circle"></i> Password changed successfully!</div>
        <%
                } else if ("incorrect".equals(pwdMsg)) {
        %>
            <div class="msg-error"><i class="fa-solid fa-exclamation-circle"></i> Old password is incorrect.</div>
        <%
                } else if ("mismatch".equals(pwdMsg)) {
        %>
            <div class="msg-error"><i class="fa-solid fa-exclamation-circle"></i> New password and confirm password do not match.</div>
        <%
                } else {
        %>
            <div class="msg-error"><i class="fa-solid fa-exclamation-circle"></i> Failed to change password. Please try again.</div>
        <%
                }
            }
        %>
        <!-- ========== PROFILE UPDATE SECTION ========== -->
        <div class="card">
            <h3><i class="fa-regular fa-user"></i> Update Profile</h3>
            <div class="profile-pic-container">
                <img src="<%= profilePic %>" alt="Profile Picture" id="profilePreview">
                <div>
                    <p style="font-weight:600;color:#273340;"><%= username %></p>
                    <p style="color:#777;font-size:14px;"><%= email %></p>
                    <span class="upload-hint"><i class="fa-regular fa-circle-info"></i> Click "Choose File" below to change picture</span>
                </div>
            </div>
            <form action="UpdateProfileServlet" method="post" enctype="multipart/form-data">
                <div class="row">
                    <div class="col">
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="username" value="<%= username %>" required>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" name="email" value="<%= email %>" required>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label><i class="fa-regular fa-image"></i> Profile Picture</label>
                    <input type="file" name="profilePic" accept="image/*" onchange="previewImage(event)">
                    <small style="color:#888;font-size:12px;">Max size: 5MB (JPG, PNG, GIF)</small>
                </div>
                <input type="hidden" name="userId" value="<%= userId %>">
                <button type="submit" class="btn"><i class="fa-solid fa-floppy-disk"></i> Update Profile</button>
            </form>
        </div>
        <!-- ========== CHANGE PASSWORD SECTION ========== -->
        <div class="card">
            <h3><i class="fa-solid fa-key"></i> Change Password</h3>
            <form action="ChangePasswordServlet" method="post">
                <div class="form-group">
                    <label>Current Password</label>
                    <input type="password" name="oldPassword" placeholder="Enter current password" required>
                </div>
                <div class="row">
                    <div class="col">
                        <div class="form-group">
                            <label>New Password</label>
                            <input type="password" name="newPassword" placeholder="Enter new password" required minlength="6">
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label>Confirm New Password</label>
                            <input type="password" name="confirmPassword" placeholder="Confirm new password" required minlength="6">
                        </div>
                    </div>
                </div>
                <input type="hidden" name="userId" value="<%= userId %>">
                <button type="submit" class="btn btn-secondary"><i class="fa-solid fa-key"></i> Change Password</button>
            </form>
        </div>
    </div>
</div>
<script>
    function previewImage(event) {
        var reader = new FileReader();
        reader.onload = function(){
            var output = document.getElementById('profilePreview');
            output.src = reader.result;
        };
        reader.readAsDataURL(event.target.files[0]);
    }
</script>
</body>
</html>