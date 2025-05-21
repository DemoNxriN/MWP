document.addEventListener("DOMContentLoaded", function () {
    document.querySelector(".service-form").addEventListener("submit", async (e) => {
        e.preventDefault();

        const formData = {
            name: document.querySelector("#name").value,
            email: document.querySelector("#email").value,
            phone: document.querySelector("#phone").value,
            car_make: document.querySelector("#car-make").value,
            car_model: document.querySelector("#car-model").value,
            car_plate: document.querySelector("#car-plate").value,
            service: document.querySelector("#service").value,
            date: document.querySelector("#date").value,
        };

        try {
            const response = await fetch("http://localhost:5000/api/cita", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(formData),
            });

            const result = await response.json();
            alert(result.message || result.error);
        } catch (error) {
            alert("Error al enviar el formulario: " + error.message);
        }
    });
});
