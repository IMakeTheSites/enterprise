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
    <title>CNT 4714 - Enterprise System - Client User</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; padding: 20px; }
        .header-container { text-align: center; color: #2c3e50; margin-bottom: 30px; }
        .main-card { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); max-width: 800px; margin: auto; }
        .search-box { display: flex; flex-direction: column; gap: 15px; margin-bottom: 25px; }
        input[type="text"] { padding: 12px; border: 2px solid #ddd; border-radius: 8px; font-size: 1rem; }
        .button-group { display: flex; gap: 10px; }
        input[type="submit"] { flex: 2; padding: 12px; background-color: #27ae60; color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: bold; }
        input[type="submit"]:hover { background-color: #219150; }
        input[type="reset"] { flex: 1; padding: 12px; background-color: #95a5a6; color: white; border: none; border-radius: 8px; cursor: pointer; }
        
        table { border-collapse: collapse; width: 100%; margin-top: 25px; border-radius: 8px; overflow: hidden; }
        th, td { border: 1px solid #dfe6e9; padding: 12px; text-align: left; }
        th { background-color: #2980b9; color: white; text-transform: uppercase; font-size: 0.9rem; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .msg { padding: 10px; border-radius: 5px; margin-bottom: 15px; }
        .error { background-color: #ffeadb; color: #c0392b; border: 1px solid #fab1a0; }
    </style>
</head>
<body>

    <div class="header-container">
        <h1>Project 4 Enterprise System</h1>
        <h2>Client Information Portal</h2>
    </div>

    <div class="main-card">
        <p>Enter a <strong>Supplier Name</strong> or <strong>Part Number</strong> to retrieve shipment details:</p>
        
        <form action="${pageContext.request.contextPath}/ClientUserApp" method="POST" class="search-box">
            <input type="text" name="searchQuery" placeholder="e.g., Smith or P3" value="${searchQuery}">
            
            <div class="button-group">
                <input type="submit" value="Search Database">
                <input type="reset" value="Clear">
            </div>
        </form>

        <hr>

        <div id="displayArea">
            <%-- Error Handling --%>
            <% if (request.getAttribute("error") != null) { %>
                <div class="msg error">
                    <strong>Query Error:</strong> <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <%-- Results Table --%>
            <% if (request.getAttribute("table") != null) { %>
                <h3>Search Results:</h3>
                <%= request.getAttribute("table") %>
            <% } else if (request.getAttribute("message") != null) { %>
                <p><%= request.getAttribute("message") %></p>
            <% } %>
        </div>

        <div style="margin-top: 30px; text-align: center;">
            <a href="${pageContext.request.contextPath}/authenticate.html" style="text-decoration: none; color: #3498db; font-size: 0.9rem;">&larr; Log out and return to login</a>
        </div>
    </div>

</body>
</html>