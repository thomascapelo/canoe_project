document.addEventListener("DOMContentLoaded", function () {
  const tripTypeDropdown = document.getElementById("trip_type");
  const returnDateInput = document.getElementById("return_date");

  tripTypeDropdown.addEventListener("change", function () {
    if (tripTypeDropdown.value === "one_way") {
      returnDateInput.style.display = "none";
    } else {
      returnDateInput.style.display = "block";
    }
  });
});
