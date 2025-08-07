<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Progress Tracker</title>
    <link rel="stylesheet" href="styles.css">
    <script>
        function hideMessage() {
            const message = document.querySelector('.success-message');
            if (message) {
                setTimeout(() => {
                    message.style.display = 'none';
                }, 1000);
            }
        }
        document.addEventListener("DOMContentLoaded", hideMessage);
    </script>
    <style>
        .completed-task {
            color: #4CAF50;
            text-decoration: line-through;
        }
        .task-description {
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>Daily Progress Tracker</h1>
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/RedirectToTasksServlet" class="view-button">View Progress</a>
        </div>
    </div>

    <% if (request.getSession().getAttribute("message") != null) { %>
    <div class="success-message">
        <%= request.getSession().getAttribute("message") %>
    </div>
    <% request.getSession().removeAttribute("message"); %>
    <% } %>

    <% if (request.getSession().getAttribute("error") != null) { %>
    <div class="error-message">
        <%= request.getSession().getAttribute("error") %>
    </div>
    <% request.getSession().removeAttribute("error"); %>
    <% } %>

    <div class="container">
        <div class="left-panel">
            <h2>Add Task</h2>
            <form id="addTaskForm" action="AddTaskServlet" method="POST">
                <div class="add-task">
                    <input type="text" name="description" placeholder="Task Description" required>
                    <input type="date" name="task_date" required>
                    <button type="submit">Add Task</button>
                </div>
            </form>

            <h3>Today's Tasks (<%= new java.util.Date().toLocaleString().split(",")[0] %>)</h3>
            <ul>
                <%
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    java.util.Date today = new java.util.Date();
                    java.sql.Date sqlToday = new java.sql.Date(today.getTime());
            
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/progress_tracker", "root", "PHW#84#jeor");
                        stmt = conn.prepareStatement("SELECT * FROM tasks WHERE task_date = ?");
                        stmt.setDate(1, sqlToday);
                        rs = stmt.executeQuery();
                
                        while (rs.next()) {
                            int taskId = rs.getInt("id");
                            String taskDescription = rs.getString("description");
                            boolean isCompleted = rs.getBoolean("is_completed");
                %>
                <li class="<%= isCompleted ? "completed-task" : "" %>">
                    <form action="UpdateTaskServlet" method="POST" style="display:inline;">
                        <input type="hidden" name="task_id" value="<%= taskId %>">
                        <input type="hidden" name="is_completed" value="true">
                        <input type="checkbox" name="is_completed" <%= isCompleted ? "checked" : "" %> disabled>
                        <span class="task-description" onclick="this.parentNode.submit();"><%= taskDescription %></span>
                    </form>
                </li>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </ul>
        </div>

        <div class="right-panel">
            <h2>Calendar</h2>
            <div id="calendar"></div>
        </div>
    </div>

    <div class="progress-summary">
        <h2>Today's Progress Summary</h2>
        <%
            int totalTasks = 0;
            int completedTasks = 0;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/progress_tracker", "root", "PHW#84#jeor");
                stmt = conn.prepareStatement("SELECT COUNT(*) AS total, SUM(CASE WHEN is_completed AND task_date = ? THEN 1 ELSE 0 END) AS completed FROM tasks WHERE task_date = ?");
                stmt.setDate(1, sqlToday);
                stmt.setDate(2, sqlToday);
                rs = stmt.executeQuery();
                if (rs.next()) {
                    totalTasks = rs.getInt("total");
                    completedTasks = rs.getInt("completed");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            double progressRate = totalTasks > 0 ? (double) completedTasks / totalTasks * 100 : 0;
        %>
        <p>Total Tasks: <%= totalTasks %></p>
        <p>Completed Tasks: <%= completedTasks %></p>
        <p>Progress Rate: <%= String.format("%.2f", progressRate) %> %</p>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const calendarElement = document.getElementById("calendar");
            const date = new Date();
            renderCalendar(date);

            function renderCalendar(date) {
                calendarElement.innerHTML = "";
                const month = date.getMonth();
                const year = date.getFullYear();
                const today = date.getDate();
                const firstDay = new Date(year, month, 1);
                const lastDay = new Date(year, month + 1, 0);

                const daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
                daysOfWeek.forEach(day => {
                    const dayElement = document.createElement("div");
                    dayElement.textContent = day;
                    dayElement.className = "day-header";
                    calendarElement.appendChild(dayElement);
                });

                for (let i = 0; i < firstDay.getDay(); i++) {
                    const emptyDay = document.createElement("div");
                    emptyDay.className = "day empty";
                    calendarElement.appendChild(emptyDay);
                }

                for (let i = 1; i <= lastDay.getDate(); i++) {
                    const dayElement = document.createElement("div");
                    dayElement.textContent = i;
                    dayElement.className = "day";
                    if (i === today) {
                        dayElement.classList.add("today");
                    }
                    calendarElement.appendChild(dayElement);
                }
            }
        });
    </script>
</body>
</html>