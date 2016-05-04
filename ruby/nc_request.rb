require 'open-uri'
require 'nokogiri'
require 'config'
require 'extend_objects'

# Class with all static functions that makes requests to ninjacourses.com
# in order to scrape data about courses at UCSB
class NCRequest

	# Gets department shortcodes for UCSB from ninjacourses.com.
	# Returns all shortcodes in an array
	# ex) ['ANTH',...,'CMPSC',...,'WRIT']
	def self.getDeptsNC
		depts = Array.new
		page = Nokogiri::HTML(open('https://ninjacourses.com/explore/4/'))
		page.css('li').each do |dept|
			dept_code = dept.text.string_between_markers('(',')')
			if dept_code != "Creative Studies" && dept_code != "Online"
				#puts dept_code
				depts << dept_code
			end
		end
		depts.compact!
		return depts
	end

	# Gets all courses in a given department from ninjacourses
	# Takes HTML page object of the corresponding department as argument
	# Returns array of all courses in one department
	def self.getCoursesNC(page)
		omit = ['Courses','Plan Schedule','Saved Schedules',
				'Textbooks','Friends',
				'(not offered Fall 2015)']

		courses = Array.new
		page.css('li').each do |course|
			if omit.any?{ |w| course.text[w] }
				# If course.text contains a substring 
				# that is in omit, skip that course
			else
				courses << course.text
			end
		end
		courses = courses[5..-1]
		return courses
	end

	# Returns all courses in every department in dictionary form
	# ex) course_map['CMPSC'] = ['CMPSC 8', 'CMPSC 16', ..., 'CMPSC 216']
	# Takes an array of dept shortcodes as an argument
	def self.getAllCoursesNC(depts)
		course_map = Hash.new
		depts.each do |dept|
			url_dept = dept.gsub(' ','%20')
			url = "https://ninjacourses.com/explore/4/department/#{url_dept}"

			page = Nokogiri::HTML(open(url))
			course_map[dept] = getCoursesNC(page)
		end
		return course_map
	end

	# Returns info about all courses...incomplete
	def self.getAllCourseInfoNC()
		course_map = getAllCoursesNC(getDeptsNC())
		url = "https://ninjacourses.com/explore/4/course/"
		course_map.each do |courses|
			courses.each do |course|
				array = course.split(" ")
				url_ = url + array[0] + "/" + array[1]
			end
		end
	end

	# Gets all courses that satisfy a given general education requirement.
	# Takes a url to the page that has the requirements on UCSB course catalog website.
	# ex) url = "https://my.sa.ucsb.edu/catalog/2014-2015/UndergraduateEducation/AreaD.aspx"
	# Returns array of course names for a given G.E. requirement.
	def self.getGeneralEd(url)
		courses = Array.new
		page = Nokogiri::HTML(open(url))
		page.css('p').each do |course|
			# Remove leading and trailing whitespace
			courseText = course.text.strip
			# Replace multiple whitespace with single space
			courseText = courseText.gsub(/\s+/, ' ')
			courses << courseText
		end
		return courses
	end


end
