module ScraperHelpers
  def sport_name_to_id
    {
      'Artistic' => 316,
      'Athletics' => 106,
      'Boxing' => 123,
      'Weightlifting' => 206,
      'Shooting' => 209,
      'Rhythmic' => 315,
      'Swimming' => 117,
      'Track' => 305
    }
  end

  def build_local_edition_id(sport_id, competition, date_end)
    comp_id = competition.scan(/\b[a-z]/i).join.upcase
    date_id = date_end.tr('-', '')
    sport_id.to_s + comp_id + date_id
  end

  def build_local_phase_id(sport_id, competition, date_end, event, gender_short)
    comp_id = competition.scan(/\b[a-z]/i).join.upcase
    date_id = date_end.tr('-', '')
    event_id = event.delete("^a-zA-Z0-9+-")
    sport_id.to_s + comp_id + date_id + gender_short + event_id
  end

  def gender_by_order(num)
    return "Women" if num == 1
    return "Men" if num == 2
    return "N/A" if num == 3
  end

  def gender_short_by_order(num)
    return "W" if num == 1
    return "M" if num == 2
    return "N/A" if num == 3
  end
end
