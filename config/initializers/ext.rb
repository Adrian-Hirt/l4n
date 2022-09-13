Rails.root.join('lib/ext/**/*.rb').glob.each do |filename|
  require filename
end
