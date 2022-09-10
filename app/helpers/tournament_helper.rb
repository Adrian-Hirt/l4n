module TournamentHelper
  def format_match_score(match, relevant_team)
    show_score = match.away_score != 0 || match.home_score != 0

    team = match.send(relevant_team)
    score = match.send("#{relevant_team}_score").to_s

    if match.draw?
      tag.span(class: 'text-warning') do
        show_score ? score : _('Match|Draw short')
      end
    elsif match.winner.blank?
      '&mdash;'.html_safe
    elsif match.winner_id == team&.id
      tag.span(class: 'text-success') do
        show_score ? score : _('Match|Win short')
      end
    else
      tag.span(class: 'text-danger') do
        show_score ? score : _('Match|Loss short')
      end
    end
  end

  def format_match_score_large(match, relevant_team)
    # rubocop:disable Lint/DuplicateBranch
    if match.invalid?
      tag.div(class: 'bg-secondary text-white result-score-box') do
        _('Match|Tbd')
      end
    elsif match.draw?
      tag.div(class: 'bg-warning text-white result-score-box') do
        _('Match|Draw')
      end
    elsif match.winner.blank?
      tag.div(class: 'bg-secondary text-white result-score-box') do
        _('Match|Tbd')
      end
    elsif match.winner_id == relevant_team&.id
      tag.div(class: 'bg-success text-white result-score-box') do
        _('Match|Winner')
      end
    else
      tag.div(class: 'bg-danger text-white result-score-box') do
        _('Match|Loser')
      end
    end
    # rubocop:enable Lint/DuplicateBranch
  end

  def format_registration_status(tournament)
    if tournament.registration_open?
      tag.div(class: 'd-inline-block bg-success text-white px-2') do
        _('Tournament|Registration open')
      end
    else
      tag.div(class: 'd-inline-block bg-danger text-white px-2') do
        _('Tournament|Registration closed')
      end
    end
  end

  def round_matches_to_inverse_round_index_word(number_of_matches)
    case number_of_matches
    when 2
      'one'
    when 4
      'two'
    when 8
      'three'
    when 16
      'four'
    when 32
      'five'
    when 64
      'six'
    else
      ''
    end
  end
end
