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

@WebServlet("/AddTaskServlet")
public class AddTaskServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/progress_tracker";
    private static final String JDBC_USER = "root"; // Change as needed
    private static final String JDBC_PASS = "PHW#84#jeor"; // Change as needed

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String description = request.getParameter("description");
        String taskDate = request.getParameter("task_date");
        HttpSession session = request.getSession();
        
        // Validate input
        if (description == null || description.trim().isEmpty() || taskDate == null) {
            session.setAttribute("error", "Task description and date are required");
            response.sendRedirect("index.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
            stmt = conn.prepareStatement("INSERT INTO tasks (task_date, description) VALUES (?, ?)");
            stmt.setString(1, taskDate);
            stmt.setString(2, description.trim());
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                session.setAttribute("message", "1 task added to the list");
            } else {
                session.setAttribute("error", "Failed to add task");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Database error: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("index.jsp");
    }
}
