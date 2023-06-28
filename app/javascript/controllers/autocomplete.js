$(document).ready(function() {
  // Constants for Amadeus API endpoint and parameters
  const apiUrl = 'https://test.api.amadeus.com/v1/reference-data/locations';
  const subType = 'CITY';
  const pageLimit = 10;
  const pageOffset = 0;
  const sort = 'analytics.travelers.score';
  const view = 'FULL';

  // Autocomplete suggestions container
  const autocompleteContainer = $('#autocomplete-suggestions');

  let accessToken; // Declare the accessToken variable

  // Function to fetch the access token
  function fetchAccessToken() {
    $.ajax({
      url: 'https://test.api.amadeus.com/v1/security/oauth2/token',
      method: 'POST',
      data: {
        grant_type: 'client_credentials',
        client_id: 'E3QJBG9aB36ZF3tKCopetWORIvV7NYAC',
        client_secret: 'Cu94OhFnMVAWGuJo'
      },
      success: function(response) {
        accessToken = response.access_token; // Assign the value to accessToken
        // Use the accessToken in your API requests
        // ...
      },
      error: function(xhr, textStatus, errorThrown) {
        console.error('Failed to retrieve access token:', errorThrown);
      }
    });
  }

  // Function to fetch autocomplete suggestions based on user input
  function fetchAutocompleteSuggestions(input, inputField) {
    // Clear previous suggestions
    autocompleteContainer.empty();

    // Make AJAX request to Amadeus API
    $.ajax({
      url: apiUrl,
      data: {
        keyword: input,
        subType: subType,
        'page[limit]': pageLimit,
        'page[offset]': pageOffset,
        sort: sort,
        view: view
      },
      headers: {
        Authorization: 'Bearer ' + accessToken
      },
      success: function(response) {
        // Process API response and display suggestions
        response.data.forEach(function(location) {
          const cityName = location.address.cityName;
          const iataCode = location.iataCode;

          // Create suggestion element
          const suggestion = $('<div class="suggestion"></div>');
          suggestion.text(cityName);
          suggestion.data('iataCode', iataCode);

          // Attach click event listener to populate input field with selected suggestion
          suggestion.on('click', function() {
            inputField.val(iataCode);
          });

          // Append suggestion to the container
          autocompleteContainer.append(suggestion);
        });
      }
    });
  }

  // Event listener for arrival city input field
  $('#arrival_city').on('input', function() {
    const input = $(this).val();
    fetchAutocompleteSuggestions(input, $(this));
  });

  // Event listener for departure city input field
  $('#departure_city').on('input', function() {
    const input = $(this).val();
    fetchAutocompleteSuggestions(input, $(this));
  });

  // Event listener to close the suggestions container when clicking outside of it
  $(document).on('click', function(event) {
    if (!autocompleteContainer.is(event.target) && autocompleteContainer.has(event.target).length === 0) {
      autocompleteContainer.empty();
    }
  });

  // Fetch the access token when the document is ready
  fetchAccessToken();
});
