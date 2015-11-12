
require "./course_request"

url = "https://my.sa.ucsb.edu/catalog/2010-2011/UndergraduateEducation/AreaD.aspx"
dCourses = CourseRequest.getGeneralEd(url)

dCourses.each do |course|
	puts course
end

# course_map = getAllCourses(getDepts)
# #course_map = {:dept => array(courses)}
# course_map.each do |courses|
# 	puts course_map.key(courses)
# 	courses.each do |course|
# 		puts course
# 	end
# end