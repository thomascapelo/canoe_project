import { Controller } from "stimulus";
import { fetch } from "@rails/ujs";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends Controller {
  static targets = ["inputField", "autocompleteContainer"];

  initialize() {
    this.accessToken = null;
  }

  connect() {
    this.fetchAccessToken();
  }

  fetchAccessToken() {
    fetch("https://test.api.amadeus.com/v1/security/oauth2/token", {
      method: "POST",
      body: JSON.stringify({
        grant_type: "client_credentials",
        client_id: "E3QJBG9aB36ZF3tKCopetWORIvV7NYAC",
        client_secret: "Cu94OhFnMVAWGuJo",
      }),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((data) => {
        this.accessToken = data.access_token;
      })
      .catch((error) => {
        console.error("Failed to retrieve access token:", error);
      });
  }

  fetchAutocompleteSuggestions(event) {
    const input = event.target.value;
    const inputField = this.inputFieldTarget;
    const autocompleteContainer = this.autocompleteContainerTarget;

    autocompleteContainer.innerHTML = ""; // Clear previous suggestions
    autocompleteContainer.style.display = "none";

    if (input.length > 0) {
      fetch(
        `https://test.api.amadeus.com/v1/reference-data/locations?keyword=${input}&subType=CITY&page[limit]=10&page[offset]=0&sort=analytics.travelers.score&view=FULL`,
        {
          headers: {
            Authorization: `Bearer ${this.accessToken}`,
          },
        }
      )
        .then((response) => response.json())
        .then((data) => {
          const maxSuggestions = 5; // Limit the number of suggestions to 5
          let suggestionCount = 0; // Counter for the number of suggestions

          data.data.forEach((location) => {
            const cityName = location.address.cityName;
            const countryName = location.address.countryName;
            const iataCode = location.iataCode;

            const suggestion = document.createElement("div");
            suggestion.classList.add("suggestion");
            suggestion.textContent = `${this.capitalizeFirstLetter(
              cityName
            )}, ${this.capitalizeFirstLetter(countryName)} (${iataCode})`;
            suggestion.dataset.iataCode = iataCode;
            suggestion.style.cursor = "pointer";

            suggestion.addEventListener("click", () => {
              this.handleSuggestionSelection(inputField, iataCode);
            });

            if (suggestionCount < maxSuggestions) {
              autocompleteContainer.appendChild(suggestion);
              suggestionCount++;
            }
          });

          if (suggestionCount > 0) {
            autocompleteContainer.style.display = "block";
          }
        })
        .catch((error) => {
          console.error("Failed to fetch autocomplete suggestions:", error);
        });
    }
  }

  capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
  }

  handleSuggestionSelection(inputField, iataCode) {
    inputField.value = iataCode;
    this.autocompleteContainerTarget.innerHTML = "";
    this.autocompleteContainerTarget.style.display = "none";
  }

  handleClickOutside(event) {
    if (
      !this.autocompleteContainerTarget.contains(event.target) &&
      !this.inputFieldTarget.contains(event.target)
    ) {
      this.autocompleteContainerTarget.innerHTML = "";
      this.autocompleteContainerTarget.style.display = "none";
    }
  }
}
