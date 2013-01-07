import datetime, calendar, sys

# Patterns
MWF = 1
TR  = 2
T   = 3

# Choice of pattern
if len(sys.argv) < 2:
  print "Usage:"
  print "\tcreate-pages (MWF|TR) <file-prefix>"
  sys.exit()
  
if sys.argv[1] == "MWF":
  pattern = MWF
elif sys.argv[1] == "TR":
  pattern = TR
else:
  pattern = T

if len(sys.argv) == 2:
  file_prefix = ""
else:
  file_prefix = sys.argv[2]

# Make days?

shouldMakeDays = False

### NOTICE
# Always give the date of the Monday of the first week.
#
# January 7, 2013 is a Monday
# January 8, 2013 is a Tuesday

start_date = datetime.date(2013, 1, 7)
end_date = datetime.date(2013, 4, 25)

############################################################
###### Do not edit past this point                    ######
############################################################

def generate_dates(start_date, end_date):
    alldates = []
    td = datetime.timedelta(hours=24)
    current_date = start_date
    while current_date <= end_date:
        alldates.append(current_date)
        current_date += td
    return alldates

# Bump one day if we are a TR pattern.
all_days = generate_dates(start_date, end_date)

def getMonthName(date):
  d = dict((k,v) for k,v in enumerate(calendar.month_abbr))
  return d[date.month]

def getDayNumber(date):
  return date.day

def make_day (directory, day, date):
  if shouldMakeDays:
    pg = open ('%s/%s.md' % (directory, date), 'w')
    #pg.write('---\n')
    #pg.write('title: %s, %s\n' % (day, date))
    #pg.write('day: %s\n' % day)
    #pg.write('date: %s\n' % date)
    #pg.write('layout: minimal\n')
    #pg.write('---\n\n')
    #pg.write('# %s, %s %s' % (day, getMonthName(date), getDayNumber(date)))
    pg.write ('<!-- %s %s %s -->\n\n' % (date.strftime("%A"), getMonthName(date), getDayNumber(date)))
    pg.close()
  
def pad (n, places):
  i = places - len(str(n))
  padding = ""
  while i > 0:
    padding = '0%s' % padding
    i -= 1
  result = '%s%s' % (padding, n)
  return result
  
def make_week (directory, date, week_number, template, delta, count):
  if file_prefix == "":
    pg = open ('%s/%s-%s-%s-%s.md' \
              % (directory, date.strftime("%Y"), \
              date.strftime("%m"), pad(date.day, 2), pad(week_number, 2)), 'w')
  else:
    pg = open ('%s/%s-%s-%s-%s-%s.md' \
              % (directory, date.strftime("%Y"), \
              date.strftime("%m"), pad(date.day, 2), pad(week_number, 2),
              file_prefix), 'w')
              
  if (pattern == TR) or (pattern == T):
    date = date + datetime.timedelta(hours=24)
    
            
  pg.write('---\n')
  pg.write('title: Week %s \n' % week_number)
  pg.write('week: %s\n' % week_number)
  pg.write('category: week\n')
  pg.write('layout: post\n')
  pg.write('---\n\n')
  
  # We want to be able to put "due dates" in, so the
  # template will write this in for me.
  # pg.write('# Week %s\n\n' % (week_number))
  

  while count > 0:
    day_of_week = date.strftime("%A")
    pg.write('## %s, %s %s\n\n' % (day_of_week, getMonthName(date), getDayNumber(date)))
    #pg.write ('### Before Class\n\n')
    #pg.write ('### In Class\n\n')
    #pg.write ('### For Next Class\n\n\n')
    pg.write("%s" % template)
    pg.write ('<!-- # # # # # # # # # # # # # # # # # # # # # # # # # # # -->\n\n')
    
    date += datetime.timedelta(hours = (24*delta))
    count -= 1
  
  pg.close()

def inRange(i):
  return i < len(all_days)

intem = open('template.md', 'r')
template = intem.read()

# Pattern MWF
if pattern == MWF:
  i = 0
  week_number = 1
  while (inRange(i)):
    print all_days[i]
    make_day('days', 'Monday', all_days[i])
    make_week('weeks', all_days[i], week_number, template, 2, 3)
    week_number += 1
    i += 2
    if inRange(i):
      print all_days[i]
      make_day('days', 'Wednesday', all_days[i])
      i += 2
    if inRange(i):
      print all_days[i]
      make_day('days', 'Friday', all_days[i])
      # Skip to next Monday
      i += 3
      
# Pattern TR
elif pattern == TR:
  i = 0
  week_number = 1
  while (i < len(all_days)):
    print all_days[i]
    make_day('days', 'Tuesday', all_days[i])
    make_week('weeks', all_days[i], week_number, template, 2, 2)
    week_number += 1
    i += 2
    print all_days[i]
    make_day('days', 'Thursday', all_days[i])
    i += 5

# Pattern T
elif pattern == T:
  i = 0
  week_number = 1
  while (i < len(all_days)):
    print all_days[i]
    make_day('days', 'Tuesday', all_days[i])
    make_week('weeks', all_days[i], week_number, template, 2, 1)
    week_number += 1
    i += 7
