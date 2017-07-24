# wren-tempo

_A DateTime and Duration parsing, stringifying, and manipulation library_

__Warning:__ if cloning, make sure you've installed the `Recto` submodule

Exposes two Objects: `DateTime` and `Duration`, which can both be constructed with `unix` or `iso`

+ `DateTime.unix(_)`: input a number of seconds since Jan 1st 1970 and get a `DateTime` object
+ `DateTime.iso(_)`: input a string in the format `"2017-07-23T18:57:23Z"`and get a `DateTime`
+ `Duration.unix(_)`: input a number of seconds and get a `Duration`
+ `Duration.iso(_)`: input a string in the format `"2017-07-23T18:57:23Z"`, and get a `Duration`. doesn't really make sence, but what are you going to do..?

Currently lacks locales or timezones, please open an issue if you're using this library and need this functionality.

`toString` currently always formats the `Tempo` object as if it were a date, need to fix that

## ToDo:
+ [ ] duration `toString` formatting
+ [ ] less fragile iso string parseing
+ [ ] custom input/output string formats based on template strings
+ [ ] `fromNow` stringifer ( eg:`"3 days from now"` producer)
