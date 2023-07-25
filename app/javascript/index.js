// index.js
import application from "./application.js";
import AutocompleteController from "./autocomplete_controller.js";
import FormDropdownController from "./form_dropdown_controller.js";

application.register("autocomplete", AutocompleteController);
application.register("form-dropdown", FormDropdownController);
