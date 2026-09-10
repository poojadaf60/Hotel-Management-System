package com.org;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/PublicBookingServlet")
public class PublicBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ✅ अगर customer logged in नहीं है → Register page पर भेजो (with context path)
        Integer customerId = (session != null) ? (Integer) session.getAttribute("customerId") : null;
        if (customerId == null) {
            if (session == null) session = request.getSession();
            session.setAttribute("bookingRedirect", "PublicBookingServlet");
            response.sendRedirect(request.getContextPath() + "/CustomerRegister.jsp");
            return;
        }

        // ✅ अब customer logged in है – pending booking data को pre‑fill करो
        Map<String, String[]> pending = (Map<String, String[]>) session.getAttribute("pendingBooking");
        if (pending != null) {
            request.setAttribute("prefill_name", pending.get("name")[0]);
            request.setAttribute("prefill_email", pending.get("email")[0]);
            request.setAttribute("prefill_phone", pending.get("phone")[0]);
            request.setAttribute("prefill_address", pending.get("address")[0]);
            request.setAttribute("prefill_checkIn", pending.get("checkIn")[0]);
            request.setAttribute("prefill_checkOut", pending.get("checkOut")[0]);
        }

        // Rooms लोड करें
        List<Room> allRooms = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT room_id, room_no, room_type, price, status FROM rooms ORDER BY room_no");
            rs = ps.executeQuery();
            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomNo(rs.getString("room_no"));
                r.setRoomType(rs.getString("room_type"));
                r.setPrice(rs.getDouble("price"));
                r.setStatus(rs.getString("status"));
                allRooms.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        request.setAttribute("allRooms", allRooms);
        request.getRequestDispatcher("PublicBooking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer customerId = (session != null) ? (Integer) session.getAttribute("customerId") : null;

        // ✅ अगर logged in नहीं → डेटा सेशन में सेव करके Register page पर भेजो (with context path)
        if (customerId == null) {
            if (session == null) session = request.getSession();
            session.setAttribute("pendingBooking", request.getParameterMap());
            session.setAttribute("bookingRedirect", "PublicBookingServlet");
            response.sendRedirect(request.getContextPath() + "/CustomerRegister.jsp");
            return;
        }

        // ---- अब logged in है – Booking Create करें ----
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String roomIdStr = request.getParameter("roomId");
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");

        // Validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            address == null || address.trim().isEmpty() ||
            roomIdStr == null || roomIdStr.trim().isEmpty() ||
            checkIn == null || checkIn.trim().isEmpty() ||
            checkOut == null || checkOut.trim().isEmpty()) {

            request.setAttribute("errorMsg", "❌ All fields are required.");
            doGet(request, response);
            return;
        }

        int roomId;
        try {
            roomId = Integer.parseInt(roomIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "❌ Invalid room selection.");
            doGet(request, response);
            return;
        }

        if (checkIn.compareTo(checkOut) >= 0) {
            request.setAttribute("errorMsg", "❌ Check-out date must be after check-in date.");
            doGet(request, response);
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Room availability check
            String roomStatusSql = "SELECT status FROM rooms WHERE room_id = ?";
            ps = con.prepareStatement(roomStatusSql);
            ps.setInt(1, roomId);
            rs = ps.executeQuery();
            if (!rs.next()) {
                request.setAttribute("errorMsg", "❌ Room does not exist.");
                doGet(request, response);
                return;
            }
            String roomStatus = rs.getString("status");
            rs.close();
            ps.close();

            if (!"Available".equalsIgnoreCase(roomStatus)) {
                request.setAttribute("errorMsg", "❌ Sorry, this room is already occupied. Please select an Available room.");
                doGet(request, response);
                return;
            }

            // Update customer info
            String updateCustomerSql = "UPDATE customers SET name=?, phone=?, address=? WHERE customer_id=?";
            ps = con.prepareStatement(updateCustomerSql);
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setInt(4, customerId);
            ps.executeUpdate();
            ps.close();

            // Overlap check
            String overlapSql = "SELECT COUNT(*) FROM bookings WHERE room_id = ? AND status IN ('Confirmed', 'Checked-In') " +
                                "AND NOT (check_out <= ? OR check_in >= ?)";
            ps = con.prepareStatement(overlapSql);
            ps.setInt(1, roomId);
            ps.setString(2, checkIn);
            ps.setString(3, checkOut);
            rs = ps.executeQuery();
            rs.next();
            int overlapCount = rs.getInt(1);
            rs.close();
            ps.close();

            if (overlapCount > 0) {
                con.rollback();
                request.setAttribute("errorMsg", "❌ Room is already booked for the selected dates.");
                doGet(request, response);
                return;
            }

            // Total amount calculate
            double totalAmount = 0;
            String getPriceSql = "SELECT price FROM rooms WHERE room_id = ?";
            ps = con.prepareStatement(getPriceSql);
            ps.setInt(1, roomId);
            rs = ps.executeQuery();
            if (rs.next()) {
                double pricePerNight = rs.getDouble("price");
                LocalDate inDate = LocalDate.parse(checkIn);
                LocalDate outDate = LocalDate.parse(checkOut);
                long days = ChronoUnit.DAYS.between(inDate, outDate);
                totalAmount = pricePerNight * days;
            }
            rs.close();
            ps.close();

            // Insert booking
            String insertBookingSql = "INSERT INTO bookings (customer_id, room_id, check_in, check_out, total_amount, status) VALUES (?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(insertBookingSql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, customerId);
            ps.setInt(2, roomId);
            ps.setString(3, checkIn);
            ps.setString(4, checkOut);
            ps.setDouble(5, totalAmount);
            ps.setString(6, "Confirmed");
            int bookingInserted = ps.executeUpdate();

            if (bookingInserted == 0) {
                con.rollback();
                request.setAttribute("errorMsg", "❌ Failed to insert booking.");
                doGet(request, response);
                return;
            }

            int bookingId = 0;
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                bookingId = rs.getInt(1);
            }
            rs.close();
            ps.close();

            con.commit();

            // Room number for WhatsApp
            String roomNo = "";
            PreparedStatement psRoom = con.prepareStatement("SELECT room_no FROM rooms WHERE room_id = ?");
            psRoom.setInt(1, roomId);
            ResultSet rsRoom = psRoom.executeQuery();
            if (rsRoom.next()) {
                roomNo = rsRoom.getString("room_no");
            }
            rsRoom.close();
            psRoom.close();

            // ✅ EMAIL SENDING REMOVED – अब EmailUtil का उपयोग नहीं होगा

            // WhatsApp link
            String hotelWhatsAppNumber = "919370482836";
            String hotelName = "Royal Palace Hotel";
            String whatsappMessage = "Hi, I have successfully booked a room at " + hotelName + "." +
                                     "%0AMy Booking ID is: " + bookingId +
                                     "%0ACustomer Name: " + name +
                                     "%0APhone: " + phone +
                                     "%0ACheck-In: " + checkIn +
                                     "%0ACheck-Out: " + checkOut +
                                     "%0ATotal Amount: ₹" + totalAmount;
            String encodedMessage = URLEncoder.encode(whatsappMessage, StandardCharsets.UTF_8.name());
            String whatsappLink = "https://wa.me/" + hotelWhatsAppNumber + "?text=" + encodedMessage;

            // ✅ Booking success – pending booking data ko session se हटाओ
            if (session != null) {
                session.removeAttribute("pendingBooking");
                session.removeAttribute("bookingRedirect");
            }

            // Success attributes
            request.setAttribute("successMsg", "✅ Booking Successful!");
            request.setAttribute("bookingId", bookingId);
            request.setAttribute("whatsappLink", whatsappLink);
            request.setAttribute("customerName", name);
            request.setAttribute("checkIn", checkIn);
            request.setAttribute("checkOut", checkOut);
            request.setAttribute("totalAmount", totalAmount);

            doGet(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            request.setAttribute("errorMsg", "❌ Database error: " + e.getMessage());
            doGet(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}