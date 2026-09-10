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

@WebServlet("/CustomerRegisterServlet")
public class CustomerRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("CustomerRegister.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            // Check if email already exists
            ps = con.prepareStatement("SELECT customer_id FROM customers WHERE email = ?");
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                request.setAttribute("error", "Email already registered. Please login.");
                request.getRequestDispatcher("CustomerRegister.jsp").forward(request, response);
                return;
            }
            rs.close();
            ps.close();

            // Insert new customer
            ps = con.prepareStatement(
                "INSERT INTO customers (name, email, phone, address, password) VALUES (?, ?, ?, ?, ?)",
                PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, address);
            ps.setString(5, password);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                // ✅ Registration success – Login page par redirect with context path
                response.sendRedirect(request.getContextPath() + "/CustomerLogin.jsp?msg=registered");
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("CustomerRegister.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("CustomerRegister.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}