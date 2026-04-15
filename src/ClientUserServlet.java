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

@WebServlet("/ClientUserServlet")
public class ClientUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String searchQuery = request.getParameter("searchQuery");
        HttpSession session = request.getSession();
        String propFile = (String) session.getAttribute("userProperties");
        
        String tableHTML = "";
        String message = "";

        // Load Client specific properties (client.properties)
        Properties props = new Properties();
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/conf/" + propFile)) {
            props.load(is);
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            try (Connection conn = DriverManager.getConnection(
                    props.getProperty("db_url"), 
                    props.getProperty("user"), 
                    props.getProperty("password"))) {

                // We use a PreparedStatement to allow for flexible searching
                // This example searches for shipments by either Supplier Number or Part Number
                String sql = "SELECT * FROM shipments WHERE snum = ? OR pnum = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, searchQuery);
                pstmt.setString(2, searchQuery);
                
                ResultSet rs = pstmt.executeQuery();
                
                // If the ResultSet has data, build the table
                if (rs.isBeforeFirst()) {
                    tableHTML = getHTMLTable(rs);
                } else {
                    message = "No records found matching: " + searchQuery;
                }

                request.setAttribute("table", tableHTML);
                request.setAttribute("message", message);
                request.setAttribute("searchQuery", searchQuery); // Send back to keep in input box

            }
        } catch (Exception e) {
            request.setAttribute("error", "Database Error: " + e.getMessage());
        }

        // Forward back to the client home page
        request.getRequestDispatcher("Front-End-Pages/clientHome.jsp").forward(request, response);
    }

    // Standard helper method to generate HTML table
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