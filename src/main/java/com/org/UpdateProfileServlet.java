package com.org;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 5,        // 5MB
    maxRequestSize = 1024 * 1024 * 10     // 10MB
)
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("Loginindex.jsp");
            return;
        }

        int userId = Integer.parseInt(request.getParameter("userId"));
        String username = request.getParameter("username");
        String email = request.getParameter("email");

        // 🖼️ Handle Profile Picture Upload
        Part filePart = request.getPart("profilePic");
        String profilePicPath = (String) session.getAttribute("profilePic"); // Old path (if exists)

        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // Create uploads folder if not exists
        }

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = extractFileName(filePart);
            String fileExtension = fileName.substring(fileName.lastIndexOf("."));
            String uniqueFileName = System.currentTimeMillis() + "_" + session.getAttribute("username") + fileExtension;

            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath); // Save file to server

            profilePicPath = "uploads/" + uniqueFileName; // Relative path for DB and JSP
        }

     
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            String sql;
            if (filePart != null && filePart.getSize() > 0) {
          
                sql = "UPDATE users SET username = ?, email = ?, profile_pic = ? WHERE id = ?";
                ps = con.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, profilePicPath);
                ps.setInt(4, userId);
            } else {

                sql = "UPDATE users SET username = ?, email = ? WHERE id = ?";
                ps = con.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setInt(3, userId);
            }

            int rows = ps.executeUpdate();

            if (rows > 0) {

                session.setAttribute("username", username);
                session.setAttribute("email", email);
                if (filePart != null && filePart.getSize() > 0) {
                    session.setAttribute("profilePic", profilePicPath);
                }
                response.sendRedirect("Setting.jsp?profileMsg=success");
            } else {
                response.sendRedirect("Setting.jsp?profileMsg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Setting.jsp?profileMsg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }


    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}