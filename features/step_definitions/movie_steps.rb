# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.

    saved_movie = Movie.find_or_create_by_title(movie['title'], movie)
    # puts "saved_movie for #{movie['title']}: #{saved_movie['id']}, #{saved_movie['rating']}, #{saved_movie['title']}"
  end
  # assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  regexp = Regexp.new(e1 + ".*" + e2, Regexp::MULTILINE)
  match = regexp.match(page.body)
  # puts "Match result: #{match}"
  # puts match.inspect
  assert match != nil
  # assert false, "Unimplmemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/\s*,\s*/).each do |rating|
    if uncheck
      # puts "Unchecking rating #{rating}"
      uncheck("ratings[#{rating}]")
      uncheck("ratings_#{rating}")
    else
      # puts "Checking rating #{rating}"
      check("ratings[#{rating}]")
      check("ratings_#{rating}")
    end
  end
end

Then /I should see none of the movies/ do
  rows = page.all(:xpath, '//table[@id="movies"]/tbody/tr').size
  rows.should == 0
end

Then /I should see all of the movies/ do
  rows = page.all(:xpath, '//table[@id="movies"]/tbody/tr').size
  rows.should == Movie.count
end
