import "./Recto/Recto" for Recto 

class Constants {
	static unixYear { 1970 }
	static unixStart { DateTime.unix(0) }
	static firstLeapYear { 1972 }
	static daysOfWeek { [ "Mon", "Tue", "Wed", "Thu", "Fri", "Say", "Sun",] }
}

class Tempo {
	second { seconds % 60 } //seconds since start of minute
	seconds { _seconds } // total seconds
	seconds=(val) { _seconds = val }

	minute { minutes % 60 } //minutes since start of hour
	minutes { ( seconds / 60 ).floor } //total minutes

	hour { hours % 24 } //hours since start of day
	hours { ( minutes / 60 ).floor } //total hours

	dayOfMonth { ( ( dayOfYear + leapAdjuster + 1 ) - ( ( ( month * 367 ) + 5 ) / 12 ) ).floor } //days since start of month
	dayOfWeek { ( days + 4 ) % 7 }
	dayOfYear { ( days - ( ( ( years * 1461 ) + 1 ) / 4 ).floor ) } //days since start of year
	days { ( hours / 24 ).floor } //total days 

	month { ( ( ( ( dayOfYear + leapAdjuster ) * 12 ) + 6 ) / 367 ).floor } //month of year

	year { years + 1970 } //years since epoch
	years { (((days * 4) + 2) / 1461 ).floor } // total years

	leapAdjuster { ( ( dayOfYear > 58 + leapNum ) ? ( leapBool ? 1 : 2 ) : 0) } //used for internal calculation
	leapBool { !( year % 3 ) }
	leapNum { leapBool ? 0 : 1 }

	toString {
		var monthLeadingZero = (month < 9) ? "0%(month + 1)" : "%(month + 1)"
		var dayLeadingZero = (dayOfMonth < 9) ? "0%(dayOfMonth + 1)" : "%(dayOfMonth + 1)"
		var hourLeadingZero = (hour < 9) ? "0%(hour)" : "%(hour)"
		var minuteLeadingZero = (minute < 9) ? "0%(minute)" : "%(minute)"
		var secondLeadingZero = (second < 9) ? "0%(second)" : "%(second)"
		return "%(year)-%(monthLeadingZero)-%(dayLeadingZero)T%(hourLeadingZero):%(minuteLeadingZero):%(secondLeadingZero)Z"
	}

	diff(other){ 
		if(this is Tempo){
			return Duration.unix(this.seconds + other.seconds)
		}

		Fiber.abort("Can only diff two Tempo objects")
	}

	+ (other){
		if(this is DateTime){
			if(other is Num){
				return DateTime.unix(this.seconds + other)

			} else if(other is Tempo){
				return DateTime.unix(this.seconds + other.seconds)
			}
		}

		if(this is Duration){
			if(other is Num){
				return Duration.unix(this.seconds + other)

			} else if(other is DateTime){
				return DateTime.unix(this.seconds + other.seconds)

			} else if(other is Duration){
				return Duration.unix(this.seconds + other.seconds)
			}
		}

		Fiber.abort("Can only perform arithmetic between a Tempo object an a Num/Tempo object")
	}

	- { 
	  if(this is DateTime){
		  return DateTime.unix( -this.seconds )
	  } else if(this is Duration){
		  return Duration.unix( -this.seconds )
	  }
	}

	- (other){ this + ( -other ) }

	<(other){ this.seconds < other.seconds }
	<=(other){ this.seconds <= other.seconds }
	==(other){ this.seconds == other.seconds }
	!=(other){ this.seconds != other.seconds }
	>=(other){ this.seconds >= other.seconds }
	>(other){ this.seconds > other.seconds }

	static parseISO(iso){
		//extract all the variables:
		var recto = Recto.new()

		var splitContainer = recto.split(iso, "T")
		var date = splitContainer[0]
		var time = splitContainer[1]

		splitContainer = recto.split(date, "-")
		var year = Num.fromString(splitContainer[0])
		var month = Num.fromString(splitContainer[1]) - 1
		var day = Num.fromString(splitContainer[2]) - 1

		splitContainer = recto.split(time, ":")
		var hour = Num.fromString(splitContainer[0])
		var minute = Num.fromString(splitContainer[1])
		var second = Num.fromString(splitContainer[2][0...-1])

		if(!year || !month || !day || !hour || !minute || !second){
			Fiber.abort("Currently needs a fully populate ISO date string in the format \"2017-07-23T18:57:23Z\", you input: %(iso)")
		}

		//create a seconds accumulator, and start adding all the composite parts of the DateTime
		var seconds = second
		seconds = seconds + ( minute * 60 )
		seconds = seconds + ( hour * 60 * 60 )
		seconds = seconds + ( day * 60 * 60 * 24 )

		var unixYear = year - 1970
		seconds = seconds + ( unixYear * 60 * 60 * 24 * 365 )
		var leapBool = !( ( unixYear - 2 ) % 3 )

		var leapYearsSinceUnix = ( ( unixYear - 2 ) / 4 ).floor + 1
		seconds = seconds + ( leapYearsSinceUnix * 60 * 60 * 24 )

		var monthLengths = [ 31, ( leapBool ? 29 : 28 ), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ][0..month][0...-1]

		var daysFromMonths = monthLengths.reduce {|x, y| (x + y) }
		seconds = seconds + ( daysFromMonths * 60 * 60 * 24 )

		return seconds
	}
}

class DateTime is Tempo {
	construct unix(seconds){
		super.seconds = seconds 
	}

	construct iso(isoString){
		super.seconds = Tempo.parseISO(isoString)
	}
}

class Duration is Tempo {
	construct unix(seconds){
		super.seconds = seconds
	}

	construct iso(isoString){
		super.seconds = Tempo.parseISO(isoString)
	}
}
