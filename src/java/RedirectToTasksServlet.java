import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

//@WebServlet("/redirectToTasks")
public class RedirectToTasksServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String currentDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        
        response.sendRedirect("viewTasks.jsp?task_date=" + currentDate);
    }
}
