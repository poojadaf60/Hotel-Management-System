<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>About Us - Royal Palace Hotel</title>
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

/* ===== HAMBURGER TOGGLE ===== */
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


.banner {
    height:300px;
    background:url('https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1400&q=80') center/cover no-repeat;
    display:flex;
    justify-content:center;
    align-items:center;
    color:#fff;
    position:relative;
}
.banner::before {
    content:'';
    position:absolute;
    top:0; left:0;
    width:100%; height:100%;
    background:rgba(0,0,0,.55);
}
.banner h1 {
    position:relative;
    font-size:48px;
    z-index:2;
    text-align:center;
    padding:20px;
}


.container { max-width:1100px; margin:60px auto; padding:0 20px; }
.section { margin-bottom:50px; }
.section h2 { font-size:34px; margin-bottom:15px; color:#273340; }
.section p { line-height:1.8; color:#555; }

.stats {
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(200px,1fr));
    gap:25px;
    margin-top:30px;
}
.stat {
    background:#fff;
    padding:30px;
    border-radius:12px;
    text-align:center;
    box-shadow:0 5px 15px rgba(0,0,0,.1);
}
.stat h3 { font-size:36px; color:#E3123D; margin-bottom:10px; }
.stat p { color:#555; }

.team {
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
    gap:25px;
    margin-top:30px;
}
.member {
    background:#fff;
    padding:20px;
    border-radius:12px;
    text-align:center;
    box-shadow:0 5px 15px rgba(0,0,0,.1);
}
.member img { width:100%; height:220px; object-fit:cover; border-radius:10px; margin-bottom:15px; }
.member h4 { color:#273340; margin-bottom:5px; }
.member p { color:#777; }

footer { background:#273340; color:#fff; text-align:center; padding:20px; margin-top:40px; }


@media (max-width: 992px) {
    .container { margin:40px auto; }
    .section h2 { font-size:30px; }
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

    .banner { height:200px; }
    .banner h1 { font-size:34px; }

    .container { margin:30px auto; padding:0 15px; }
    .section h2 { font-size:28px; }

    .stats {
        grid-template-columns:1fr 1fr;
        gap:15px;
    }
    .stat { padding:20px; }
    .stat h3 { font-size:28px; }

    .team {
        grid-template-columns:1fr;
        max-width:400px;
        margin:30px auto 0;
    }
}

@media (max-width: 480px) {
    .logo { font-size:22px; }
    .hamburger { font-size:26px; }

    .banner { height:150px; }
    .banner h1 { font-size:28px; }

    .container { margin:20px 0; padding:0 15px; }
    .section { margin-bottom:30px; }
    .section h2 { font-size:24px; }

    .stats { grid-template-columns:1fr; }
    .stat { padding:15px; }
    .stat h3 { font-size:24px; }

    .member img { height:180px; }

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
    </nav>
</header>

<section class="banner">
    <h1>About Us</h1>
</section>

<div class="container">
    <div class="section">
        <h2>Who We Are</h2>
        <p>Royal Palace Hotel is a luxury hospitality destination committed to providing exceptional comfort, elegant rooms, fine dining, and outstanding customer service. Our mission is to make every guest feel at home while enjoying a royal experience.</p>
    </div>

    <div class="section">
        <h2>Our Mission</h2>
        <p>To deliver unforgettable hospitality experiences through quality service, modern facilities, and genuine care for every guest.</p>
    </div>

    <div class="section">
        <h2>Why Choose Us?</h2>
        <div class="stats">
            <div class="stat"><h3>120+</h3><p>Luxury Rooms</p></div>
            <div class="stat"><h3>50+</h3><p>Professional Staff</p></div>
            <div class="stat"><h3>10k+</h3><p>Happy Guests</p></div>
            <div class="stat"><h3>24x7</h3><p>Customer Support</p></div>
        </div>
    </div>

    <div class="section">
        <h2>Meet Our Team</h2>
        <div class="team">
            <div class="member">
                <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=600&q=80" alt="Manager">
                <h4>John Smith</h4>
                <p>General Manager</p>
            </div>
            <div class="member">
                <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=600&q=80" alt="Reception">
                <h4>Emily Johnson</h4>
                <p>Front Office Manager</p>
            </div>
            <div class="member">
                <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=600&q=80" alt="Chef">
                <h4>Michael Brown</h4>
                <p>Executive Chef</p>
            </div>
        </div>
    </div>
</div>

<footer>
    © 2026 Royal Palace Hotel | All Rights Reserved
</footer>

</body>
</html>