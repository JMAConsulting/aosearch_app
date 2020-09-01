
class SearchParameters {
  String keyword;
  List<dynamic> languages;
  String acceptingNewClients;
  List<dynamic> chapters;
  List<dynamic> catagories;
  DateTime startDate;
  DateTime endDate;
  List<dynamic> servicesAreProvided;
  List<dynamic> ageGroupsServed;

  SearchParameters({
      this.keyword,
      this.languages,
      this.acceptingNewClients,
      this.startDate,
      this.endDate,
      this.servicesAreProvided,
      this.ageGroupsServed,
      this.chapters,
      this.catagories,
  });

  @override
  String toString() {
    return """keyword = $keyword 
        languages = $languages 
        acceptingNewClients = $acceptingNewClients 
        startDate = ${startDate.toString()} 
        endDate = ${endDate.toString()}
        servicesAreProvided = $servicesAreProvided
        ageGroupsServed = $ageGroupsServed
        chapters = $chapters
        catagories = $catagories
        """;
  }
}
