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

@WebServlet("/AccountantUserServlet")
public class AccountantUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String selection = request.getParameter("selection");
        HttpSession session = request.getSession();
        String propFile = (String) session.getAttribute("userProperties");
        
        String message = "";
        String tableHTML = "";

        // Load the Accountant's specific properties
        Properties props = new Properties();
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/conf/" + propFile)) {
            props.load(is);
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            try (Connection conn = DriverManager.getConnection(
                    props.getProperty("db_url"), 
                    props.getProperty("user"), 
                    props.getProperty("password"))) {

                CallableStatement cstmt = null;

                // Determine which stored procedure to call based on button click
                if ("get_max_status".equals(selection)) {
                    cstmt = conn.prepareCall("{call get_maximum_status_of_all_suppliers()}");
                } else if ("get_sum_quantities".equals(selection)) {
                    cstmt = conn.prepareCall("{call get_sum_of_all_quantities()}");
                } else if ("get_total_suppliers".equals(selection)) {
                    cstmt = conn.prepareCall("{call get_total_number_of_suppliers()}");
                } else if ("get_jobs_count".equals(selection)) {
                    cstmt = conn.prepareCall("{call get_total_number_of_jobs()}");
                }

                if (cstmt != null) {
                    boolean hasResults = cstmt.execute();
                    if (hasResults) {
                        ResultSet rs = cstmt.getResultSet();
                        tableHTML = getHTMLTable(rs);
                        message = "Stored procedure executed successfully.";
                    } else {
                        // For procedures that might use OUT parameters instead of ResultSets
                        message = "Procedure executed. No result set returned.";
                    }
                }

                request.setAttribute("message", message);
                request.setAttribute("table", tableHTML);

            }
        } catch (Exception e) {
            request.setAttribute("error", "Error executing stored procedure: " + e.getMessage());
        }

        // Forward back to the accountant home page
        request.getRequestDispatcher("Front-End-Pages/accountantHome.jsp").forward(request, response);
    }

    // Helper method to generate HTML table from ResultSet
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