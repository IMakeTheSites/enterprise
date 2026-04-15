/* Name: Mark Wlodawski
 Course: CNT 4714 – Spring 2026 – Project Four
 Assignment title: A Three-Tier Distributed Web-Based Application
 Date: April 27, 2026
*/

import java.io.*;
import java.sql.*;
import java.util.Properties;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/authenticate")
public class AuthenticationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        
        Properties sysProps = new Properties();
        // Load the systemapp.properties to access the credentials database
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/conf/systemapp.properties")) {
            sysProps.load(is);
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            try (Connection conn = DriverManager.getConnection(sysProps.getProperty("db_url"), 
                                                              sysProps.getProperty("user"), 
                                                              sysProps.getProperty("password"))) {
                
                    String query = "SELECT login_username FROM usercredentials WHERE login_username = ? AND login_password = ?";
                    PreparedStatement pstmt = conn.prepareStatement(query);
                    pstmt.setString(1, user);
                    pstmt.setString(2, pass);
                    ResultSet rs = pstmt.executeQuery();

                    if (rs.next()) {
                        // The username is the role in this project's logic
                        String role = rs.getString("login_username"); 
                        HttpSession session = request.getSession();
                        
                        // Which JSP filename
                        String jspPage;
                        if (role.equals("theaccountant")) {
                            jspPage = "accountantHome.jsp"; 
                        } else {
                            jspPage = role + "Home.jsp"; 
                        }
                        
                        // Which properties file
                        String propFile = role + ".properties";
                        session.setAttribute("userProperties", propFile);
                        
                        response.sendRedirect("Front-End-Pages/" + jspPage);
                    } else {
                        response.sendRedirect("Front-End-Pages/errorpage.html");
                    }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}