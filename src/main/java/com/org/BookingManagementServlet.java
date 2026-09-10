package com.org;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/BookingManagementServlet")
public class BookingManagementServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Booking> bookings = new ArrayList<Booking>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            String sql = "SELECT * FROM bookings ORDER BY booking_id DESC";

            ps = con.prepareStatement(sql);

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

            request.setAttribute("bookings", bookings);

            request.getRequestDispatcher("Booking.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

        } finally {

            try {

                if (rs != null)
                    rs.close();

                if (ps != null)
                    ps.close();

                if (con != null)
                    con.close();

            } catch (Exception e) {

                e.printStackTrace();

            }

        }

    }

}