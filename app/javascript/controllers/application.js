// application.js inside javascript/controllers directory
import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus/webpack-helpers";

const application = Application.start();
const context = require.context(".", true, /\.js$/);
application.load(definitionsFromContext(context));

export default application;
