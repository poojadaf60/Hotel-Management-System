package com.org;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("Loginindex.jsp");
            return;
        }

        // Default date range: last 30 days
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        
        if (fromDate == null || fromDate.isEmpty()) {
            // Default to 30 days ago
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.add(java.util.Calendar.DAY_OF_MONTH, -30);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            fromDate = sdf.format(cal.getTime());
        }
        if (toDate == null || toDate.isEmpty()) {
            java.util.Calendar cal = java.util.Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            toDate = sdf.format(cal.getTime());
        }

        // Fetch report data
        List<Booking> bookings = new ArrayList<>();
        double totalRevenue = 0;
        int totalBookings = 0;
        int totalCustomers = 0;
        int totalRooms = 0;
        int availableRooms = 0;
        int bookedRooms = 0;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            // 1️⃣ Total Bookings in date range
            String sqlBookings = "SELECT * FROM bookings WHERE check_in BETWEEN ? AND ? ORDER BY booking_id DESC";
            ps = con.prepareStatement(sqlBookings);
            ps.setString(1, fromDate);
            ps.setString(2, toDate);
            rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setCustomerId(rs.getInt("customer_id"));
                b.setRoomId(rs.getInt("room_id"));
                b.setCheckIn(rs.getString("check_in"));
                b.setCheckOut(rs.getString("check_out"));
                b.setTotalAmount(rs.getDouble("total_amount"));
                b.setStatus(rs.getString("status"));
                bookings.add(b);
            }
            rs.close();
            ps.close();
            totalBookings = bookings.size();

            // 2️⃣ Total Revenue (sum of amounts from payments)
            String sqlRevenue = "SELECT IFNULL(SUM(amount),0) FROM payments";
            ps = con.prepareStatement(sqlRevenue);
            rs = ps.executeQuery();
            if (rs.next()) {
                totalRevenue = rs.getDouble(1);
            }
            rs.close();
            ps.close();

            // 3️⃣ Total Customers
            String sqlCustomers = "SELECT COUNT(*) FROM customers";
            ps = con.prepareStatement(sqlCustomers);
            rs = ps.executeQuery();
            if (rs.next()) {
                totalCustomers = rs.getInt(1);
            }
            rs.close();
            ps.close();

            // 4️⃣ Room stats
            String sqlRooms = "SELECT COUNT(*) as total, SUM(CASE WHEN status='Available' THEN 1 ELSE 0 END) as available, SUM(CASE WHEN status='Booked' THEN 1 ELSE 0 END) as booked FROM rooms";
            ps = con.prepareStatement(sqlRooms);
            rs = ps.executeQuery();
            if (rs.next()) {
                totalRooms = rs.getInt("total");
                availableRooms = rs.getInt("available");
                bookedRooms = rs.getInt("booked");
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

        // Set attributes for JSP
        request.setAttribute("bookings", bookings);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalRooms", totalRooms);
        request.setAttribute("availableRooms", availableRooms);
        request.setAttribute("bookedRooms", bookedRooms);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);

        request.getRequestDispatcher("Report.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}