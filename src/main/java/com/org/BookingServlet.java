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

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Customer> customers = new ArrayList<>();
        List<Room> rooms = new ArrayList<>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            ps = con.prepareStatement("SELECT customer_id, name FROM customers ORDER BY name");
            rs = ps.executeQuery();
            while (rs.next()) {
                Customer c = new Customer();
                c.setCustomerId(rs.getInt("customer_id"));
                c.setName(rs.getString("name"));
                customers.add(c);
            }
            rs.close();
            ps.close();

            ps = con.prepareStatement("SELECT room_id, room_no, room_type, status FROM rooms ORDER BY room_no");
            rs = ps.executeQuery();
            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomNo(rs.getString("room_no"));
                r.setRoomType(rs.getString("room_type"));
                r.setStatus(rs.getString("status"));
                rooms.add(r);
            }
            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        request.setAttribute("customers", customers);
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("AddBooking.jsp").forward(request, response);
    }

   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String customerIdStr = request.getParameter("customerId");
        String roomIdStr = request.getParameter("roomId");
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        String totalAmountStr = request.getParameter("totalAmount");
        String status = request.getParameter("status");

   
        if (customerIdStr == null || customerIdStr.trim().isEmpty() ||
            roomIdStr == null || roomIdStr.trim().isEmpty() ||
            checkIn == null || checkIn.trim().isEmpty() ||
            checkOut == null || checkOut.trim().isEmpty() ||
            totalAmountStr == null || totalAmountStr.trim().isEmpty() ||
            status == null || status.trim().isEmpty()) {

            request.setAttribute("errorMessage", "❌ All fields are required.");
            request.getRequestDispatcher("AddBooking.jsp").forward(request, response);
            return;
        }

        int customerId, roomId;
        double totalAmount;
        try {
            customerId = Integer.parseInt(customerIdStr);
            roomId = Integer.parseInt(roomIdStr);
            totalAmount = Double.parseDouble(totalAmountStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "❌ Invalid number format.");
            request.getRequestDispatcher("AddBooking.jsp").forward(request, response);
            return;
        }

        if (checkIn.compareTo(checkOut) >= 0) {
            request.setAttribute("errorMessage", "❌ Check-out date must be after check-in date.");
            request.getRequestDispatcher("AddBooking.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);


            String roomCheck = "SELECT status FROM rooms WHERE room_id = ?";
            ps = con.prepareStatement(roomCheck);
            ps.setInt(1, roomId);
            rs = ps.executeQuery();
            if (!rs.next()) {
                request.setAttribute("errorMessage", "❌ Room ID does not exist.");
                request.getRequestDispatcher("AddBooking.jsp").forward(request, response);
                return;
            }
            String roomStatus = rs.getString("status");
            rs.close();
            ps.close();

            if (!"Available".equalsIgnoreCase(roomStatus)) {
                request.setAttribute("errorMessage", "❌ Room is not available (status: " + roomStatus + ").");
                request.getRequestDispatcher("AddBooking.jsp").forward(request, response);
                return;
            }


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
                request.setAttribute("errorMessage", "❌ Room is already booked for the selected dates.");
                request.getRequestDispatcher("AddBooking.jsp").forward(request, response);
                return;
            }


            String sql = "INSERT INTO bookings (customer_id, room_id, check_in, check_out, total_amount, status) VALUES (?,?,?,?,?,?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, customerId);
            ps.setInt(2, roomId);
            ps.setString(3, checkIn);
            ps.setString(4, checkOut);
            ps.setDouble(5, totalAmount);
            ps.setString(6, status);
            int result = ps.executeUpdate();
            ps.close();

            if (result > 0) {
         
                con.commit();
                response.sendRedirect("BookingManagementServlet?msg=success");
            } else {
                con.rollback();
                request.setAttribute("errorMessage", "❌ Failed to create booking.");
                request.getRequestDispatcher("AddBooking.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}

            String errorMsg = e.getMessage();
            if (errorMsg.contains("foreign key constraint")) {
                if (errorMsg.contains("customer_id")) {
                    errorMsg = "❌ Customer ID does not exist. Please add customer first.";
                } else if (errorMsg.contains("room_id")) {
                    errorMsg = "❌ Room ID does not exist. Please add room first.";
                } else {
                    errorMsg = "❌ Foreign key violation. Check customer/room IDs.";
                }
            } else {
                errorMsg = "❌ Database error: " + errorMsg;
            }
            request.setAttribute("errorMessage", errorMsg);
            request.getRequestDispatcher("AddBooking.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}