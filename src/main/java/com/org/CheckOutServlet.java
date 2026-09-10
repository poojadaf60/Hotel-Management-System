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

@WebServlet("/CheckOutServlet")
public class CheckOutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("CheckOut.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIdStr = request.getParameter("bookingId");
        int bookingId = 0;
        try {
            bookingId = Integer.parseInt(bookingIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "❌ Invalid Booking ID. Please enter a valid number.");
            request.getRequestDispatcher("CheckOut.jsp").forward(request, response);
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
                request.getRequestDispatcher("CheckOut.jsp").forward(request, response);
                return;
            }

            String bookingStatus = rs.getString("status");
            int roomId = rs.getInt("room_id");
            String roomStatus = rs.getString("room_status");
            String checkInDate = rs.getString("check_in");
            String checkOutDate = rs.getString("check_out");
            String customerId = rs.getString("customer_id");

            if (!"Checked-In".equalsIgnoreCase(bookingStatus)) {
                request.setAttribute("error", "❌ Booking status is '" + bookingStatus + "'. Only 'Checked-In' bookings can be checked out.");
                request.getRequestDispatcher("CheckOut.jsp").forward(request, response);
                return;
            }
            if (!"Booked".equalsIgnoreCase(roomStatus)) {
                request.setAttribute("error", "❌ Room status is '" + roomStatus + "'. Room must be 'Booked' for check-out.");
                request.getRequestDispatcher("CheckOut.jsp").forward(request, response);
                return;
            }

            con.setAutoCommit(false);


            String updateBookingSql = "UPDATE bookings SET status = 'Checked-Out' WHERE booking_id = ?";
            ps = con.prepareStatement(updateBookingSql);
            ps.setInt(1, bookingId);
            int bookingUpdated = ps.executeUpdate();

            
            String updateRoomSql = "UPDATE rooms SET status = 'Available' WHERE room_id = ?";
            ps = con.prepareStatement(updateRoomSql);
            ps.setInt(1, roomId);
            int roomUpdated = ps.executeUpdate();

            if (bookingUpdated > 0 && roomUpdated > 0) {
                con.commit();
                request.setAttribute("bookingId", bookingId);
                request.setAttribute("customerId", customerId);
                request.setAttribute("roomId", roomId);
                request.setAttribute("checkInDate", checkInDate);
                request.setAttribute("checkOutDate", checkOutDate);
                request.getRequestDispatcher("CheckOutSuccess.jsp").forward(request, response);
            } else {
                con.rollback();
                request.setAttribute("error", "❌ Check-Out failed. Please try again.");
                request.getRequestDispatcher("CheckOut.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            request.setAttribute("error", "❌ Database error: " + e.getMessage());
            request.getRequestDispatcher("CheckOut.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}