package com.org;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeletePaymentServlet")
public class DeletePaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int paymentId = Integer.parseInt(request.getParameter("id"));

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("DELETE FROM payments WHERE payment_id = ?");
            ps.setInt(1, paymentId);
            int row = ps.executeUpdate();
            if (row > 0) {
                response.sendRedirect("PaymentManagementServlet?msg=deleted");
            } else {
                response.sendRedirect("PaymentManagementServlet?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("PaymentManagementServlet?msg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}