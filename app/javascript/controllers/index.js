// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application";
import "./autocomplete.js";

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in the import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

// Enable Turbo Frames
import { TurboFramesAdapter } from "@hotwired/turbo";
const adapter = new TurboFramesAdapter();
application.register("turbo-frames-adapter", adapter);

// Now you can register additional controllers after initializing the application
import { Application } from "stimulus";
import SearchController from "./search_controller";

const application = Application.start();
application.register("search", SearchController);
