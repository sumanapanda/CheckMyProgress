<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Tasks</title>
        <link rel="stylesheet" href="view.css">
    </head>
    <body>
        <div class="header">
            <h1>Tasks for <%= request.getParameter("task_date") != null ? 
                new SimpleDateFormat("dd-MM-yyyy").format(
                    new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("task_date"))
                ) : "Selected Date" %>
            </h1>
            <a href="index.jsp" class="back-btn">Back to Dashboard</a>
        </div>


        <div class="task-container">
            <%
            String dateParam = request.getParameter("task_date");
            if (dateParam == null || dateParam.isEmpty()) {
                out.println("<p>No date specified</p>");
            } else {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    try (Connection conn = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/progress_tracker", "root", "PHW#84#jeor");
                         PreparedStatement stmt = conn.prepareStatement(
                            "SELECT * FROM tasks WHERE task_date = ? ORDER BY is_completed")) {
            
                        stmt.setString(1, dateParam);
                        ResultSet rs = stmt.executeQuery();
            
                        while (rs.next()) {
                            String taskDescription = rs.getString("description");
                            boolean isCompleted = rs.getBoolean("is_completed");
                            double progressPercentage = isCompleted ? 100.0 : 0.0;
            %>
            <div class="task-card <%= isCompleted ? "completed" : "pending" %>">
                <h4><%= taskDescription %> - <%= progressPercentage %>%</h4>
                <div class="progress-bar">
                    <div class="progress-fill <%= isCompleted ? "completed" : "pending" %>"
                         style="--progress-width: <%= progressPercentage %>%">
                    </div>

                </div>
            </div>
            <%
                        }
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red'>Error loading tasks: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                }
            }
            %>
        </div>
    </body>
</html>