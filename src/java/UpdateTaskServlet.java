import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateTaskServlet")
public class UpdateTaskServlet extends HttpServlet {
    
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/progress_tracker";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "PHW#84#jeor";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        int taskId = Integer.parseInt(request.getParameter("task_id"));
        boolean isCompleted = Boolean.parseBoolean(request.getParameter("is_completed"));

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement stmt = conn.prepareStatement(
                "UPDATE tasks SET is_completed = ? WHERE id = ?")) {
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            stmt.setBoolean(1, isCompleted);
            stmt.setInt(2, taskId);
            int rowsUpdated = stmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                session.setAttribute("message", "Task updated successfully");
            } else {
                session.setAttribute("error", "Failed to update task");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Database error: " + e.getMessage());
        }

        response.sendRedirect("index.jsp");
    }
}
