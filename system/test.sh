python main.py -data fmnist -m cnn -algo FedAvg -gr 100 -nc 58 -did 0 -mv 100 -mal True 2>&1 | tee "command1.log"

cat "command1.log" > "log_NormalSelection_Malicious.txt"

mv saida.txt "NormalSelection_Malicious.txt"
mv NormalSelection_Malicious.txt log_NormalSelection_Malicious.txt ./saidas/

python main.py -data fmnist -m cnn -algo FedAvg -gr 100 -nc 58 -did 0 -pow True 2>&1 | tee "command2.log"

cat "command2.log" > "log_Power_of_Choice.txt"

mv saida.txt "Power_of_Choice.txt"
mv log_Power_of_Choice.txt Power_of_Choice.txt ./saidas/

rm "command1.log" "command2.log"