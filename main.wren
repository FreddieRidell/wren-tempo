import "tempo" for DateTime, Duration

System.print("2017-07-23T18:57:23Z")

var nowishUnix = DateTime.unix(1500836243)
System.print(nowishUnix)

var nowishIso = DateTime.iso("2017-07-23T18:57:23Z")
System.print(nowishIso)

var oneDayLong = Duration.unix(60 * 60 * 24)
System.print(nowishUnix + oneDayLong)
System.print(nowishUnix - oneDayLong)

System.print( nowishIso == nowishUnix )
System.print( nowishIso == ( nowishUnix + oneDayLong ) )
System.print( nowishIso < ( nowishUnix + oneDayLong ) )
System.print( nowishIso > ( nowishUnix + oneDayLong ) )
