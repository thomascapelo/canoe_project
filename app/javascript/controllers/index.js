// Import and register all your controllers from the importmap under controllers/*

import { application } from "./controllers/application";
import "./autocomplete.js";
import "./form_dropdown.js";

// Eager load all controllers defined in the import map under controllers/**/*_controller
eagerLoadControllersFrom("controllers", application);
