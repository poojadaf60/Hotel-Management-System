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

@WebServlet("/UpdateBookingServlet")
public class UpdateBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String checkIn = request.getParameter("checkIn");
            String checkOut = request.getParameter("checkOut");
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            String newStatus = request.getParameter("status");

            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Get old status and room_id
            String selectSql = "SELECT status, room_id FROM bookings WHERE booking_id = ?";
            ps = con.prepareStatement(selectSql);
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();
            if (!rs.next()) {
                response.sendRedirect("BookingManagementServlet?msg=error");
                return;
            }
            String oldStatus = rs.getString("status");
            int oldRoomId = rs.getInt("room_id");
            rs.close();
            ps.close();

            // Update booking
            String updateSql = "UPDATE bookings SET customer_id=?, room_id=?, check_in=?, check_out=?, total_amount=?, status=? WHERE booking_id=?";
            ps = con.prepareStatement(updateSql);
            ps.setInt(1, customerId);
            ps.setInt(2, roomId);
            ps.setString(3, checkIn);
            ps.setString(4, checkOut);
            ps.setDouble(5, totalAmount);
            ps.setString(6, newStatus);
            ps.setInt(7, bookingId);
            int rows = ps.executeUpdate();
            ps.close();

            if (rows == 0) {
                con.rollback();
                response.sendRedirect("EditBookingServlet?id=" + bookingId + "&msg=error");
                return;
            }

            // Determine room status based on new booking status
            String roomStatus = null;
            if ("Cancelled".equalsIgnoreCase(newStatus) || "Checked-Out".equalsIgnoreCase(newStatus)) {
                roomStatus = "Available";
            } else if ("Checked-In".equalsIgnoreCase(newStatus)) {
                roomStatus = "Booked";
            } else { // Confirmed or Pending
                roomStatus = "Booked";
            }

            // Handle room change
            if (oldRoomId != roomId) {
                // Free old room
                String freeOld = "UPDATE rooms SET status = 'Available' WHERE room_id = ? AND status = 'Booked'";
                ps = con.prepareStatement(freeOld);
                ps.setInt(1, oldRoomId);
                ps.executeUpdate();
                ps.close();

                // Book new room if needed
                if ("Booked".equals(roomStatus) || "Confirmed".equalsIgnoreCase(newStatus) || "Pending".equalsIgnoreCase(newStatus)) {
                    String bookNew = "UPDATE rooms SET status = 'Booked' WHERE room_id = ?";
                    ps = con.prepareStatement(bookNew);
                    ps.setInt(1, roomId);
                    ps.executeUpdate();
                    ps.close();
                }
            } else {
                // Same room – update its status
                String updateRoom = "UPDATE rooms SET status = ? WHERE room_id = ?";
                ps = con.prepareStatement(updateRoom);
                ps.setString(1, roomStatus);
                ps.setInt(2, roomId);
                ps.executeUpdate();
                ps.close();
            }

            con.commit();
            response.sendRedirect("BookingManagementServlet?msg=updated");

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            response.sendRedirect("BookingManagementServlet?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}