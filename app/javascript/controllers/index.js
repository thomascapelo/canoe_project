import { application } from "controllers/application";
import "./autocomplete.js";
import "./form_dropdown.js";
import FormLoadingController from "./controllers/form_loading_controller";

// Register the FormLoadingController
application.register("form-loading", FormLoadingController);

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);
