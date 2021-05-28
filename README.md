Simple macOS script intended to locate any panic files and parse them into something somewhat readable. 

While trying to read through panic logs, I'd found the easiest way was to copy and paste everything into an online xml formatter. I wanted an easier, simpler solution that I could do via Mosyle (or any remote shell command solution).

With a lot of trial and error, some google-fu, and a few rounds at the game of head-meets-brick-wall, I came up with the following:
```
cat $i s sed 's/^.*\(Stackshot.*kexts:\).*$/\1/' | sed 's/\\n/\
/g' | sed 's/\\/\
/g'
```

While this works, it does leave some thing to be desired. Missing the days of easily readable panics, and because of a request in MacAdmins watchmanmonitoring channel I was inspired to do this. It works great with the text of a panic I had from Catalina. 

Assuming you have Watchman Monitoring running, you could have a group set up in MDM based on having located kernel panics through that service.
