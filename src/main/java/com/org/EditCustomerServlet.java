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

@WebServlet("/EditCustomerServlet")
public class EditCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM customers WHERE customer_id=?");
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                Customer c = new Customer();
                c.setCustomerId(rs.getInt("customer_id"));
                c.setName(rs.getString("name"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setAddress(rs.getString("address"));
                request.setAttribute("customer", c);
                request.getRequestDispatcher("EditCustomer.jsp").forward(request, response);
            } else {
                response.sendRedirect("CustomerManagementServlet?msg=notfound");
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