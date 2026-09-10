package com.org;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdatePaymentServlet")
public class UpdatePaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int paymentId = Integer.parseInt(request.getParameter("paymentId"));
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String paymentMethod = request.getParameter("paymentMethod");
        String paymentDate = request.getParameter("paymentDate");
        String status = request.getParameter("status");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE payments SET booking_id = ?, amount = ?, payment_method = ?, payment_date = ?, status = ? " +
                         "WHERE payment_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setDouble(2, amount);
            ps.setString(3, paymentMethod);
            ps.setString(4, paymentDate);
            ps.setString(5, status);
            ps.setInt(6, paymentId);

            int row = ps.executeUpdate();
            if (row > 0) {
                response.sendRedirect("PaymentManagementServlet?msg=updated");
            } else {
                response.sendRedirect("EditPaymentServlet?id=" + paymentId + "&msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("EditPaymentServlet?id=" + paymentId + "&msg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}