# sh

## concatenate strings
```
# basic string concatenate $varName
str1="Hello, "
str2="World!"
greeting="$str1$str2"
echo $greeting

# use curly braces to make var look cleared
username="alice"
echo "Welcome, ${username}!"

# concatenate file path
file_prefix="photo"
file_suffice=".jpg"
file_name="${file_prefix}_$(date +%y%m%d)${file_suffix}"
echo "file name is ${file_name}"

# put command in () to be executed then capture as var
dateFormat=$(date)
echo "dateFormat is ${dateFormat}"
# dateFormat is Thu Apr  3 15:23:54 +08 2025


#conca full path
dir="/var/log"
filename="$(date +%y%m%d)_report.log"
full_path="${dir}/${filename}"
echo "full path is ${full_path}"
```
