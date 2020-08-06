class Query {
  String keyword;
  String languages;
  String acceptingNewClients;
  DateTime startDate;
  DateTime endDate;

  Query(this.keyword, this.languages, this.acceptingNewClients, this.startDate, this.endDate);

  @override
  String toString() {
    return "keyword = $keyword languages = $languages acceptingNewClients = $acceptingNewClients startDate = ${startDate.toString()} endDate = ${endDate.toString()}";
  }
}