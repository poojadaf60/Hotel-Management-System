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

@WebServlet("/DeleteRoomServlet")
public class DeleteRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String checkSql = "SELECT COUNT(*) FROM bookings WHERE room_id = ?";
            ps = con.prepareStatement(checkSql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {

                response.sendRedirect("RoomManagementServlet?msg=error&reason=room_has_bookings");
                return;
            }
            rs.close();
            ps.close();


            ps = con.prepareStatement("DELETE FROM rooms WHERE room_id = ?");
            ps.setInt(1, id);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("RoomManagementServlet?msg=deleted");
            } else {
                response.sendRedirect("RoomManagementServlet?msg=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("RoomManagementServlet?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}