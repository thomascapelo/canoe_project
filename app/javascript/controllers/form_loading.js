import { Controller } from "stimulus";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends Controller {
  submitWithTurbo() {
    const form = this.element;
    const frame = form.getAttribute("data-turbo-frame");
    const actionUrl = form.getAttribute("action");

    Turbo.visit(actionUrl, { action: "replace", frame });
  }
}
