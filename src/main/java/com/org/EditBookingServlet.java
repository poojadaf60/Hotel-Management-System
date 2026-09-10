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

@WebServlet("/EditBookingServlet")
public class EditBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            int bookingId = Integer.parseInt(request.getParameter("id"));

            con = DBConnection.getConnection();

           
            String sql = "SELECT * FROM bookings WHERE booking_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();

            if (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setCustomerId(rs.getInt("customer_id"));
                booking.setRoomId(rs.getInt("room_id"));
                booking.setCheckIn(rs.getString("check_in"));
                booking.setCheckOut(rs.getString("check_out"));
                booking.setTotalAmount(rs.getDouble("total_amount"));
                booking.setStatus(rs.getString("status"));
                request.setAttribute("booking", booking);
            } else {
                response.sendRedirect("BookingManagementServlet");
                return;
            }
            rs.close();
            ps.close();

        
            List<Customer> customers = new ArrayList<>();
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

           
            List<Room> rooms = new ArrayList<>();
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

            request.setAttribute("customers", customers);
            request.setAttribute("rooms", rooms);

            request.getRequestDispatcher("EditBooking.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("BookingManagementServlet");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}