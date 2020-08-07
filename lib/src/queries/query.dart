class Query {
  String _keyword;
  String _languages;
  String _acceptingNewClients;
  DateTime _startDate;
  DateTime _endDate;

  set keyword (String keyword) {
    _keyword = keyword;
  }
  set languages (String languages) {
    _languages = languages;
  }
  set acceptingNewClients (String acceptingNewClients) {
    _acceptingNewClients = acceptingNewClients;
  }
  set startDate (DateTime startDate) {
    _startDate = startDate;
  }
  set endDate (DateTime endDate) {
    _endDate = endDate;
  }
  
  Query(this._keyword, this._languages, this._acceptingNewClients, this._startDate, this._endDate);

  @override
  String toString() {
    return "keyword = $_keyword languages = $_languages acceptingNewClients = $_acceptingNewClients startDate = ${_startDate.toString()} endDate = ${_endDate.toString()}";
  }
}