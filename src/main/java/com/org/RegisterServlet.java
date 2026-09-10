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

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            response.getWriter().println(
                "<script>alert('Password and Confirm Password do not match!');history.back();</script>");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection(); // ✅ Reuse DBConnection

            // Check if email already exists
            String checkSql = "SELECT * FROM users WHERE email = ?";
            ps = con.prepareStatement(checkSql);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                response.getWriter().println(
                    "<script>alert('Email already registered!');window.location='Loginindex.jsp';</script>");
                return;
            }
            rs.close();
            ps.close();

            // Insert new user
            String insertSql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
            ps = con.prepareStatement(insertSql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password); // ⚠️ Still plain text – recommended to hash

            int row = ps.executeUpdate();

            if (row > 0) {
                response.sendRedirect("Loginindex.jsp?msg=registered");
            } else {
                response.getWriter().println(
                    "<script>alert('Registration Failed! Please try again.');history.back();</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h2 style='color:red'>Error: " + e.getMessage() + "</h2>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}