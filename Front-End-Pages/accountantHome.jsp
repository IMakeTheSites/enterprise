<%-- 
 Name: Mark Wlodawski
 Course: CNT 4714 – Spring 2026 – Project Four
 Assignment title: A Three-Tier Distributed Web-Based Application
 Date: April 27, 2026
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CNT 4714 - Enterprise System - Accountant</title>
    <style>
        body { font-family: sans-serif; background-color: #e8eff1; padding: 20px; }
        .header { color: #2c3e50; text-align: center; }
        .container { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); max-width: 900px; margin: auto; }
        .stored-procedures { display: flex; flex-direction: column; gap: 10px; margin-bottom: 20px; }
        button { padding: 10px; background-color: #34495e; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 1rem; }
        button:hover { background-color: #2c3e50; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #bdc3c7; padding: 12px; text-align: center; }
        th { background-color: #2980b9; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
    </style>
</head>
<body>

    <h1 class="header">Enterprise System - Accountant Portal</h1>
    
    <div class="container">
        <p>Select a stored procedure to execute against the database:</p>
        
        <form action="../AccountantUserServlet" method="POST" class="stored-procedures">
            <button type="submit" name="selection" value="get_max_status">
                Get Maximum Status of All Suppliers
            </button>
            <button type="submit" name="selection" value="get_sum_quantities">
                Get Total Sum of All Shipments Quantities
            </button>
            <button type="submit" name="selection" value="get_total_suppliers">
                Get Total Number of Suppliers
            </button>
            <button type="submit" name="selection" value="get_jobs_count">
                Get Total Number of Jobs
            </button>
        </form>

        <hr>

        <%-- Result Display Area --%>
        <div id="results">
            <% if (request.getAttribute("message") != null) { %>
                <p><strong>Status:</strong> <%= request.getAttribute("message") %></p>
            <% } %>

            <% if (request.getAttribute("table") != null) { %>
                <%= request.getAttribute("table") %>
            <% } %>
        </div>

        <br>
        <div style="text-align:center;">
            <a href="../authenticate.html" style="color: #7f8c8d;">Logout</a>
        </div>
    </div>

</body>
</html>