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

@WebServlet("/EditPaymentServlet")
public class EditPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int paymentId = Integer.parseInt(request.getParameter("id"));

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM payments WHERE payment_id = ?");
            ps.setInt(1, paymentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setBookingId(rs.getInt("booking_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setPaymentDate(rs.getString("payment_date"));
                p.setStatus(rs.getString("status"));
                request.setAttribute("payment", p);
                request.getRequestDispatcher("EditPayment.jsp").forward(request, response);
            } else {
                response.sendRedirect("PaymentManagementServlet?msg=notfound");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("PaymentManagementServlet?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}