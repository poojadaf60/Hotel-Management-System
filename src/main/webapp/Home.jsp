<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Royal Palace Hotel</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
html, body { background:#f4f6f9; color:#333; overflow-x:hidden; }
header {
    background:#273340;
    padding:15px 20px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    flex-wrap:wrap;
    position:relative;
}
.logo { font-size:28px; font-weight:bold; color:#E3123D; }
.logo span { color:#fff; }
#nav-toggle { display:none; }
.hamburger {
    display:none;
    cursor:pointer;
    font-size:30px;
    color:#fff;
    background:none;
    border:none;
    padding:5px;
    line-height:1;
}
nav {
    display:flex;
    flex-wrap:wrap;
    gap:10px 20px;
    align-items:center;
}
nav a {
    color:#fff;
    text-decoration:none;
    font-weight:500;
    transition:0.3s;
    padding:5px 10px;
    border-radius:5px;
}
nav a:hover { color:#E3123D; background:rgba(255,255,255,0.05); }
.hero {
    height:90vh;
    min-height:400px;
    background:url('https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1400&q=80') center/cover no-repeat;
    display:flex;
    justify-content:center;
    align-items:center;
    text-align:center;
    color:#fff;
    position:relative;
}
.hero::before {
    content:'';
    position:absolute;
    top:0; left:0;
    width:100%; height:100%;
    background:rgba(0,0,0,.55);
}
.hero-content {
    position:relative;
    z-index:2;
    padding:20px;
}
.hero h1 { font-size:52px; margin-bottom:15px; }
.hero p { font-size:20px; margin-bottom:25px; }
.btn {
    display:inline-block;
    padding:12px 25px;
    background:#E3123D;
    color:#fff;
    text-decoration:none;
    border-radius:8px;
    font-weight:600;
    transition:0.3s;
}
.btn:hover { background:#c10f34; }
.section { padding:70px 10%; text-align:center; }
.section h2 { font-size:36px; margin-bottom:20px; color:#273340; }
.section p { max-width:800px; margin:auto; line-height:1.7; color:#555; }
.rooms {
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(250px,1fr));
    gap:25px;
    margin-top:40px;
}
.room-card {
    background:#fff;
    border-radius:12px;
    overflow:hidden;
    box-shadow:0 5px 15px rgba(0,0,0,.1);
    transition:0.3s;
}
.room-card:hover { transform:translateY(-8px); }
.room-card img { width:100%; height:200px; object-fit:cover; }
.room-card h3 { padding:15px 0 5px; color:#273340; }
.room-card p { padding-bottom:20px; font-weight:600; color:#E3123D; }
.services {
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
    gap:25px;
    margin-top:40px;
}
.service { background:#fff; padding:30px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,.1); }
.service h3 { margin:15px 0; color:#273340; }
footer { background:#273340; color:#fff; text-align:center; padding:20px; margin-top:40px; }
@media (max-width: 992px) {
    .section { padding:50px 5%; }
    .section h2 { font-size:30px; }
    .hero h1 { font-size:42px; }
    .rooms { grid-template-columns:repeat(2,1fr); }
}
@media (max-width: 768px) {
    header { padding:15px; }
    .logo { font-size:24px; }
    .hamburger { display:block; }
    nav {
        display:none;
        flex-direction:column;
        width:100%;
        background:#1a2530;
        padding:15px 20px;
        border-radius:0 0 10px 10px;
        gap:5px;
        position:absolute;
        top:100%;
        left:0;
        z-index:100;
        box-shadow:0 10px 20px rgba(0,0,0,0.3);
    }
    nav a {
        padding:12px 15px;
        width:100%;
        text-align:center;
        border-bottom:1px solid rgba(255,255,255,0.05);
    }
    nav a:last-child { border-bottom:none; }
    #nav-toggle:checked ~ nav { display:flex; }
    .hero { height:70vh; min-height:350px; }
    .hero h1 { font-size:34px; }
    .hero p { font-size:16px; }
    .section { padding:40px 5%; }
    .section h2 { font-size:26px; }
    .rooms { grid-template-columns:1fr; max-width:400px; margin:30px auto 0; }
    .services { grid-template-columns:1fr 1fr; }
    .room-card img { height:180px; }
}
@media (max-width: 480px) {
    .logo { font-size:22px; }
    .hamburger { font-size:26px; }
    .hero { height:60vh; min-height:300px; }
    .hero h1 { font-size:28px; }
    .hero p { font-size:14px; }
    .btn { padding:10px 20px; font-size:14px; }
    .section { padding:30px 15px; }
    .section h2 { font-size:24px; }
    .services { grid-template-columns:1fr; }
    .room-card img { height:160px; }
    footer { font-size:13px; padding:15px; }
}
</style>
</head>
<body>
<header>
    <div class="logo">Royal <span>Palace</span></div>
    <label for="nav-toggle" class="hamburger">☰</label>
    <input type="checkbox" id="nav-toggle">
    <nav>
        <a href="Home.jsp">Home</a>
        <a href="About.jsp">About</a>
        <a href="Loginindex.jsp">Login</a>
        <a href="Registrationindex.jsp">Register</a>
    </nav>
</header>
<section class="hero">
    <div class="hero-content">
        <h1>Welcome to Royal Palace Hotel</h1>
        <p>Luxury, Comfort & Elegance in Every Stay</p>
        
        <a href="PublicBookingServlet" class="btn">Book Now</a>
    </div>
</section>
<section class="section">
    <h2>Experience Royal Hospitality</h2>
    <p>Enjoy a memorable stay with world-class rooms, delicious dining, modern facilities, and exceptional service designed for your comfort.</p>
</section>
<section class="section" style="background:#fff;">
    <h2>Our Rooms</h2>
    <div class="rooms">
        <div class="room-card">
            <img src="https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80" alt="Single Room">
            <h3>Single Room</h3>
            <p>₹2500 / Night</p>
        </div>
        <div class="room-card">
            <img src="https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80" alt="Double Room">
            <h3>Double Room</h3>
            <p>₹3500 / Night</p>
        </div>
        <div class="room-card">
            <img src="https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80" alt="Deluxe Room">
            <h3>Deluxe Room</h3>
            <p>₹5500 / Night</p>
        </div>
    </div>
</section>
<section class="section">
    <h2>Hotel Services</h2>
    <div class="services">
        <div class="service"><h3>Free Wi-Fi</h3><p>Stay connected with high-speed internet access.</p></div>
        <div class="service"><h3>Restaurant</h3><p>Enjoy delicious meals from our premium kitchen.</p></div>
        <div class="service"><h3>Swimming Pool</h3><p>Relax and refresh in our luxurious pool area.</p></div>
        <div class="service"><h3>24x7 Support</h3><p>Our staff is available anytime for your assistance.</p></div>
    </div>
</section>
<footer>
    © 2026 Royal Palace Hotel 
</footer>
</body>
</html>