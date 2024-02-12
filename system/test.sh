python main.py -data fmnist -m cnn -algo FedAvg -gr 100 -nc 58  -did 0 -pow True 2>&1 | tee "command1.log"
    
    cat "command1.log" > "log_Power-of-Choice.txt"

    mv saida.txt "Power-of-Choice.txt"
    mv Power-of-Choice.txt log_Power-of-Choice.txt ./saidas/


cdr_values=(0.16 0.33 0.50)
jr_values=(0.15 0.20 0.25)
for cdr_value in "${cdr_values[@]}"; do
    for jr_value in "${jr_values[@]}"; do
    
        python main.py -data fmnist -m cnn -algo FedAvg -gr 100 -nc 58 -jr "$jr_value" -pow True -cdr "$cdr_value" -did 0 2>&1 | tee "command1_$cdr_value+_$jr_value.log"
        
        cat "command1_$cdr_value+_$jr_value.log" > "log_Power-of-Choice$cdr_value+_$jr_value.txt"

        mv saida.txt "Power-of-Choice_$cdr_value+_$jr_value.txt"
        mv Power-of-Choice_$cdr_value+_$jr_value.txt log_Power-of-Choice$cdr_value+_$jr_value.txt ./saidas/


        rm "command1_$cdr_value+_$jr_value.log"
    done
done