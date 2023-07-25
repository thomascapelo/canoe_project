// controllers/autocomplete_controller.js
import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["input", "suggestions"];
  static values = {
    apiUrl: String,
    subType: String,
    pageLimit: Number,
    sort: String,
    view: String,
  };

  connect() {
    this.accessToken = null;
    this.fetchAccessToken();
  }

  fetchAccessToken() {
    $.ajax({
      url: "https://test.api.amadeus.com/v1/security/oauth2/token",
      method: "POST",
      data: {
        grant_type: "client_credentials",
        client_id: "E3QJBG9aB36ZF3tKCopetWORIvV7NYAC",
        client_secret: "Cu94OhFnMVAWGuJo",
      },
      success: (response) => {
        this.accessToken = response.access_token;
      },
      error: (xhr, textStatus, errorThrown) => {
        console.error("Failed to retrieve access token:", errorThrown);
      },
    });
  }

  fetchAutocompleteSuggestions(input) {
    // Clear previous suggestions
    this.suggestionsTarget.innerHTML = "";

    // Make AJAX request to Amadeus API
    $.ajax({
      url: "https://test.api.amadeus.com/v1/reference-data/locations",
      data: {
        subType: "CITY,AIRPORT",
        keyword: input,
      },
      headers: {
        Authorization: "Bearer " + this.accessToken,
      },
      success: (response) => {
        // Process API response and display suggestions
        const maxSuggestions = 5; // Limit the number of suggestions to 5
        let suggestionCount = 0; // Counter for the number of suggestions

        response.data.forEach((location) => {
          const cityName = location.address.cityName;
          const countryName = location.address.countryName;
          const iataCode = location.iataCode;

          // Create suggestion element
          const suggestion = document.createElement("div");
          suggestion.classList.add("suggestion");
          suggestion.textContent =
            this.capitalizeFirstLetter(cityName) +
            ", " +
            this.capitalizeFirstLetter(countryName) +
            " (" +
            iataCode +
            ")";
          suggestion.dataset.iataCode = iataCode;
          suggestion.style.cursor = "pointer";

          // Append suggestion to the container if the limit is not exceeded
          if (suggestionCount < maxSuggestions) {
            this.suggestionsTarget.appendChild(suggestion);
            suggestionCount++;
          }

          // Attach click event listener to populate input field with selected suggestion
          suggestion.addEventListener("click", () => {
            this.handleSuggestionSelection(iataCode);
          });
        });

        // Show or hide the autocomplete suggestions container based on the number of suggestions
        if (suggestionCount > 0) {
          this.suggestionsTarget.style.display = "block";
        } else {
          this.suggestionsTarget.style.display = "none";
        }
      },
    });
  }

  capitalizeFirstLetter(str) {
    return str
      .toLowerCase()
      .replace(/(^|\s)\w/g, (match) => match.toUpperCase());
  }

  handleSuggestionSelection(iataCode) {
    this.inputTarget.value = iataCode;
    this.suggestionsTarget.innerHTML = "";
    this.suggestionsTarget.style.display = "none";
  }

  closeSuggestions(event) {
    if (
      !this.suggestionsTarget.contains(event.target) &&
      event.target !== this.inputTarget
    ) {
      this.suggestionsTarget.innerHTML = "";
      this.suggestionsTarget.style.display = "none";
    }
  }

  onInput() {
    const input = this.inputTarget.value;
    this.fetchAutocompleteSuggestions(input);
  }
}
