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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            if (con == null) {
                response.sendRedirect("Loginindex.jsp?msg=error");
                return;
            }

            // ✅ अब profile_pic कॉलम भी सेलेक्ट कर रहे हैं
            String sql = "SELECT id, username, email, profile_pic FROM users WHERE email=? AND password=?";

            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {

                HttpSession session = request.getSession();

                session.setAttribute("userid", rs.getInt("id"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("profilePic", rs.getString("profile_pic")); // ✅ अब यह काम करेगा

                response.sendRedirect("DashboardServlet");

            } else {

                response.sendRedirect("Loginindex.jsp?msg=invalid");
            }

        } catch (Exception e) {

            e.printStackTrace();
            // अगर कोई और error आता है तो error message के साथ भेजें
            response.sendRedirect("Loginindex.jsp?msg=error");

        } finally {

            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}