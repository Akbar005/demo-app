class MGrocery {
  int id;
  String name;
  String url;
  String category;
  int price;
  int availability;
  String details;

  MGrocery(
      {this.id,
      this.name,
      this.url,
      this.category,
      this.price,
      this.availability,
      this.details});

  MGrocery.fromJson(Map json) {
    id = json["p_id"];
    name = json["p_name"];
    price = json["p_cost"];
    category = json["p_category"];
    availability = json["p_availability"];
    details = json["p_details"];
  }
}
