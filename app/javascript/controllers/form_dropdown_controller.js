// controllers/form_dropdown_controller.js
import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["tripType", "returnDateInput"];

  toggleReturnDate() {
    const value = this.tripTypeTarget.value;
    if (value === "one_way") {
      this.returnDateInputTarget.style.display = "none";
    } else {
      this.returnDateInputTarget.style.display = "block";
    }
  }
}
