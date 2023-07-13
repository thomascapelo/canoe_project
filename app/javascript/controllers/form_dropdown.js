import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["tripType", "returnDate"];

  handleChange() {
    const tripTypeDropdown = this.tripTypeTarget;
    const returnDateInput = this.returnDateTarget;

    if (tripTypeDropdown.value === "one_way") {
      returnDateInput.style.display = "none";
    } else {
      returnDateInput.style.display = "block";
    }
  }
}
