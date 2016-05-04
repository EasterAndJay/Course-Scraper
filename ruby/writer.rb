require "nc_request"
require "gold_search"

class Writer

  def writeGenEdsToFiles
    letters = ['B', 'C', 'D', 'E', 'F', 'G', 'H']
    url = "https://my.sa.ucsb.edu/catalog/2014-2015/UndergraduateEducation/"

    letters.each do |letter|
      url_ = url + "Area#{letter}.aspx"
      courses = NCRequest.getGeneralEd(url_)
      outfile = "area#{letter}.txt"
      courses.each do |course|
        File.open(outfile, 'a') { |file| file.write(course + "\n") }
      end
    end
  end

  def writeSpecSubjectToFiles
    suffix = [
      "WritingReqCourses.aspx",
      "EurTradCourses.aspx",
      "WorldCulturesCourses.aspx",
      "QuantCourses.aspx",
      "EthnicityCourses.aspx"
    ]
    url = "https://my.sa.ucsb.edu/catalog/2014-2015/UndergraduateEducation/"
    suffix.each do |s|
      url_ = url + s
      courses = NCRequest.getGeneralEd(url_)
      outfile = s.chomp(".aspx").downcase + ".txt"
      courses.each do |course|
        File.open(outfile,'a') { |file| file.write(course + "\n") }
      end
    end
  end

  def writeAllCoursesToFile
    course_map = NCRequest.getAllCoursesNC(NCRequest.getDeptsNC)
    course_map.each do |courses|
      puts course_map.key(courses)
      courses.each do |course|
        puts course
      end
    end
  end

  def writeDeptsToFile
    depts = NCRequest.getDeptsNC
    depts.each do |dept|
      File.open("depts.txt", 'a') { |file| file.write(dept + "\n") }
    end
  end

end