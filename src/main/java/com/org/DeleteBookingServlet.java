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

@WebServlet("/DeleteBookingServlet")
public class DeleteBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            int bookingId = Integer.parseInt(request.getParameter("id"));

            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            
            String selectSql = "SELECT room_id FROM bookings WHERE booking_id = ?";
            ps = con.prepareStatement(selectSql);
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();
            if (!rs.next()) {
                response.sendRedirect("BookingManagementServlet?msg=notfound");
                return;
            }
            int roomId = rs.getInt("room_id");
            rs.close();
            ps.close();

            
            String deleteSql = "DELETE FROM bookings WHERE booking_id = ?";
            ps = con.prepareStatement(deleteSql);
            ps.setInt(1, bookingId);
            int rows = ps.executeUpdate();
            ps.close();

            if (rows == 0) {
                con.rollback();
                response.sendRedirect("BookingManagementServlet?msg=error");
                return;
            }


            String updateRoom = "UPDATE rooms SET status = 'Available' WHERE room_id = ? AND status = 'Booked'";
            ps = con.prepareStatement(updateRoom);
            ps.setInt(1, roomId);
            ps.executeUpdate();
            ps.close();

            con.commit();
            response.sendRedirect("BookingManagementServlet?msg=deleted");

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