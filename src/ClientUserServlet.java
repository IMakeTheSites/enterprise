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

@WebServlet("/ClientUserApp")
public class ClientUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Search term from the JSP
        String searchQuery = request.getParameter("searchQuery");

        // Hardcode the properties file to avoid "inStream is null" errors
        String propFile = "client.properties";
        
        String tableHTML = "";
        String message = "";

        Properties props = new Properties();
        String path = "/WEB-INF/conf/" + propFile;        

        // Load Client specific properties
        try (InputStream is = getServletContext().getResourceAsStream(path)) {
            if (is == null) {
                throw new Exception("File not found at: " + path);
            }
            props.load(is);
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            try (Connection conn = DriverManager.getConnection(
                    props.getProperty("db_url"), 
                    props.getProperty("user"), 
                    props.getProperty("password"))) {

                // Get the SQL
                String sql = searchQuery.trim();

                // Statement
                Statement stmt = conn.createStatement();

                // Check whether it's SELECT or INSERT/UPDATE
                if (sql.toLowerCase().startsWith("select")) {
                    ResultSet rs = stmt.executeQuery(sql);
                    if (rs.isBeforeFirst()) {
                        tableHTML = getHTMLTable(rs);
                    } else {
                        message = "No records found.";
                    }
                } else {
                    // Non-select commands
                    int res = stmt.executeUpdate(sql);
                    message = "Command executed successfully. " + res + " rows affected.";
                }

                request.setAttribute("table", tableHTML);
                request.setAttribute("message", message);
                request.setAttribute("searchQuery", searchQuery); // Send back to keep in input box

            }
        } catch (Exception e) {
            request.setAttribute("error", "Database Error: " + e.getMessage());
        }

        // Back to the client home page
        request.getRequestDispatcher("Front-End-Pages/clientHome.jsp").forward(request, response);
    }

    // Generate HTML table
    private String getHTMLTable(ResultSet rs) throws SQLException {
        ResultSetMetaData rsmd = rs.getMetaData();
        int columnCount = rsmd.getColumnCount();
        StringBuilder html = new StringBuilder("<table><thead><tr>");

        for (int i = 1; i <= columnCount; i++) {
            html.append("<th>").append(rsmd.getColumnName(i)).append("</th>");
        }
        html.append("</tr></thead><tbody>");

        while (rs.next()) {
            html.append("<tr>");
            for (int i = 1; i <= columnCount; i++) {
                html.append("<td>").append(rs.getString(i)).append("</td>");
            }
            html.append("</tr>");
        }
        html.append("</tbody></table>");
        return html.toString();
    }
}