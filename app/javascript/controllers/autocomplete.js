$(document).ready(function () {
  // Constants for Amadeus API endpoint and parameters
  const apiUrl = "https://test.api.amadeus.com/v1/reference-data/locations";
  const subType = "CITY";
  const pageLimit = 10;
  const pageOffset = 0;
  const sort = "analytics.travelers.score";
  const view = "FULL";

  // Autocomplete suggestions container
  const autocompleteContainer = $("#autocomplete-suggestions");

  let accessToken; // Declare the accessToken variable

  // Function to fetch the access token
  function fetchAccessToken() {
    $.ajax({
      url: "https://test.api.amadeus.com/v1/security/oauth2/token",
      method: "POST",
      data: {
        grant_type: "client_credentials",
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
      },
      success: function (response) {
        accessToken = response.access_token; // Assign the value to accessToken
        // Use the accessToken in your API requests
      },
      error: function (xhr, textStatus, errorThrown) {
        console.error("Failed to retrieve access token:", errorThrown);
      },
    });
  }

  // Function to fetch autocomplete suggestions based on user input
  function fetchAutocompleteSuggestions(input, inputField) {
    // Clear previous suggestions
    autocompleteContainer.empty().hide();

    // Make AJAX request to Amadeus API
    $.ajax({
      url: apiUrl,
      data: {
        keyword: input,
        subType: subType,
        "page[limit]": pageLimit,
        "page[offset]": pageOffset,
        sort: sort,
        view: view,
      },
      headers: {
        Authorization: "Bearer " + accessToken,
      },
      success: function (response) {
        // Process API response and display suggestions
        const maxSuggestions = 5; // Limit the number of suggestions to 5
        let suggestionCount = 0; // Counter for the number of suggestions

        response.data.forEach(function (location) {
          const cityName = location.address.cityName;
          const countryName = location.address.countryName;
          const iataCode = location.iataCode;

          // Create suggestion element
          const suggestion = $('<div class="suggestion"></div>');
          suggestion.text(
            capitalizeFirstLetter(cityName) +
              ", " +
              capitalizeFirstLetter(countryName) +
              " (" +
              iataCode +
              ")"
          );
          suggestion.data("iataCode", iataCode);
          suggestion.css("cursor", "pointer"); // Add cursor pointer

          // Function to capitalize the first letter of each word
          function capitalizeFirstLetter(str) {
            return str.toLowerCase().replace(/(^|\s)\w/g, function (match) {
              return match.toUpperCase();
            });
          }

          // Attach click event listener to populate input field with selected suggestion
          suggestion.on("click", function () {
            handleSuggestionSelection(inputField, iataCode);
          });

          // Append suggestion to the container if the limit is not exceeded
          if (suggestionCount < maxSuggestions) {
            autocompleteContainer.append(suggestion);
            suggestionCount++;
          }
        });

        // Show or hide the autocomplete suggestions container based on the number of suggestions
        if (suggestionCount > 0) {
          autocompleteContainer.show();
        } else {
          autocompleteContainer.hide();
        }
      },
    });
  }

  // Function to handle selection of a suggestion
  function handleSuggestionSelection(inputField, iataCode) {
    inputField.val(iataCode);
    autocompleteContainer.empty().hide(); // Clear and hide the autocomplete suggestions container
  }

  // Event listener for arrival city input field
  $("#arrival_city").on("input", function () {
    const input = $(this).val();
    fetchAutocompleteSuggestions(input, $(this));
  });

  // Event listener for departure city input field
  $("#departure_city").on("input", function () {
    const input = $(this).val();
    fetchAutocompleteSuggestions(input, $(this));
  });

  // Event listener to close the suggestions container when clicking outside of it
  $(document).on("click", function (event) {
    if (
      !autocompleteContainer.is(event.target) &&
      autocompleteContainer.has(event.target).length === 0
    ) {
      autocompleteContainer.empty().hide();
    }
  });

  // Fetch the access token when the document is ready
  fetchAccessToken();
});
