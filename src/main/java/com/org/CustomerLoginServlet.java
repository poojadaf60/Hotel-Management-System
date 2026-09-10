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
import javax.servlet.http.HttpSession;

@WebServlet("/CustomerLoginServlet")
public class CustomerLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT customer_id, name FROM customers WHERE email = ? AND password = ?");
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("customerId", rs.getInt("customer_id"));
                session.setAttribute("customerName", rs.getString("name"));

                // ✅ If there was a pending booking, redirect back to booking page with context path
                String redirect = (String) session.getAttribute("bookingRedirect");
                if (redirect != null) {
                    session.removeAttribute("bookingRedirect");
                    response.sendRedirect(request.getContextPath() + "/" + redirect);
                } else {
                    response.sendRedirect(request.getContextPath() + "/PublicBookingServlet");
                }
            } else {
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("CustomerLogin.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Login failed. Please try again.");
            request.getRequestDispatcher("CustomerLogin.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}