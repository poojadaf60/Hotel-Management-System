package com.org;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RoomManagementServlet")
public class RoomManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Room> rooms = new ArrayList<>();
        int available = 0, booked = 0, maintenance = 0;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM rooms");
            rs = ps.executeQuery();

            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomNo(rs.getString("room_no"));
                r.setRoomType(rs.getString("room_type"));
                r.setFloor(rs.getString("floor"));
                r.setPrice(rs.getDouble("price"));
                r.setStatus(rs.getString("status"));
                rooms.add(r);

                String st = r.getStatus();
                if ("Available".equalsIgnoreCase(st)) available++;
                else if ("Booked".equalsIgnoreCase(st)) booked++;
                else if ("Maintenance".equalsIgnoreCase(st)) maintenance++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        request.setAttribute("rooms", rooms);
        request.setAttribute("availableRooms", available);
        request.setAttribute("bookedRooms", booked);
        request.setAttribute("maintenanceRooms", maintenance);

        request.getRequestDispatcher("RoomManagement.jsp").forward(request, response);
    }
}