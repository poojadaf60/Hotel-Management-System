<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Customer</title>
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

/* ===== MAIN ===== */
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
    justify-content:center;
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
    margin-bottom:30px;
    color:#2c3e50;
}

.form {
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:20px;
}

.form-group {
    display:flex;
    flex-direction:column;
}

label {
    font-weight:600;
    margin-bottom:8px;
    color:#555;
}

input, textarea {
    padding:12px;
    border:1px solid #ddd;
    border-radius:8px;
    font-size:14px;
    outline:none;
    transition:0.3s;
    width:100%;
}
input:focus, textarea:focus {
    border-color:#e3123d;
    box-shadow:0 0 8px rgba(227,18,61,0.1);
}
textarea {
    height:100px;
    resize:none;
}

.button {
    grid-column:span 2;
    text-align:center;
    display:flex;
    justify-content:center;
    gap:15px;
    flex-wrap:wrap;
    margin-top:10px;
}

.btn-add {
    background:#e3123d;
    color:white;
    border:none;
    padding:14px 35px;
    border-radius:8px;
    font-size:16px;
    cursor:pointer;
    transition:0.3s;
}
.btn-add:hover { background:#c50d34; }

.btn-back {
    background:#34495e;
    color:white;
    padding:14px 35px;
    border:none;
    border-radius:8px;
    cursor:pointer;
    font-size:16px;
    text-decoration:none;
    transition:0.3s;
}
.btn-back:hover { background:#2c3e50; }


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

/* ===== SIDEBAR TOGGLE ===== */
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

    .form { grid-template-columns:1fr; }
    .button { 
        grid-column:span 1; 
        flex-direction:column; 
        align-items:stretch; 
    }
    .button .btn-add, .button .btn-back { 
        width:100%; 
        text-align:center; 
    }

    .container { padding:20px; }

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

    input, textarea { padding:10px; font-size:13px; }

    .btn-add, .btn-back { 
        padding:12px; 
        font-size:14px; 
        width:100%;
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
    <a class="active" href="CustomerManagementServlet">👥 Customers</a>
    <a href="BookingManagementServlet">📅 Bookings</a>
    <a href="PaymentManagementServlet">💳 Payments</a>
    <a href="LogoutServlet">🚪 Logout</a>
</div>


<label for="sidebar-toggle" class="sidebar-overlay"></label>


<div class="main">

  
    <div class="navbar">
        <div style="display:flex;align-items:center;gap:15px;">
            <label for="sidebar-toggle" class="hamburger" aria-label="Toggle menu">☰</label>
            <h2 style="margin:0;font-size:20px;color:#273340;">Add Customer</h2>
        </div>
        <div>Welcome, <b><%= session.getAttribute("username") %></b></div>
    </div>

 
    <div class="content">

        <div class="container">
            <h2><i class="fa-solid fa-user-plus"></i> Add Customer</h2>

            <form action="CustomerServlet" method="post" class="form">

                <div class="form-group">
                    <label>Customer Name</label>
                    <input type="text" name="name" placeholder="Enter Customer Name" required>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" placeholder="Enter Email" required>
                </div>

                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" placeholder="Enter Phone Number" required>
                </div>

                <div class="form-group">
                    <label>Address</label>
                    <input type="text" name="address" placeholder="Enter Address" required>
                </div>

                <div class="button">
                    <button type="submit" class="btn-add">
                        <i class="fa-solid fa-floppy-disk"></i> Add Customer
                    </button>
                    <a href="CustomerManagementServlet">
                        <button type="button" class="btn-back">
                            <i class="fa-solid fa-arrow-left"></i> Back
                        </button>
                    </a>
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