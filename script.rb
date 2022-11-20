data = File.read("./locale/en/app.po")

result = []

prev_line_end = nil
data.each_line do |line|
  if line.start_with? "msgid"
    if line.include? '|'
      prev_line_end = line.match(/.*\|([a-z\sA-Z\-_]*)/)[1]
    else
      prev_line_end = line.match(/"(.*)"/)[1]
    end
  elsif line.start_with? "msgstr"
    unless prev_line_end.strip.empty?
      line = "msgstr \"#{prev_line_end.strip}\""
    end
  end

  unless line.include? 'fuzzy'
    result << line.strip
  end
end

File.write("./locale/en/app.po", result.join("\n"))