require 'mechanize'
require 'logger'
require 'nokogiri'
require 'json'
require 'config'
require 'extend_objects'

class GoldSearch
  @agent = Mechanize.new
  @agent.log = Logger.new "mech.log"
  @agent.user_agent_alias = "Mac Safari"

  def self.login(username, password)
    page = @agent.get "https://my.sa.ucsb.edu/gold/login.aspx"
    login_form = page.form_with :id => "LoginForm"
    login_form.field_with(:name => "ctl00$pageContent$userNameText").value = username
    login_form.field_with(:name => "ctl00$pageContent$passwordText").value = password
    result = login_form.submit login_form.button
    return result
  end

  def self.search(dept, quarter)
    page = @agent.get "https://my.sa.ucsb.edu/gold/BasicFindCourses.aspx"
    search_form = page.form_with :id => "MainForm"
    search_form.field_with(:name => "ctl00$pageContent$quarterDropDown").value = quarter
    search_form.field_with(:name => "ctl00$pageContent$subjectAreaDropDown").value = dept
    result = search_form.submit search_form.button
    return result
  end

  def self.getDetails(result, i)
    detail_form = result.form_with :id => "MainForm"
    detail_form.field_with(:name => "__EVENTTARGET").value = "ctl00$pageContent$CourseList$ctl" + i.to_s.rjust(2,"0") + "$CourseDetailLink"
    result = detail_form.submit
    return result
  end

  def self.getDeptsGold
    login("jonathaneasterman", "Whinfrey1")
    page = @agent.get "https://my.sa.ucsb.edu/gold/BasicFindCourses.aspx"

    options = page.css("select option")
    options.each do |option|
      puts option.attr('value')
    end
  end

  def self.getCourses(result)
    i = 0
    courses = Hash.new
    while result.css("td#pageContent_CourseList_PermNbr_#{i} span.tableheader") && result.css("table#pageContent_CourseList_PrimarySections_#{i} td[width='40'].clcellprimary")[0]
      div = result.search("table#pageContent_CourseList_PrimarySections_#{i}")
      course_name = result.css("td#pageContent_CourseList_PermNbr_#{i} span.tableheader").text.strip.gsub(/[\r\n\t]/, ' ').gsub(/ {2,}/, ' ')
      days = div.at("td:contains('T R')")
      times = div.at("td:contains('9:30 AM-10:45 AM')")
      spots = result.css("table#pageContent_CourseList_PrimarySections_#{i} td[width='40'].clcellprimary")[0].text
      if (spots != "Full " || spots != "Cancel ") && (days != nil && times != nil)
        courses[course_name] = spots
      end
      #courses << course_name
      i += 1
    end
    return courses
  end

def self.readDepts()
  depts = Array.new
  File.open("text/depts.txt", "r") do |f|
    f.each_line do |line|
      depts << line.gsub("\n", "")
    end
  end
  return depts
end

  def self.glue(username, password, quarter)
    courses = Hash.new
    depts = readDepts
    login(username, password)
    depts.each do |dept|
      result = search(dept, quarter)
      course_list = getCourses(result)
      courses[dept.split(" ")[0]] = course_list
      puts JSON.pretty_generate(courses)
    end
    puts JSON.pretty_generate(courses)
    #puts courses.to_json  
  end

  def self.details(username, password, dept, quarter)

    i = 0
    courses = {}
    result = search(dept, quarter)
    loop do
      result = getDetails(result, i)
      div = result.search("#pageContent_DescPageView")
      if div.at("td:contains('Full Title: ')") == nil
        break
      end
      name = result.search("#pageContent_courseID").text.gsub(/\s+/, ' ').split(" - ")[0]
      
      title = div.at("td:contains('Full Title: ')").try(:next).try(:text).try(:gsub, /\s+/, ' ').try(:strip)
      desc = div.at("td:contains('Description: ')").try(:next).try(:text).try(:gsub, /\s+/, ' ').try(:strip)
      option = div.at("td:contains('Grading Option: ')").try(:next).try(:text)
      units = div.at("td:contains('Units: ')").try(:next).try(:text)
      courses[name] = {
        :title => title, 
        :description => desc,
        :grading => option, 
        :units => units
      }

      result = @agent.get "https://my.sa.ucsb.edu/gold/ResultsFindCourses.aspx"
      i += 1
    end
    return courses
  end

  def self.getAllDetails(username, password)
    depts = readDepts
    details = {}
    login(username,password)
    depts.each do |dept|
      details[dept.strip] = details(username, password, dept, "20162")
      puts JSON.pretty_generate(details)
      details = {}
    end
    # puts JSON.pretty_generate(details)  
  end

end