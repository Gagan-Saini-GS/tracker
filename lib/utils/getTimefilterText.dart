String getTimeFilterText(String name) {
  if (name == "day") {
    return "Daily";
  } else if (name == "week") {
    return "Weekly";
  } else if (name == "month") {
    return "Monthly";
  } else if (name == "year") {
    return "Yearly";
  }

  return "-";
}
