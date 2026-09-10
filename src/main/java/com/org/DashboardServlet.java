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

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("Loginindex.jsp");
            return;
        }

        Connection con = null;

        try {

            con = DBConnection.getConnection();

            
            request.setAttribute("totalRooms",
                    getCount(con, "SELECT COUNT(*) FROM rooms"));

           
            request.setAttribute("availableRooms",
                    getCount(con,
                            "SELECT COUNT(*) FROM rooms WHERE status='Available'"));

        
            request.setAttribute("bookedRooms",
                    getCount(con,
                            "SELECT COUNT(*) FROM rooms WHERE status='Booked'"));

      
            request.setAttribute("maintenanceRooms",
                    getCount(con,
                            "SELECT COUNT(*) FROM rooms WHERE status='Maintenance'"));

     
            request.setAttribute("totalCustomers",
                    getCount(con,
                            "SELECT COUNT(*) FROM customers"));

           
            request.setAttribute("totalBookings",
                    getCount(con,
                            "SELECT COUNT(*) FROM bookings"));

        
            PreparedStatement ps = con.prepareStatement(
                    "SELECT IFNULL(SUM(amount),0) FROM payments");

            ResultSet rs = ps.executeQuery();

            double revenue = 0;

            if (rs.next()) {
                revenue = rs.getDouble(1);
            }

            request.setAttribute("totalRevenue", revenue);

            rs.close();
            ps.close();

            request.getRequestDispatcher("AdminDashboard.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().println("Error : " + e.getMessage());

        } finally {

            try {

                if (con != null)
                    con.close();

            } catch (Exception e) {

                e.printStackTrace();

            }

        }
    }

    private int getCount(Connection con, String sql) throws Exception {

        PreparedStatement ps = con.prepareStatement(sql);

        ResultSet rs = ps.executeQuery();

        int count = 0;

        if (rs.next()) {
            count = rs.getInt(1);
        }

        rs.close();
        ps.close();

        return count;
    }
}