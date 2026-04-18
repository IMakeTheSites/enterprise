/* Name: Mark Wlodawski
   Course: CNT 4714 – Spring 2026 – Project Four
   Assignment title: A Three-Tier Distributed Web-Based Application
   Date: April 27, 2026
*/

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.Properties;

@WebServlet("/DataEntryUserServlet")
public class DataEntryUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String message = "";
        String error = "";
        
        // Parameters from all forms
        String snum = request.getParameter("snum");
        String sname = request.getParameter("sname");
        String status = request.getParameter("status");
        String city = request.getParameter("city");
        String pnum = request.getParameter("pnum");
        String pname = request.getParameter("pname");
        String color = request.getParameter("color");
        String weight = request.getParameter("weight");
        String jnum = request.getParameter("jnum");
        String jname = request.getParameter("jname");
        String numworkers = request.getParameter("numworkers");
        String quantity = request.getParameter("quantity");

        Connection connection = null;

        try {
            Properties properties = new Properties();
            
            // 1. ATTEMPT TO LOAD PROPERTIES (Robust Method)
            InputStream is = getServletContext().getResourceAsStream("/WEB-INF/conf/dataentry.properties");
            
            if (is == null) {
                // Fallback: Try without the leading slash if the first attempt fails
                is = getServletContext().getResourceAsStream("WEB-INF/conf/dataentry.properties");
            }

            if (is == null) {
                throw new Exception("CRITICAL ERROR: properties file not found in /WEB-INF/conf/. Ensure dataentry.properties is physically in that folder.");
            }
            
            properties.load(is);
            is.close();

            // 2. CONNECT TO DATABASE
            String driver = properties.getProperty("db.driver");
            if (driver == null) throw new Exception("Property 'db.driver' is missing in file.");
            
            Class.forName(driver);
            connection = DriverManager.getConnection(
                properties.getProperty("db.url"),
                properties.getProperty("db.user"),
                properties.getProperty("db.password")
            );

            // 3. ROUTING LOGIC
            if (status != null && !status.isEmpty()) {
                // SUPPLIER INSERT (Anna-Frieda)
                String sql = "INSERT INTO suppliers (snum, sname, status, city) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = connection.prepareStatement(sql);
                ps.setString(1, snum);
                ps.setString(2, sname);
                ps.setInt(3, Integer.parseInt(status));
                ps.setString(4, city);
                ps.executeUpdate();
                message = "New supplier record: (" + snum + ", " + sname + ", " + status + ", " + city + ") was successfully entered.";

            } else if (weight != null && !weight.isEmpty()) {
                // PARTS INSERT
                String sql = "INSERT INTO parts (pnum, pname, color, weight, city) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement ps = connection.prepareStatement(sql);
                ps.setString(1, pnum);
                ps.setString(2, pname);
                ps.setString(3, color);
                ps.setInt(4, Integer.parseInt(weight));
                ps.setString(5, city);
                ps.executeUpdate();
                message = "New part record: (" + pnum + ") was successfully entered.";

            } else if (numworkers != null && !numworkers.isEmpty()) {
                // JOBS INSERT
                String sql = "INSERT INTO jobs (jnum, jname, numworkers, city) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = connection.prepareStatement(sql);
                ps.setString(1, jnum);
                ps.setString(2, jname);
                ps.setInt(3, Integer.parseInt(numworkers));
                ps.setString(4, city);
                ps.executeUpdate();
                message = "New job record: (" + jnum + ") was successfully entered.";

            } else if (quantity != null && !quantity.isEmpty()) {
                // SHIPMENTS INSERT
                String sql = "INSERT INTO shipments (snum, pnum, jnum, quantity) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = connection.prepareStatement(sql);
                ps.setString(1, snum);
                ps.setString(2, pnum);
                ps.setString(3, jnum);
                ps.setInt(4, Integer.parseInt(quantity));
                ps.executeUpdate();
                message = "New shipment record was successfully entered.";
            }

        } catch (Exception e) {
            // This will display the actual error message (like "file not found") instead of just "null"
            error = (e.getMessage() != null) ? e.getMessage() : e.toString();
        } finally {
            try { if (connection != null) connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        // 4. RETURN TO JSP
        request.setAttribute("message", message);
        request.setAttribute("error", error);
        request.getRequestDispatcher("/Front-End-Pages/dataEntryHome.jsp").forward(request, response);
    }
}