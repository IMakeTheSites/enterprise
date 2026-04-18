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
        body { font-family: sans-serif; background-color: #f0f0f0; padding: 20px; text-align: center; }
        .header-main { color: blue; font-size: 2rem; margin-bottom: 5px; }
        .header-sub { color: red; font-size: 1.5rem; margin-bottom: 20px; }
        
        .form-container { border: 1px solid black; padding: 15px; margin-bottom: 25px; background-color: white; display: inline-block; width: 90%; }
        .form-title { text-align: left; font-weight: bold; margin-bottom: 10px; color: #333; }
        
        /* Table-based form layout */
        table.entry-table { border-collapse: collapse; margin: auto; background-color: #f9f9f9; }
        table.entry-table th { border: 1px solid black; background-color: #e0e0e0; padding: 5px 20px; }
        table.entry-table td { border: 1px solid black; padding: 10px; }
        
        input[type="text"], input[type="number"] { width: 120px; padding: 4px; border: 1px solid #777; }
        
        .button-row { margin-top: 15px; display: flex; justify-content: center; gap: 15px; }
        .btn-enter { background-color: #2e7d32; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-clear { background-color: #f44336; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; font-weight: bold; }
        
        .results-section { margin-top: 30px; border-top: 2px solid black; padding-top: 20px; }
        .message { color: green; font-weight: bold; font-size: 1.1rem; }
        .error { color: red; font-weight: bold; font-size: 1.1rem; }
    </style>
</head>
<body>

    <h1 class="header-main">Welcome to the Spring 2026 Project 4 Enterprise System</h1>
    <h2 class="header-sub">Data Entry Application</h2>
    <p>Enter the data values in a form below to add a new record to the corresponding database table.</p>

    <div class="form-container">
        <div class="form-title">Suppliers Record Insert</div>
        <form action="${pageContext.request.contextPath}/DataEntryUserServlet" method="POST">
            <table class="entry-table">
                <tr><th>snum</th><th>sname</th><th>status</th><th>city</th></tr>
                <tr>
                    <td><input type="text" name="snum" required></td>
                    <td><input type="text" name="sname" required></td>
                    <td><input type="number" name="status" required></td>
                    <td><input type="text" name="city" required></td>
                </tr>
            </table>
            <div class="button-row">
                <input type="submit" class="btn-enter" value="Enter Supplier Record Into Database">
                <input type="reset" class="btn-clear" value="Clear Data and Results" onclick="clearResults()">
            </div>
        </form>
    </div>

    <div class="form-container">
        <div class="form-title">Parts Record Insert</div>
        <form action="${pageContext.request.contextPath}/DataEntryUserServlet" method="POST">
            <table class="entry-table">
                <tr><th>pnum</th><th>pname</th><th>color</th><th>weight</th><th>city</th></tr>
                <tr>
                    <td><input type="text" name="pnum" required></td>
                    <td><input type="text" name="pname" required></td>
                    <td><input type="text" name="color" required></td>
                    <td><input type="number" name="weight" required></td>
                    <td><input type="text" name="city" required></td>
                </tr>
            </table>
            <div class="button-row">
                <input type="submit" class="btn-enter" value="Enter Part Record Into Database">
                <input type="reset" class="btn-clear" value="Clear Data and Results" onclick="clearResults()">
            </div>
        </form>
    </div>

    <div class="form-container">
        <div class="form-title">Jobs Record Insert</div>
        <form action="${pageContext.request.contextPath}/DataEntryUserServlet" method="POST">
            <table class="entry-table">
                <tr><th>jnum</th><th>jname</th><th>numworkers</th><th>city</th></tr>
                <tr>
                    <td><input type="text" name="jnum" required></td>
                    <td><input type="text" name="jname" required></td>
                    <td><input type="number" name="numworkers" required></td>
                    <td><input type="text" name="city" required></td>
                </tr>
            </table>
            <div class="button-row">
                <input type="submit" class="btn-enter" value="Enter Jobs Record Into Database">
                <input type="reset" class="btn-clear" value="Clear Data and Results" onclick="clearResults()">
            </div>
        </form>
    </div>

    <div class="form-container">
        <div class="form-title">Shipments Record Insert</div>
        <form action="${pageContext.request.contextPath}/DataEntryUserServlet" method="POST">
            <table class="entry-table">
                <tr><th>snum</th><th>pnum</th><th>jnum</th><th>quantity</th></tr>
                <tr>
                    <td><input type="text" name="snum" required></td>
                    <td><input type="text" name="pnum" required></td>
                    <td><input type="text" name="jnum" required></td>
                    <td><input type="number" name="quantity" required></td>
                </tr>
            </table>
            <div class="button-row">
                <input type="submit" class="btn-enter" value="Enter Shipment Record Into Database">
                <input type="reset" class="btn-clear" value="Clear Data and Results" onclick="clearResults()">
            </div>
        </form>
    </div>

    <div class="results-section">
        <h3>Execution Results:</h3>
        <div id="results">
            <div class="message">
                <% if (request.getAttribute("message") != null) { %>
                    <%= request.getAttribute("message") %>
                <% } %>
            </div>
            <div class="error">
                <% if (request.getAttribute("error") != null) { %>
                    <%= request.getAttribute("error") %>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        function clearResults() {
            // Clears the message and error areas when "Clear" is clicked
            document.getElementById('results').innerHTML = '';
        }
    </script>
</body>
</html>