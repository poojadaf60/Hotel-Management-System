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

@WebServlet("/DeleteCustomerServlet")
public class DeleteCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

  
            String checkSql = "SELECT COUNT(*) FROM bookings WHERE customer_id = ?";
            ps = con.prepareStatement(checkSql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {

                response.sendRedirect("CustomerManagementServlet?msg=error&reason=customer_has_bookings");
                return;
            }
            rs.close();
            ps.close();


            ps = con.prepareStatement("DELETE FROM customers WHERE customer_id = ?");
            ps.setInt(1, id);
            int row = ps.executeUpdate();

            if (row > 0) {
                response.sendRedirect("CustomerManagementServlet?msg=deleted");
            } else {
                response.sendRedirect("CustomerManagementServlet?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CustomerManagementServlet?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}