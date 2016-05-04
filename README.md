## Synopsis

A few small APIs to scrape course information from UCSB's GOLD website and ninjacourses.com. I initially wrote the code in python during my 2nd year of programming, and I recently rewrote a ruby version during my 3rd of programming.
I plan to use the course information gained to offer a better alternative to GOLD. The python code isn't meant to be maintained...consider it a reference of how **NOT** to code.
Link to GOLD:  https://my.sa.ucsb.edu/gold/Login.aspx?ReturnUrl=%2fgold%2fHome.aspx
## Code Example

Make sure you have your environment variables set up in config.rb. Also ensure you have a depts.txt file in the /text folder.

`GoldSearch.scrapeAllCourses(ENV["GOLD_USERNAME"], ENV["GOLD_PASSWORD"], 20162)`

Will print all courses in all departments offered during Spring 2016 in JSON format.
The 3rd argument, `20162`, can be decoded as follows:

```
Desired year = 2016
Desired quarter = Spring = 2

Quarter numbers:
  1 -> Winter
  2 -> Spring
  3 -> Summer
  4 -> Fall
  ```
