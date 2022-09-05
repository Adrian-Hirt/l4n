module TournamentHelper
  def format_match_score(match, relevant_team)
    if match.winner.blank?
      '&mdash;'.html_safe
    elsif match.winner == relevant_team
      tag.span(class: 'text-success') do
        'W'
      end
    else
      tag.span(class: 'text-danger') do
        'L'
      end
    end
  end
end
