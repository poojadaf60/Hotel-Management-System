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

@WebServlet("/ViewPaymentsByBookingServlet")
public class ViewPaymentsByBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        ArrayList<Payment> payments = new ArrayList<>();
        double totalPaid = 0;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();


            String sql = "SELECT * FROM payments WHERE booking_id = ? ORDER BY payment_date DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setBookingId(rs.getInt("booking_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setPaymentDate(rs.getString("payment_date"));
                p.setStatus(rs.getString("status"));
                payments.add(p);

                if ("Paid".equalsIgnoreCase(p.getStatus())) {
                    totalPaid += p.getAmount();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        request.setAttribute("bookingId", bookingId);
        request.setAttribute("payments", payments);
        request.setAttribute("totalPaid", totalPaid);

        request.getRequestDispatcher("ViewPaymentsByBooking.jsp").forward(request, response);
    }
}