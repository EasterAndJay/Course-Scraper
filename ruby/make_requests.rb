
require "./course_request"

def writeGenEdsToFiles
	letters = ['B', 'C', 'D', 'E', 'F', 'G', 'H']
	url = "https://my.sa.ucsb.edu/catalog/2014-2015/UndergraduateEducation/"

	letters.each do |letter|
		url_ = url + "Area#{letter}.aspx"
		courses = CourseRequest.getGeneralEd(url_)
		outfile = "area#{letter}.txt"
		courses.each do |course|
			File.open(outfile, 'a') { |file| file.write(course + "\n") }
		end
	end
end

# course_map = getAllCourses(getDepts)
# #course_map = {:dept => array(courses)}
# course_map.each do |courses|
# 	puts course_map.key(courses)
# 	courses.each do |course|
# 		puts course
# 	end
# end