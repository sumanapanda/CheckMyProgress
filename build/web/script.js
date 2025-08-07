document.addEventListener("DOMContentLoaded", function() {
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
            dayElement.className = "day";
            calendarElement.appendChild(dayElement);
        });

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
