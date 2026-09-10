package com.org;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get parameters
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String paymentMethod = request.getParameter("paymentMethod");
        String paymentDate = request.getParameter("paymentDate");   // yyyy-MM-dd
        String status = request.getParameter("status");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO payments (booking_id, amount, payment_method, payment_date, status) " +
                         "VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setDouble(2, amount);
            ps.setString(3, paymentMethod);
            ps.setString(4, paymentDate);
            ps.setString(5, status);

            int row = ps.executeUpdate();

            if (row > 0) {
                response.sendRedirect("PaymentManagementServlet?msg=success");
            } else {
                response.sendRedirect("AddPayment.jsp?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AddPayment.jsp?msg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}