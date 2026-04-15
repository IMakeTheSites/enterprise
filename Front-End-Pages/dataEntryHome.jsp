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
    <title>CNT 4714 - Enterprise System - Data Entry</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #fdfdfd; padding: 20px; }
        .header { color: #e67e22; text-align: center; }
        .entry-container { 
            background: white; 
            padding: 30px; 
            border-radius: 10px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); 
            max-width: 600px; 
            margin: 20px auto; 
            border-top: 5px solid #e67e22;
        }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; }
        input[type="text"] { 
            width: 95%; 
            padding: 10px; 
            border: 1px solid #ddd; 
            border-radius: 5px; 
        }
        .actions { text-align: center; margin-top: 20px; }
        input[type="submit"] { 
            background-color: #e67e22; 
            color: white; 
            padding: 10px 25px; 
            border: none; 
            border-radius: 5px; 
            cursor: pointer; 
            font-size: 1rem;
        }
        input[type="submit"]:hover { background-color: #d35400; }
        .status-msg { 
            text-align: center; 
            margin-top: 20px; 
            padding: 10px; 
            font-weight: bold; 
        }
        .success { color: #27ae60; background-color: #eafaf1; border-radius: 5px; }
        .error { color: #c0392b; background-color: #fdedec; border-radius: 5px; }
    </style>
</head>
<body>

    <h1 class="header">Data Entry Portal</h1>
    
    <div class="entry-container">
        <h3>Enter New Shipment Record</h3>
        <p>Fill out all fields to record a new shipment in the database.</p>
        
        <form action="../DataEntryUserServlet" method="POST">
            <div class="form-group">
                <label for="snum">Supplier Number (snum):</label>
                <input type="text" id="snum" name="snum" placeholder="e.g., S1" required>
            </div>
            
            <div class="form-group">
                <label for="pnum">Part Number (pnum):</label>
                <input type="text" id="pnum" name="pnum" placeholder="e.g., P1" required>
            </div>
            
            <div class="form-group">
                <label for="jnum">Job Number (jnum):</label>
                <input type="text" id="jnum" name="jnum" placeholder="e.g., J1" required>
            </div>
            
            <div class="form-group">
                <label for="quantity">Quantity:</label>
                <input type="text" id="quantity" name="quantity" placeholder="e.g., 100" required>
            </div>

            <div class="actions">
                <input type="submit" value="Enter Record Into Database">
                <input type="reset" value="Clear Form">
            </div>
        </form>

        <%-- Feedback Messages --%>
        <% if (request.getAttribute("message") != null) { %>
            <div class="status-msg success">
                <%= request.getAttribute("message") %>
            </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="status-msg error">
                <strong>Error:</strong> <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <div style="margin-top: 25px; text-align: center; font-size: 0.8rem;">
            <a href="../authenticate.html">Logout</a>
        </div>
    </div>

</body>
</html>