
x=$1

echo -ne '                         (0%)\r'
# sleep `bc <<< "scale=2; $x/10"`
echo -ne '██                      (10%)\r'
sleep `bc <<< "scale=2; $x/10"`
echo -ne '████                    (20%)\r'
sleep `bc <<< "scale=2; $x/10"`
echo -ne '██████                  (30%)\r'
sleep `bc <<< "scale=2; $x/10"`
echo -ne '████████                (40%)\r'
sleep `bc <<< "scale=2; $x/10"`
echo -ne '██████████              (50%)\r'
sleep `bc <<< "scale=2; $x/10"`
echo -ne '████████████            (60%)\r'
sleep `bc <<< "scale=2; $x/10"`
echo -ne '██████████████          (70%)\r'
sleep `bc <<< "scale=2; $x/10"`
echo -ne '████████████████        (80%)\r'
sleep `bc <<< "scale=2; $x/10"`
echo -ne '██████████████████      (90%)\r'
sleep `bc <<< "scale=2; $x/10"`
echo -ne '████████████████████   (100%)\r'
echo -ne '\n'
