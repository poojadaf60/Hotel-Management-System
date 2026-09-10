<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.org.Room, java.time.LocalDate" %>

<%
    // ✅ SESSION CHECK: अगर customer logged in नहीं है → Register page पर भेजो
    Integer customerId = (Integer) session.getAttribute("customerId");
    if (customerId == null) {
        session.setAttribute("bookingRedirect", "PublicBookingServlet");
        response.sendRedirect("CustomerRegister.jsp");
        return;
    }

    // Pre-fill values
    String prefillName = (String) request.getAttribute("prefill_name");
    String prefillEmail = (String) request.getAttribute("prefill_email");
    String prefillPhone = (String) request.getAttribute("prefill_phone");
    String prefillAddress = (String) request.getAttribute("prefill_address");
    String prefillCheckIn = (String) request.getAttribute("prefill_checkIn");
    String prefillCheckOut = (String) request.getAttribute("prefill_checkOut");
    if (prefillName == null) prefillName = "";
    if (prefillEmail == null) prefillEmail = "";
    if (prefillPhone == null) prefillPhone = "";
    if (prefillAddress == null) prefillAddress = "";
    if (prefillCheckIn == null) prefillCheckIn = "";
    if (prefillCheckOut == null) prefillCheckOut = "";

    List<Room> rooms = (List<Room>) request.getAttribute("allRooms");
    if (rooms == null) rooms = new java.util.ArrayList<>();
    
    String errorMsg = (String) request.getAttribute("errorMsg");
    String successMsg = (String) request.getAttribute("successMsg");
    Integer bookingId = (Integer) request.getAttribute("bookingId");
    String whatsappLink = (String) request.getAttribute("whatsappLink");
    String customerName = (String) request.getAttribute("customerName");
    String checkIn = (String) request.getAttribute("checkIn");
    String checkOut = (String) request.getAttribute("checkOut");
    Double totalAmount = (Double) request.getAttribute("totalAmount");
    
    String today = LocalDate.now().toString();
    String tomorrow = LocalDate.now().plusDays(1).toString();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Book Room - Royal Palace Hotel</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#f4f6f9; min-height:100vh; display:flex; justify-content:center; align-items:center; padding:20px; }
.container { max-width:700px; width:100%; background:white; padding:40px; border-radius:20px; box-shadow:0 15px 35px rgba(0,0,0,0.15); border-top:8px solid #E3123D; }
h1 { color:#273340; font-size:32px; text-align:center; margin-bottom:8px; }
.subtitle { text-align:center; color:#666; margin-bottom:25px; font-size:15px; }
.alert-error { background:#f8d7da; color:#721c24; padding:14px; border-radius:10px; border-left:6px solid #dc3545; margin-bottom:20px; }
.alert-success { background:#d4edda; color:#155724; padding:20px; border-radius:12px; border-left:6px solid #28a745; margin-bottom:20px; text-align:center; }
.alert-success h3 { font-size:24px; margin-bottom:5px; }
.booking-id-box { background:#155724; color:white; padding:8px 20px; border-radius:8px; display:inline-block; font-size:22px; font-weight:bold; margin:10px 0; }
.booking-details { background:#f8f9fa; border-radius:10px; padding:15px; margin:15px 0; text-align:left; font-size:14px; }
.booking-details p { margin:5px 0; }
.whatsapp-btn { display:inline-block; background:#25D366; color:white; padding:14px 30px; border-radius:50px; text-decoration:none; font-weight:bold; font-size:18px; transition:0.3s; border:none; cursor:pointer; margin-top:10px; }
.whatsapp-btn:hover { background:#1da851; transform:scale(1.02); }
.whatsapp-btn i { margin-right:10px; font-size:22px; }
.booking-form { margin-top:10px; }
.form-group { margin-bottom:18px; }
label { display:block; font-weight:600; color:#333; margin-bottom:6px; }
input, select { width:100%; padding:14px; border:1px solid #ddd; border-radius:10px; font-size:15px; outline:none; transition:0.3s; background:white; }
input:focus, select:focus { border-color:#E3123D; box-shadow:0 0 10px rgba(227,18,61,0.15); }
.row { display:grid; grid-template-columns:1fr 1fr; gap:18px; }
.btn-book { width:100%; padding:16px; background:#E3123D; color:white; border:none; border-radius:12px; font-size:18px; font-weight:700; cursor:pointer; transition:0.3s; display:flex; align-items:center; justify-content:center; gap:12px; margin-top:10px; }
.btn-book:hover { background:#c50f35; transform:scale(1.01); }
.footer { margin-top:25px; text-align:center; color:#888; font-size:14px; }
.footer a { color:#E3123D; text-decoration:none; font-weight:600; }
.footer a:hover { text-decoration:underline; }
.hint { font-size:12px; color:#888; margin-top:5px; }
.debug { background:#f0f0f0; padding:8px 12px; border-radius:5px; margin-bottom:15px; font-size:14px; color:#555; text-align:center; }
@media(max-width:600px){ .container { padding:25px; } .row { grid-template-columns:1fr; } h1 { font-size:26px; } .whatsapp-btn { font-size:15px; padding:12px 20px; width:100%; } }
</style>
</head>
<body>
<div class="container">
    <h1>🛏️ Book Your Stay</h1>
    <p class="subtitle">Royal Palace Hotel – Check availability & book instantly</p>
    <div class="debug">
        <i class="fa-regular fa-circle-info"></i> Rooms available: <strong><%= rooms.size() %></strong>
    </div>
    <% if (errorMsg != null) { %>
        <div class="alert-error"><i class="fa-solid fa-exclamation-circle"></i> <%= errorMsg %></div>
    <% } %>
    <% if (successMsg != null && bookingId != null) { %>
        <div class="alert-success">
            <h3><i class="fa-solid fa-check-circle" style="color:#28a745;"></i> <%= successMsg %></h3>
            <div class="booking-id-box">Booking ID: <%= bookingId %></div>
            <div class="booking-details">
                <p><b>👤 Customer:</b> <%= customerName %></p>
                <p><b>📅 Check-In:</b> <%= checkIn %></p>
                <p><b>📅 Check-Out:</b> <%= checkOut %></p>
                <p><b>💰 Total Amount:</b> ₹ <%= totalAmount %></p>
            </div>
            <a href="<%= whatsappLink %>" target="_blank" class="whatsapp-btn">
                <i class="fa-brands fa-whatsapp"></i> Send Booking Details to Hotel
            </a>
            <p style="font-size:12px;color:#666;margin-top:10px;">📲 Click to open WhatsApp and confirm your booking with the hotel.</p>
        </div>
    <% } %>
    <% if (successMsg == null) { %>
        <div class="booking-form">
            <form action="PublicBookingServlet" method="post">
                <div class="form-group">
                    <label><i class="fa-regular fa-bed"></i> Select Room</label>
                    <select name="roomId" id="roomSelect" required>
                        <option value="">-- Choose a Room --</option>
                        <% for (Room r : rooms) {
                            String status = r.getStatus();
                            boolean isAvailable = (status != null && "Available".equalsIgnoreCase(status));
                            String disabled = isAvailable ? "" : "disabled";
                            String statusText = isAvailable ? "✅ Available" : (status != null ? "❌ " + status : "❌ Unknown");
                        %>
                            <option value="<%= r.getRoomId() %>" <%= disabled %>>
                                <%= r.getRoomNo() %> - <%= r.getRoomType() %> (₹ <%= r.getPrice() %>/night) - <%= statusText %>
                            </option>
                        <% } %>
                    </select>
                    <div class="hint">💡 <span style="color:#dc3545;">Booked</span> rooms are disabled and cannot be selected.</div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label><i class="fa-regular fa-user"></i> Full Name</label>
                        <input type="text" name="name" placeholder="e.g. John Doe" value="<%= prefillName %>" required>
                    </div>
                    <div class="form-group">
                        <label><i class="fa-regular fa-envelope"></i> Email</label>
                        <input type="email" name="email" placeholder="john@example.com" value="<%= prefillEmail %>" required>
                    </div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label><i class="fa-regular fa-phone"></i> Phone Number</label>
                        <input type="tel" name="phone" placeholder="e.g. 9876543210" value="<%= prefillPhone %>" required>
                    </div>
                    <div class="form-group">
                        <label><i class="fa-regular fa-location-dot"></i> Address</label>
                        <input type="text" name="address" placeholder="City, State" value="<%= prefillAddress %>" required>
                    </div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label><i class="fa-regular fa-calendar-check"></i> Check-In Date</label>
                        <input type="date" name="checkIn" value="<%= prefillCheckIn %>" required min="<%= today %>">
                    </div>
                    <div class="form-group">
                        <label><i class="fa-regular fa-calendar"></i> Check-Out Date</label>
                        <input type="date" name="checkOut" value="<%= prefillCheckOut %>" required min="<%= tomorrow %>">
                    </div>
                </div>
                <button type="submit" class="btn-book">
                    <i class="fa-solid fa-check"></i> Book Now
                </button>
            </form>
        </div>
    <% } %>
    <div class="footer">
        <p>Already have an account? <a href="CustomerLogin.jsp">Customer Login</a> | <a href="Loginindex.jsp">Admin Login</a></p>
        <p style="margin-top:5px;font-size:12px;">© 2026 Royal Palace Hotel.</p>
    </div>
</div>
</body>
</html>