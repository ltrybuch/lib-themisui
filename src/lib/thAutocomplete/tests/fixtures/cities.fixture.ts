type CityType = {
    id: number;
    name: string;
    province: string;
};

class CitiesFixture {
  public static getCanadianCities(): CityType[] {
    return [
      {id: 0, name: "Toronto", province: "Ontario"},
      {id: 1, name: "Montreal", province: "Quebec"},
      {id: 2, name: "Calgary", province: "Alberta"},
      {id: 3, name: "Ottawa", province: "Ontario"},
      {id: 4, name: "Edmonton", province: "Alberta"},
      {id: 5, name: "Mississauga", province: "Ontario"},
      {id: 6, name: "Winnipeg", province: "Manitoba"},
      {id: 7, name: "Vancouver", province: "British Columbia"},
      {id: 8, name: "Brampton", province: "Ontario"},
      {id: 9, name: "Hamilton", province: "Ontario"},
      {id: 10, name: "Quebec City", province: "Quebec"},
      {id: 11, name: "Surrey", province: "British Columbia"},
      {id: 12, name: "Laval", province: "Quebec"},
      {id: 13, name: "Halifax", province: "Nova Scotia"},
      {id: 14, name: "London", province: "Ontario"},
      {id: 15, name: "Markham", province: "Ontario"},
      {id: 16, name: "Vaughan", province: "Ontario"},
      {id: 17, name: "Gatineau", province: "Quebec"},
      {id: 18, name: "Longueuil", province: "Quebec"},
      {id: 19, name: "Burnaby", province: "British Columbia"},

    ];
  }
  // tslint:disable:max-line-length
  public static getCitiesWithLongNames(): CityType[] {
    return [
      {id: 0, name: "Redmonton - in reference to the city being the most friendly territory for left wing parties in the province.", province: "Alberta"},
      {id: 1, name: "The City with All Hell for a Basement, derived from a quote by Rudyard Kipling referring to Medicine Hat's natural gas reserves", province: "Alberta"},
      {id: 2, name: "Dawson Creek, The Corporation of the City of", province: "British Columbia"},
      {id: 3, name: "Fernie, The Corporation of the City of", province: "British Columbia"},
      {id: 4, name: "Grand Forks, The Corporation of the City of	", province: "British Columbia"},
      {id: 5, name: "New Westminster, The Corporation of the City of", province: "British Columbia"},
      {id: 6, name: "Port Coquitlam, The Corporation of the City of", province: "British Columbia"},
      {id: 7, name: "Powell River, The Corporation of the City of	", province: "British Columbia"},
      {id: 8, name: "City of Newly Weds and Nearly Deads, with larger numbers of seniors or young families as the two major demographics", province: "British Columbia"},
      {id: 9, name: "Vernon, The Corporation of the City of", province: "British Columbia"},
      {id: 10, name: "White Rock, The Corporation of the City of", province: "British Columbia"},
    ];
  }
  // tslint:enable:max-line-length
}

export default CitiesFixture;
