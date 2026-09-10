package com.org;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CheckInServlet")
public class CheckInServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

  
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("CheckIn.jsp").forward(request, response);
    }

    // Process Check-In
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ Read and validate Booking ID
        String bookingIdStr = request.getParameter("bookingId");
        int bookingId = 0;
        try {
            bookingId = Integer.parseInt(bookingIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "❌ Invalid Booking ID. Please enter a valid number.");
            request.getRequestDispatcher("CheckIn.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();


            String checkSql = "SELECT b.*, r.room_id, r.status AS room_status " +
                              "FROM bookings b " +
                              "JOIN rooms r ON b.room_id = r.room_id " +
                              "WHERE b.booking_id = ?";
            ps = con.prepareStatement(checkSql);
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();

            if (!rs.next()) {
                request.setAttribute("error", "❌ Booking ID " + bookingId + " does not exist.");
                request.getRequestDispatcher("CheckIn.jsp").forward(request, response);
                return;
            }

          
            String bookingStatus = rs.getString("status");
            int roomId = rs.getInt("room_id");
            String roomStatus = rs.getString("room_status");
            String checkInDate = rs.getString("check_in");
            String customerId = rs.getString("customer_id");

  
            if (!"Confirmed".equalsIgnoreCase(bookingStatus)) {
                request.setAttribute("error", "❌ Booking status is '" + bookingStatus + "'. Only 'Confirmed' bookings can be checked in.");
                request.getRequestDispatcher("CheckIn.jsp").forward(request, response);
                return;
            }
            if (!"Available".equalsIgnoreCase(roomStatus)) {
                request.setAttribute("error", "❌ Room status is '" + roomStatus + "'. Room must be 'Available' for check-in.");
                request.getRequestDispatcher("CheckIn.jsp").forward(request, response);
                return;
            }

       
            con.setAutoCommit(false);


            String updateBookingSql = "UPDATE bookings SET status = 'Checked-In' WHERE booking_id = ?";
            ps = con.prepareStatement(updateBookingSql);
            ps.setInt(1, bookingId);
            int bookingUpdated = ps.executeUpdate();


            String updateRoomSql = "UPDATE rooms SET status = 'Booked' WHERE room_id = ?";
            ps = con.prepareStatement(updateRoomSql);
            ps.setInt(1, roomId);
            int roomUpdated = ps.executeUpdate();

           
            if (bookingUpdated > 0 && roomUpdated > 0) {
                con.commit();
                request.setAttribute("bookingId", bookingId);
                request.setAttribute("customerId", customerId);
                request.setAttribute("roomId", roomId);
                request.setAttribute("checkInDate", checkInDate);
                request.getRequestDispatcher("CheckInSuccess.jsp").forward(request, response);
            } else {
                con.rollback();
                request.setAttribute("error", "❌ Check-In failed. Please try again.");
                request.getRequestDispatcher("CheckIn.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            request.setAttribute("error", "❌ Database error: " + e.getMessage());
            request.getRequestDispatcher("CheckIn.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}