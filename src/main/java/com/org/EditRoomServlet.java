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

@WebServlet("/EditRoomServlet")
public class EditRoomServlet extends HttpServlet {
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
            // ✅ FIX: use room_id
            ps = con.prepareStatement("SELECT * FROM rooms WHERE room_id = ?");
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("id", rs.getInt("room_id"));
                request.setAttribute("roomNo", rs.getString("room_no"));
                request.setAttribute("roomType", rs.getString("room_type"));
                request.setAttribute("floor", rs.getString("floor"));
                request.setAttribute("price", rs.getDouble("price"));
                request.setAttribute("status", rs.getString("status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("RoomManagementServlet?msg=error");
            return;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        request.getRequestDispatcher("EditRoom.jsp").forward(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String roomNo = request.getParameter("roomNo");
        String roomType = request.getParameter("roomType");
        String floor = request.getParameter("floor");
        double price = Double.parseDouble(request.getParameter("price"));
        String status = request.getParameter("status");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
           
            ps = con.prepareStatement(
                    "UPDATE rooms SET room_no=?, room_type=?, floor=?, price=?, status=? WHERE room_id = ?");

            ps.setString(1, roomNo);
            ps.setString(2, roomType);
            ps.setString(3, floor);
            ps.setDouble(4, price);
            ps.setString(5, status);
            ps.setInt(6, id);

            int i = ps.executeUpdate();

            if (i > 0) {
                response.sendRedirect("RoomManagementServlet?msg=updated");
            } else {
                response.sendRedirect("RoomManagementServlet?msg=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("RoomManagementServlet?msg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}