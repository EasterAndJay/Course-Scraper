module CourseRequest

	require 'open-uri'
	require 'nokogiri'

	ENV['SSL_CERT_FILE'] = './cacert.pem'

	# Add function to String class
	# returns substring between two delimiters
	class String
	  def string_between_markers marker1, marker2
	    self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]
	  end
	end


	# Gets department shortcodes for UCSB from ninjacourses.com
	# ex) CMPSC
	# Returns all shortcodes in an array
	def self.getDepts
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
	def self.getCourses(page)
		courses = Array.new
		page.css('li').each do |course|
			if course.text.match('(not offered Fall 2015)')
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
	def self.getAllCourses(depts)
		course_map = Hash.new
		depts.each do |dept|
			url_dept = dept.gsub(' ','%20')
			url = "https://ninjacourses.com/explore/4/department/#{url_dept}"

			page = Nokogiri::HTML(open(url))
			course_map[dept] = getCourses(page)
		end
		return course_map
	end

	# Gets all courses that satisfy a given general education requirement
	# Takes a url to the page that has the requirements on 
	# UCSB course catalog website.
	# ex) url = "https://my.sa.ucsb.edu/catalog/2014-2015/UndergraduateEducation/AreaD.aspx"
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