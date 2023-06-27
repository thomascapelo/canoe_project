import { Controller } from "stimulus";
import Autocomplete from "stimulus-autocomplete";

export default class extends Controller {
  static targets = ["departureInput", "arrivalInput"];

  connect() {
    // Get the access token before initializing the autocomplete
    this.getAccessToken().then((accessToken) => {
      new Autocomplete(this.departureInputTarget, {
        search: async (term) => {
          const url = `https://test.api.amadeus.com/v1/reference-data/locations?subType=CITY&keyword=${term}&page[limit]=10&page[offset]=0&sort=analytics.travelers.score&view=FULL`;
          const response = await fetch(url, {
            headers: {
              Authorization: `Bearer ${accessToken}`,
            },
          });
          const data = await response.json();
          return data.data.map((location) => location.name);
        },
      });

      new Autocomplete(this.arrivalInputTarget, {
        search: async (term) => {
          const url = `https://test.api.amadeus.com/v1/reference-data/locations?subType=CITY&keyword=${term}&page[limit]=10&page[offset]=0&sort=analytics.travelers.score&view=FULL`;
          const response = await fetch(url, {
            headers: {
              Authorization: `Bearer ${accessToken}`,
            },
          });
          const data = await response.json();
          return data.data.map((location) => location.name);
        },
      });
    });
  }

  async getAccessToken() {
    const clientId = "E3QJBG9aB36ZF3tKCopetWORIvV7NYAC";
    const clientSecret = "Cu94OhFnMVAWGuJo";

    const tokenUrl = "https://test.api.amadeus.com/v1/security/oauth2/token";
    const body = new URLSearchParams();
    body.append("grant_type", "client_credentials");
    body.append("client_id", clientId);
    body.append("client_secret", clientSecret);

    const response = await fetch(tokenUrl, {
      method: "POST",
      body: body,
    });

    const data = await response.json();
    return data.access_token;
  }
}
