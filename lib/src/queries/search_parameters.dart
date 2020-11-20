
class SearchParameters {
  String locale;
  String keyword;
  bool isVerified;
  List<dynamic> languages;
  bool acceptingNewClients;
  List<dynamic> chapters;
  List<dynamic> catagories;
  DateTime startDate;
  DateTime endDate;
  List<dynamic> servicesAreProvided;
  List<dynamic> ageGroupsServed;

  SearchParameters({
      this.locale,
      this.keyword,
      this.isVerified,
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
    this.keyword = this.catagories != '' ? '' : this.keyword;
    return """keyword = $keyword 
        languages = $languages 
        acceptingNewClients = $acceptingNewClients 
        startDate = ${startDate.toString()} 
        endDate = ${endDate.toString()}
        servicesAreProvided = $servicesAreProvided
        ageGroupsServed = $ageGroupsServed
        chapters = $chapters
        type = $catagories
        """;
  }
}
