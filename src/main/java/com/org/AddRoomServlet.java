package com.org;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddRoomServlet")
public class AddRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ Log that servlet is called (for debugging)
        System.out.println("✅ AddRoomServlet doPost() invoked");

        // 2️⃣ Get parameters
        String roomNo = request.getParameter("room_no");
        String roomType = request.getParameter("room_type");
        String floor = request.getParameter("floor");
        String priceStr = request.getParameter("price");
        String status = request.getParameter("status");

        // 3️⃣ Validate all fields (prevent null/empty)
        if (roomNo == null || roomNo.trim().isEmpty() ||
            roomType == null || roomType.trim().isEmpty() ||
            floor == null || floor.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty() ||
            status == null || status.trim().isEmpty()) {

            System.out.println("❌ One or more fields are empty!");
            response.sendRedirect("RoomManagementServlet?msg=error");
            return;
        }

        // 4️⃣ Parse price safely
        double priceVal;
        try {
            priceVal = Double.parseDouble(priceStr.trim());
        } catch (NumberFormatException e) {
            System.out.println("❌ Invalid price format: " + priceStr);
            response.sendRedirect("RoomManagementServlet?msg=error");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // 5️⃣ Get DB connection
            con = DBConnection.getConnection();
            if (con == null) {
                System.out.println("❌ DB Connection returned null!");
                response.sendRedirect("RoomManagementServlet?msg=error");
                return;
            }

            // 6️⃣ Prepare INSERT query
            String sql = "INSERT INTO rooms(room_no, room_type, floor, price, status) VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, roomNo.trim());
            ps.setString(2, roomType.trim());
            ps.setString(3, floor.trim());
            ps.setDouble(4, priceVal);
            ps.setString(5, status.trim());

            // 7️⃣ Execute and check result
            int result = ps.executeUpdate();
            System.out.println("✅ Insert result: " + result);

            if (result > 0) {
                response.sendRedirect("RoomManagementServlet?msg=success");
            } else {
                // Should not happen, but just in case
                response.sendRedirect("RoomManagementServlet?msg=error");
            }

        } catch (SQLException e) {
            // 8️⃣ Catch SQL exceptions (e.g., duplicate entry, constraint violation)
            e.printStackTrace();
            System.out.println("❌ SQL Error: " + e.getMessage());
            // Optionally, check for duplicate key
            if (e.getErrorCode() == 1062) { // MySQL duplicate entry
                response.sendRedirect("RoomManagementServlet?msg=duplicate");
            } else {
                response.sendRedirect("RoomManagementServlet?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ General Error: " + e.getMessage());
            response.sendRedirect("RoomManagementServlet?msg=error");
        } finally {
            // 9️⃣ Close resources safely
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}