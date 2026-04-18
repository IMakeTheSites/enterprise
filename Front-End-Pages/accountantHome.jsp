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
    <title>CNT 4714 Spring 2026 - Project 4 Enterprise System</title>
    <style>
        body { font-family: sans-serif; background-color: #7f8c8d; color: white; padding: 20px; }
        .info-box { text-align: center; margin: 25px 0; font-size: 1.1rem; }
        .options-list { list-style-type: disc; margin-left: 25%; margin-bottom: 20px; line-height: 2.5; }
        .options-list li { font-size: 1.1rem; }
        .blue-text { color: #3366ff; font-weight: bold; text-decoration: underline; }

        .button-section { text-align: center; margin-top: 20px; }
        .btn-execute { background-color: #4B5320; color: #00ff00; border: 2px solid white; padding: 8px 15px; font-weight: bold; cursor: pointer; }
        .btn-clear { background-color: #4B5320; color: #ffff00; border: 2px solid white; padding: 8px 15px; font-weight: bold; cursor: pointer; margin-left: 10px; }
        
        .divider-line { text-align: center; background-color: black; padding: 10px; border-top: 2px solid white; margin-top: 20px; font-weight: bold; }
        
        /* Table Styling */
        table { border-collapse: collapse; margin: 20px auto; min-width: 300px; }
        th, td { border: 1px solid white; padding: 10px; text-align: center; color: black; }
        th { background-color: red; font-weight: bold; }
        td { background-color: #cccccc; font-weight: bold; }
        .error-msg { color: red; font-weight: bold; text-align: center; background-color: black; padding: 10px; }
    </style>
</head>
<body>

    <div class="info-box">
        Welcome to the Spring 2026 Project 4 Enterprise System<br>
        A Servlet/JSP-based Multi-tiered Enterprise Application Using A Tomcat Container<br><br>
        You are connected to the Project 4 Enterprise System database as an <span style="color: #00d4ff; font-weight: bold;">accountant-level</span> user.<br>
        Please select the operation you would like to perform from the list below.
    </div>

    <form action="${pageContext.request.contextPath}/AccountantUserApp" method="POST">
        <ul class="options-list">
            <li><input type="radio" name="selection" value="get_max_status" checked> <span class="blue-text">Get The Maximum Status Value Of All Suppliers</span> (Returns a maximum value)</li>
            <li><input type="radio" name="selection" value="get_sum_quantities"> <span class="blue-text">Get The Total Sum Of All Quantities</span> (Returns a sum)</li>
            <li><input type="radio" name="selection" value="get_total_suppliers"> <span class="blue-text">Get The Total Number Of Suppliers</span> (Returns the current number of suppliers in total)</li>
            <li><input type="radio" name="selection" value="get_jobs_count"> <span class="blue-text">Get The Total Number Of Jobs</span> (Returns the current number of jobs in total)</li>
            <li><input type="radio" name="selection" value="get_all_suppliers_list"> <span class="blue-text">List The Name And Status Of Every Supplier</span> (Returns a list of supplier names with their current status)</li>
        </ul>

        <div class="button-section">
            <button type="submit" class="btn-execute">Execute Command</button>
            <button type="button" class="btn-clear" onclick="window.location.href=window.location.href">Clear Results</button>
        </div>
    </form>

    <div class="divider-line">
        All execution results will appear below this line.
    </div>

    <div id="results" style="background-color: black; padding: 20px; border-bottom: 2px solid white;">
        <h3 style="text-align: center; margin-top: 0;">Execution Results:</h3>
        
        <% if (request.getAttribute("error") != null) { %>
            <p class="error-msg"><%= request.getAttribute("error") %></p>
        <% } %>

        <div style="text-align: center;">
            <% if (request.getAttribute("table") != null) { %>
                <%= request.getAttribute("table") %>
            <% } %>
        </div>
    </div>

    <p style="text-align: center; margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/authenticate.html" style="color: white; text-decoration: none;">Logout</a>
    </p>

</body>
</html>