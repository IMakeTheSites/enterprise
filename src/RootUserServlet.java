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

@WebServlet("/RootUserServlet")
public class RootUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String sql = request.getParameter("sqlCommand");
        if (sql == null) sql = "";
        sql = sql.trim();
        
        HttpSession session = request.getSession();
        
        Properties props = new Properties();
        String message = "";
        String tableHTML = "";
        String propFile = "root.properties";

        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/conf/" + propFile)) {
            props.load(is);
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            try (Connection conn = DriverManager.getConnection(
                    props.getProperty("db_url"), 
                    props.getProperty("user"), 
                    props.getProperty("password"))) {

                Statement stmt = conn.createStatement();

                if (sql.toLowerCase().startsWith("select")) {
                    ResultSet rs = stmt.executeQuery(sql);
                    tableHTML = getHTMLTable(rs);
                } else {
                    int rowsAffected = stmt.executeUpdate(sql);
                    message = "Statement executed successfully. " + rowsAffected + " rows affected.";

                    // Business Logic Trigger
                    if (sql.toLowerCase().contains("shipments")) {
                        String businessSQL = "UPDATE suppliers SET status = status + 5 " +
                                           "WHERE snum IN (SELECT snum FROM shipments WHERE quantity >= 100)";
                        int logicRows = stmt.executeUpdate(businessSQL);
                        if (logicRows > 0) {
                            message += " <br><b>Business Logic Triggered: Supplier status updated.</b>";
                        }
                    }
                }
                
                request.setAttribute("message", message);
                request.setAttribute("table", tableHTML);
                request.setAttribute("sqlCommand", sql);

            }
        } catch (Exception e) {
            request.setAttribute("error", "Database Error: " + e.getMessage());
        }

        request.getRequestDispatcher("Front-End-Pages/rootHome.jsp").forward(request, response);
    }

    // Helper method to build the HTML Table
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